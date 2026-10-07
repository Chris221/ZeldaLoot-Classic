function ZL_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(ZL_AddonColor .. ZL_AddonName .. '|r ' .. tostring(msg))
end

-- PlaySoundFile has no per-sound volume argument on any client, so the Volume
-- setting works by temporarily scaling the chosen audio channel's CVar while a
-- sound plays, then restoring it. This scales the whole channel for the restore
-- window, which is an inherent limitation of having no per-sound gain API.
local CHANNEL_CVARS = {
	Master   = "Sound_MasterVolume",
	SFX      = "Sound_SFXVolume",
	Music    = "Sound_MusicVolume",
	Ambience = "Sound_AmbienceVolume",
	Dialog   = "Sound_DialogVolume",
}

-- nil when idle, else { cvar = <name>, original = <string value>, scaled = <number> }
local ZL_volume_restore = nil
-- bumped on every scaled playback so only the latest timer restores
local ZL_volume_token = 0

-- Puts the channel back to its pre-scaling value, but only if it still holds
-- the value we set: a change the player made meanwhile (e.g. in Blizzard's
-- Sound settings) wins and is kept.
local function Restore_sound_volume()
	local pending = ZL_volume_restore
	if (pending ~= nil) then
		local current = tonumber(GetCVar(pending.cvar))
		if (current and math.abs(current - pending.scaled) < 0.001) then
			SetCVar(pending.cvar, pending.original)
		end
		ZL_volume_restore = nil
	end
end

function Play_zeldaSound(index, sound_file)
	local sound_set = Get_sound_set(index)
	local willPlay = nil
	local sound_ext = Get_sound_ext()
	local sound_channel = Get_sound_channel()
	local warning_text = ""

	-- Defensive: never request a sound the active set doesn't ship
	sound_file = Get_clamped_sound(sound_set, sound_file)

	if (ZL_soundHandle ~= 0 and ZL_soundHandle ~= nil) then
		if (ZL_debug_bool) then
			ZL_Print(ZL_STOPPING_SOUND .. " " .. ZL_soundHandle)
		end
		StopSound(ZL_soundHandle, 0)
	end

	-- Restore before re-saving the original for the new sound, so a rapid
	-- re-trigger never saves an already-scaled value as the "original". Runs
	-- outside the handle guard because a failed PlaySoundFile (e.g. muted
	-- channel) leaves no handle, and the stale timer would otherwise restore
	-- full volume mid-playback of the next sound.
	Restore_sound_volume()

	if (ZL_warning_bool) then
		warning_text = "|cffffff00" .. ZL_WARNING .. "|r "
	end

	Update_config(false)

	-- At 0% there is nothing to hear, so don't play at all rather than muting
	-- the whole channel for the length of the sound
	local volume = Get_sound_volume()
	if (volume == 0) then
		return
	end

	-- Temporarily scale the channel volume for this playback (no-op at 100%).
	-- Restore_sound_volume above has already cleared any previous scaling.
	if (volume < 100) then
		local cvar = CHANNEL_CVARS[sound_channel]
		if (cvar) then
			local original = GetCVar(cvar)
			local scaled = (tonumber(original) or 1) * volume / 100
			SetCVar(cvar, tostring(scaled))
			-- Remember what the client actually stored (it may round), so the
			-- "still untouched?" check in Restore_sound_volume can match it
			scaled = tonumber(GetCVar(cvar)) or scaled
			ZL_volume_restore = { cvar = cvar, original = original, scaled = scaled }

			ZL_volume_token = ZL_volume_token + 1
			local myToken = ZL_volume_token
			local durations = ZL_SOUND_DURATIONS[sound_set]
			local duration = durations and durations[sound_file] or 20
			C_Timer.After(duration + ZL_VOLUME_RESTORE_MARGIN, function()
				if (myToken == ZL_volume_token) then
					Restore_sound_volume()
				end
			end)
		end
	end

	willPlay, ZL_soundHandle = PlaySoundFile("Interface\\AddOns\\ZeldaLoot_Classic\\Sounds\\Sets\\" .. sound_set .. "\\" .. sound_file .. "." .. sound_ext, sound_channel)

	local mess = "[" .. sound_set .. "\\" .. sound_file .. "." .. sound_ext .. "] " .. ZL_ON_SOUND_CHANNEL .. " [" .. sound_channel .. "]"
	if (willPlay) then
		if (ZL_debug_bool) then
			ZL_Print(ZL_STARTING_SOUND .. " " .. mess)
		end
	else
		-- Nothing is playing, so don't leave the channel quieter until the timer
		Restore_sound_volume()
		if (ZL_warning_bool or ZL_debug_bool) then
			ZL_Print(warning_text .. ZL_NOT_PLAYING .. " " .. mess .. " " .. ZL_LIKELY_DUE_TO .. " [" .. sound_channel .. "] " .. ZL_BEING_MUTED)
		end
	end
