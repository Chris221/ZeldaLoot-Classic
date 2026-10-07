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

-- nil when idle, else { cvar = <name>, original = <string value> }
local ZL_volume_restore = nil
-- bumped on every scaled playback so only the latest timer restores
local ZL_volume_token = 0

local function Restore_sound_volume()
	if (ZL_volume_restore ~= nil) then
		SetCVar(ZL_volume_restore.cvar, ZL_volume_restore.original)
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

	-- Temporarily scale the channel volume for this playback (no-op at 100%)
	local volume = Get_sound_volume()
	if (volume < 100) then
		local cvar = CHANNEL_CVARS[sound_channel]
		if (cvar and ZL_volume_restore == nil) then
			local original = GetCVar(cvar)
			ZL_volume_restore = { cvar = cvar, original = original }
			SetCVar(cvar, tostring((tonumber(original) or 1) * volume / 100))

			ZL_volume_token = ZL_volume_token + 1
			local myToken = ZL_volume_token
			C_Timer.After(ZL_VOLUME_RESTORE_DELAY, function()
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
	elseif (ZL_warning_bool or ZL_debug_bool) then
		ZL_Print(warning_text .. ZL_NOT_PLAYING .. " " .. mess .. " " .. ZL_LIKELY_DUE_TO .. " [" .. sound_channel .. "] " .. ZL_BEING_MUTED)
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
-- fallback: a locale literal used ONLY if no global produced a literal.
-- always: extra literal(s) always included (for cases with no global equivalent).
local function Build_loot_match(global_fmts, fallback, always)
	local literals = {}
	for i = 1, global_fmts.n do
		local lit = Loot_literal(global_fmts[i])
		if (lit) then table.insert(literals, lit) end
	end
	if (#literals == 0 and fallback) then
		table.insert(literals, { text = fallback })
	end
	if (always) then
		table.insert(literals, { text = always })
	end
	return literals
end

local ZL_LOOT_MATCH = {
	-- Items looted from a corpse/object or won with a bonus roll (the always-on
	-- "active" category). The bonus-roll globals don't exist on every client.
	loot     = Build_loot_match({ n = 4, LOOT_ITEM_SELF, LOOT_ITEM_SELF_MULTIPLE,
		LOOT_ITEM_BONUS_ROLL_SELF, LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE }, ZL_LOOTMESSAGE),
	-- Items produced by crafting / professions. ZL_CRAFTMESSAGE2 ("You receive
	-- object") has no global equivalent, so it is always kept.
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
-- loot window instead: slot qualities are snapshotted on LOOT_OPENED, and a
-- looted slot only plays if a secret loot message lands within
-- ZL_SECRET_LOOT_WINDOW of it, so readable chat never plays a sound twice.
-- An ITEM_PUSH (an item entering the player's own bags) must land in the same
-- window, so a slot another player takes from a shared corpse stays silent.
-- Loot that skips the loot window (personal boss loot, crafts, quest
-- rewards) has nothing to read and stays silent while chat is secret.
local ZL_SECRET_LOOT_WINDOW = 0.5
local ZL_loot_slot_quality = {}
local ZL_last_secret_loot = nil -- GetTime() of the last secret CHAT_MSG_LOOT
local ZL_last_item_push = nil -- GetTime() of the last ITEM_PUSH
local ZL_pending_loot_index = nil -- best sound index looted in this window
local ZL_pending_loot_time = 0

local function Is_secret(value)
	return issecretvalue ~= nil and issecretvalue(value)
end

local function Play_pending_loot()
	local index = ZL_pending_loot_index
	ZL_pending_loot_index = nil
	if (index and ZL_last_secret_loot and ZL_last_item_push and
		math.abs(ZL_last_secret_loot - ZL_pending_loot_time) <= ZL_SECRET_LOOT_WINDOW and
		math.abs(ZL_last_item_push - ZL_pending_loot_time) <= ZL_SECRET_LOOT_WINDOW) then
		Play_zeldaSound(index, ZL_config[ZL_QUALITY_GROUPS[index]]["sound"])
	end
end

-- Every value read from the client is checked with Is_secret before it is
-- compared, indexed or looped on, since any of those throws on a secret.
local function Snapshot_loot_window()
	wipe(ZL_loot_slot_quality)
	local count = GetNumLootItems()
	if (Is_secret(count)) then return end
	for slot = 1, count do
		local quality = select(5, GetLootSlotInfo(slot))
		if (not Is_secret(quality) and quality ~= nil) then
			ZL_loot_slot_quality[slot] = quality
		end
	end
end

local function On_loot_slot_cleared(slot)
	if (Is_secret(slot)) then return end
	local quality = ZL_loot_slot_quality[slot]
	ZL_loot_slot_quality[slot] = nil
	local index = quality and Quality_sound_index(quality)
	if (not index) then return end

	-- Auto-loot clears several slots at once; play only the best one
	if (ZL_pending_loot_index == nil) then
		ZL_pending_loot_time = GetTime()
		C_Timer.After(ZL_SECRET_LOOT_WINDOW, Play_pending_loot)
	end
	if (ZL_pending_loot_index == nil or index > ZL_pending_loot_index) then
		ZL_pending_loot_index = index
	end
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
			category.ID = ZL_AddonName
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
		if (issecretvalue) then ZL_last_item_push = GetTime() end
		return
	end

	if (event == "CHAT_MSG_LOOT") then
		if (Is_secret(arg1)) then
			ZL_last_secret_loot = GetTime()
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
			volume = 100
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