end

-- Item quality enum values with special handling (2-5 map straight to a group
-- through ZL_QUALITY_GROUPS).
local ZL_ARTIFACT_QUALITY = 6
local ZL_HEIRLOOM_QUALITY = 7

-- Link colors on clients that still color item links with a hex code.
local ZL_LEGACY_QUALITY_COLORS = {
	["cff1eff00"] = 2, -- Uncommon
	["cff0070dd"] = 3, -- Rare
	["cffa335ee"] = 4, -- Epic
	["cffff8000"] = 5, -- Legendary
	["cffe6cc80"] = ZL_HEIRLOOM_QUALITY, -- Heirloom on Classic flavors
	["cff00ccff"] = ZL_HEIRLOOM_QUALITY, -- Heirloom on modern clients
}

-- Since Retail 11.1.5 (and on Forever) item links carry the quality enum
-- directly as "|cnIQ<n>" so players can recolor qualities; older clients
-- use a fixed hex color.
local function Chat_quality(msg)
	local quality = tonumber(msg:match("|cnIQ(%d+)"))
	if (quality) then return quality end
	for colorCode, legacy_quality in pairs(ZL_LEGACY_QUALITY_COLORS) do
		if (string.find(msg, colorCode, 1, true)) then
			return legacy_quality
		end
	end
	return nil
end

-- Item quality -> Play_zeldaSound index, applying the Inherited and
-- per-quality on/off settings. nil means no sound. Shared by the chat path
-- and the loot-window fallback so both classify items the same way.
local function Quality_sound_index(quality)
	if (quality == ZL_HEIRLOOM_QUALITY) then
		if (not ZL_config["inherited"]["include"]) then return nil end
		quality = 5 -- heirlooms use the orange sound
	elseif (quality == ZL_ARTIFACT_QUALITY) then
		quality = 5 -- artifacts use the orange sound
	end
	local group = ZL_QUALITY_GROUPS[quality]
	if (group and ZL_config[group]["active"]) then
		return quality
	end
	return nil
end

-- Loot detection is driven by Blizzard's own localized global strings rather than
-- hardcoded English text, so it stays correct in every locale. Each "self" format
-- string (e.g. "You receive loot: %s.") is reduced to one literal run that is
-- matched against the CHAT_MSG_LOOT line, wherever the %s/%d placeholders sit in a
-- given locale. The old locale keys are kept as a fallback for the unlikely case a
-- global string is missing on some client.
--
-- Another player's loot line often contains the self literal too (koKR self loot
-- is "아이템을 획득했습니다: %s", party loot "%s 님이 아이템을 획득했습니다: %s"), so
-- each literal also records where it must sit:
--   "start" - the format opens with this literal, so the line must too;
--   "link"  - the format opens with the item placeholder, so the line must open
--             with an item link (another player's line opens with their name);
--   nil     - plain substring match (locale fallbacks).
local function Loot_literal(fmt)
	if (not fmt) then return nil end

	-- Replace format specifiers (%s, %d, %1$s, %2$d, %.2f, ...) with a separator.
	local stripped = fmt:gsub("%%%d-%$?%-?%d*%.?%d*[%a]", "\1")
	-- Grammar tokens are resolved by the client before the message is shown, so
	-- they must never end up inside a literal: ruRU declension wrappers like
	-- "|3-6(%s)" (the placeholder is already \1 here) and koKR particle tokens
	-- like "|1을;를;".
	stripped = stripped:gsub("|%d+%-%d+%(\1%)", "\1")
	stripped = stripped:gsub("|%d+[^;]*;[^;]*;", "\1")

	local leading = stripped:match("^([^\1]+)")
	if (leading) then
		leading = leading:gsub("%s+$", "")
		if (leading ~= "") then
			return { text = leading, anchor = "start" }
		end
	end

	local longest = ""
	for piece in string.gmatch(stripped, "[^\1]+") do
		piece = piece:gsub("^%s+", ""):gsub("%s+$", "")
		if (#piece > #longest) then longest = piece end
	end

	if (longest == "") then return nil end
	return { text = longest, anchor = "link" }
end

-- global_fmts: Blizzard format strings to derive literals from. It may hold
-- globals that are nil on some clients, so it carries its own count (n).
-- ...: locale literals used ONLY if no global produced a literal. They are
-- plain substrings, so they must never be matched alongside the globals:
-- e.g. frFR "Vous recevez l'objet" would also match received items.
local function Build_loot_match(global_fmts, ...)
	local literals = {}
	for i = 1, global_fmts.n do
		local lit = Loot_literal(global_fmts[i])
		if (lit) then table.insert(literals, lit) end
	end
	if (#literals == 0) then
		for i = 1, select("#", ...) do
			local fallback = select(i, ...)
			if (fallback) then table.insert(literals, { text = fallback }) end
		end
	end
	return literals
end

local ZL_LOOT_MATCH = {
	-- Items looted from a corpse/object or won with a bonus roll (the always-on
	-- "active" category). The bonus-roll globals don't exist on every client.
	loot     = Build_loot_match({ n = 4, LOOT_ITEM_SELF, LOOT_ITEM_SELF_MULTIPLE,
		LOOT_ITEM_BONUS_ROLL_SELF, LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE }, ZL_LOOTMESSAGE),
	-- Items produced by crafting / professions
	crafted  = Build_loot_match({ n = 2, LOOT_ITEM_CREATED_SELF, LOOT_ITEM_CREATED_SELF_MULTIPLE }, ZL_CRAFTMESSAGE, ZL_CRAFTMESSAGE2),
	-- Items pushed to your bags (quests, mail, trade, vendor, etc.). On koKR
	-- these formats are identical to the loot ones, so there every received
	-- item counts as looted and the Received toggle has no effect.
	received = Build_loot_match({ n = 2, LOOT_ITEM_PUSHED_SELF, LOOT_ITEM_PUSHED_SELF_MULTIPLE }, ZL_RECEIVEMESSAGE),
}

local function Matches_loot(msg, literals)
	for _, lit in ipairs(literals) do
		local pos = string.find(msg, lit.text, 1, true)
		if (pos and (
			(lit.anchor == "start" and pos == 1) or
			(lit.anchor == "link" and string.sub(msg, 1, 2) == "|c") or
			lit.anchor == nil
		)) then
			return true
		end
	end
	return false
end

-- Midnight and Forever hand CHAT_MSG_LOOT text to addons as a secret value
-- during boss encounters, M+ keys and PvP matches, and string functions throw
-- on it. issecretvalue only exists on those clients, so Classic never takes
-- these paths. While chat is secret, corpse/chest loot is recovered from the
-- loot window instead: slot qualities and icons are snapshotted on
-- LOOT_OPENED, and a looted slot plays only if, within ZL_SECRET_LOOT_WINDOW
-- of it, both a secret loot message arrived (so readable chat, which plays
-- through the normal path, never plays a sound twice) and an ITEM_PUSH with
-- the same icon put an item in the player's own bags (so a slot another
-- player takes from a shared corpse stays silent). Each slot is judged once
-- its window has fully passed, so a push or chat line that lags the clear
-- still counts. Loot that skips the loot window (personal boss loot, crafts,
-- quest rewards) has nothing to read and stays silent while chat is secret.
local ZL_SECRET_LOOT_WINDOW = 1
local ZL_loot_slots = {} -- slot -> { quality = <enum>, icon = <fileID> }
local ZL_secret_chats = {} -- { time } of recent secret CHAT_MSG_LOOT lines
local ZL_item_pushes = {} -- { icon, time } of recent ITEM_PUSH events
local ZL_cleared_slots = {} -- { index, icon, time } waiting to be judged
local ZL_loot_timer_pending = false

local function Is_secret(value)
	return issecretvalue ~= nil and issecretvalue(value)
end

local function Within_window(a, b)
	return math.abs(a - b) <= ZL_SECRET_LOOT_WINDOW
end

-- Drop entries too old to match anything still waiting, so lists stay small
local function Prune(list, now)
	for i = #list, 1, -1 do
		if (now - list[i].time > 3 * ZL_SECRET_LOOT_WINDOW) then
			table.remove(list, i)
		end
	end
end

local function Secret_chat_near(time)
	for _, chat in ipairs(ZL_secret_chats) do
		if (Within_window(chat.time, time)) then return true end
	end
	return false
end

-- Finds and consumes the push that put this slot's item in the player's bags
local function Take_push(cleared)
	for i, push in ipairs(ZL_item_pushes) do
		if (push.icon == cleared.icon and Within_window(push.time, cleared.time)) then
			table.remove(ZL_item_pushes, i)
			return true
		end
	end
	return false
end

local Play_pending_loot

local function Schedule_loot_check()
	if (not ZL_loot_timer_pending) then
		ZL_loot_timer_pending = true
		C_Timer.After(ZL_SECRET_LOOT_WINDOW, Play_pending_loot)
	end
end

-- Auto-loot clears several slots at once; play only the best one that went
-- into the player's own bags
Play_pending_loot = function()
	ZL_loot_timer_pending = false
	local now = GetTime()
	local best = nil
	local waiting = {}
	for _, cleared in ipairs(ZL_cleared_slots) do
		if (now - cleared.time < ZL_SECRET_LOOT_WINDOW) then
			table.insert(waiting, cleared) -- its push or chat line may still arrive
		elseif (Secret_chat_near(cleared.time) and Take_push(cleared)) then
			if (best == nil or cleared.index > best) then best = cleared.index end
		end
	end
	ZL_cleared_slots = waiting
	Prune(ZL_secret_chats, now)
	Prune(ZL_item_pushes, now)
	if (#waiting > 0) then Schedule_loot_check() end

	if (best) then
		Play_zeldaSound(best, ZL_config[ZL_QUALITY_GROUPS[best]]["sound"])
	end
end

-- Every value read from the client is checked with Is_secret before it is
-- compared, indexed or looped on, since any of those throws on a secret.
local function Snapshot_loot_window()
	wipe(ZL_loot_slots)
	local count = GetNumLootItems()
	if (Is_secret(count)) then return end
	for slot = 1, count do
		local icon, _, _, _, quality = GetLootSlotInfo(slot)
		if (not Is_secret(quality) and not Is_secret(icon) and quality ~= nil and icon ~= nil) then
			ZL_loot_slots[slot] = { quality = quality, icon = icon }
		end
	end
end

local function On_loot_slot_cleared(slot)
	if (Is_secret(slot)) then return end
	local info = ZL_loot_slots[slot]
	ZL_loot_slots[slot] = nil
	local index = info and Quality_sound_index(info.quality)
	if (not index) then return end

	table.insert(ZL_cleared_slots, { index = index, icon = info.icon, time = GetTime() })
	Schedule_loot_check()
end

local function On_item_push(icon)
	if (Is_secret(icon) or icon == nil) then return end
	local now = GetTime()
	Prune(ZL_item_pushes, now)
	table.insert(ZL_item_pushes, { icon = icon, time = now })
end

local function On_secret_loot_chat()
	local now = GetTime()
	Prune(ZL_secret_chats, now)
	table.insert(ZL_secret_chats, { time = now })
end

function ZeldaFrame_OnEvent(self, event, ...)
	local arg1 = select(1, ...)

	if ((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_Classic")) then
		-- This will move to the correct global
		if (ZL_config == nil and zl_config ~= nil) then
			ZL_config = zl_config
		end

		Update_config(false)
		ZL_Print(ZL_AddonVersion .. ZL_LOADED)
		ZL_Print(ZL_LOADED_TEXT_1)
		ZL_Print(ZL_LOADED_TEXT_2)
		if (ZL_debug_bool) then
			ZL_Print(ZL_DEBUG_ENABLED)
		end

		local panel = _G["ZL_configPanel"]
		panel.name = ZL_AddonName

		if Settings and Settings.RegisterCanvasLayoutCategory then
			local category = Settings.RegisterCanvasLayoutCategory(panel, ZL_AddonName)
			Settings.RegisterAddOnCategory(category)
			ZL_SettingsCategory = category
		elseif InterfaceOptions_AddCategory then
			InterfaceOptions_AddCategory(panel, true)
			if InterfaceAddOnsList_Update then
				InterfaceAddOnsList_Update()
			end
		end
	end

	if (((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_Classic")) or (event == "PLAYER_LOGOUT")) then
		if ((ZL_config == nil)) then
			-- First initialization
			Reset_config(false)
		end

		if (event == "PLAYER_LOGOUT") then
			-- Never leave a temporarily-scaled channel volume persisted across sessions
			Restore_sound_volume()
		else
			Sync_panel_widgets()
		end
	end

	-- With auto-loot, LOOT_READY can fire and slots can clear before LOOT_OPENED
	if (event == "LOOT_READY" or event == "LOOT_OPENED") then
		if (issecretvalue) then Snapshot_loot_window() end
		return
	end

	if (event == "LOOT_SLOT_CLEARED") then
		if (issecretvalue) then On_loot_slot_cleared(arg1) end
		return
	end

	if (event == "ITEM_PUSH") then
		if (issecretvalue) then On_item_push(select(2, ...)) end
		return
	end

	if (event == "CHAT_MSG_LOOT") then
		if (Is_secret(arg1)) then
			On_secret_loot_chat()
			return
		end

		local quality = Chat_quality(arg1)
		local index = quality and Quality_sound_index(quality)
		if (index) then
			local zl_group = ZL_QUALITY_GROUPS[index]
			if (
				Matches_loot(arg1, ZL_LOOT_MATCH.loot) or
				(ZL_config[zl_group]["crafted"] and Matches_loot(arg1, ZL_LOOT_MATCH.crafted)) or
				(ZL_config[zl_group]["received"] and Matches_loot(arg1, ZL_LOOT_MATCH.received))
			) then
				Play_zeldaSound(index, ZL_config[zl_group]["sound"])
			end
		end
	end
end

function Reset_config(print_text)
	ZL_config = {
		green = {
			active   = true,
			received = true,
			crafted  = true,
			set = 0,
			sound = 1
		},

		blue = {
			active   = true,
			received = true,
			crafted  = true,
			set = 0,
			sound = 2
		},

		purple = {
			active   = true,
			received = true,
			crafted  = true,
			set = 0,
			sound = 3
		},

		orange = {
			active   = true,
			received = true,
			crafted  = true,
			set = 0,
			sound = 4
		},

		inherited = {
			include  = true
		},

		settings = {
			ext = "wav",
			channel = "SFX",
			volume = ZL_DEFAULT_VOLUME
		},

		version = ZL_CONFIG_VERSION
	}

	if (ZL_debug_bool) then
		ZL_debug_bool = false
		ZL_Print(ZL_RESET_DEBUG_TEXT)
	end

	if (ZL_warning_bool ~= true) then
		ZL_warning_bool = true
		ZL_Print(ZL_RESET_WARNING_TEXT)
	end

	if (print_text) then
		ZL_Print(ZL_RESET_DONE)
	end

	-- Refresh an open panel so it never shows stale values after a reset
	Sync_panel_widgets()
end