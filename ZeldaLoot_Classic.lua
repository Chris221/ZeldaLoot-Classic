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
		-- Restore before re-saving the original for the new sound, so a rapid
		-- re-trigger never saves an already-scaled value as the "original".
		Restore_sound_volume()
	end

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

local ZL_QUALITY_COLORS = {
	["cff1eff00"] = { quality = 3, group = "green" },   -- Uncommon (green)
	["cff0070dd"] = { quality = 4, group = "blue" },    -- Rare (blue)
	["cffa335ee"] = { quality = 5, group = "purple" },  -- Epic (purple)
	["cffff8000"] = { quality = 6, group = "orange" },  -- Legendary (orange)
	["cffe6cc80"] = { quality = 6, group = "orange", inherited = true }, -- Heirloom
}

-- Loot detection is driven by Blizzard's own localized global strings rather than
-- hardcoded English text, so it stays correct in every locale. Each format string
-- (e.g. "You receive loot: %s.") is reduced to its longest literal run so we can do
-- a plain substring match against the CHAT_MSG_LOOT line regardless of where the
-- %s/%d placeholders sit in a given locale. The old locale keys are kept as a
-- fallback for the unlikely case a global string is missing on some client.
local function Longest_literal(fmt)
	if (not fmt) then return nil end

	-- Replace format specifiers (%s, %d, %1$s, %2$d, %.2f, ...) with a separator,
	-- then keep the longest remaining literal piece.
	local stripped = fmt:gsub("%%%d-%$?%-?%d*%.?%d*[%a]", "\1")
	local longest = ""
	for piece in string.gmatch(stripped, "[^\1]+") do
		piece = piece:gsub("^%s+", ""):gsub("%s+$", "")
		if (#piece > #longest) then longest = piece end
	end

	if (longest == "") then return nil end
	return longest
end

-- global_fmts: Blizzard format strings to derive literals from.
-- fallback: a locale literal used ONLY if no global produced a literal.
-- always: extra literal(s) always included (for cases with no global equivalent).
local function Build_loot_match(global_fmts, fallback, always)
	local literals = {}
	for _, fmt in ipairs(global_fmts) do
		local lit = Longest_literal(fmt)
		if (lit) then table.insert(literals, lit) end
	end
	if (#literals == 0 and fallback) then
		table.insert(literals, fallback)
	end
	if (always) then
		table.insert(literals, always)
	end
	return literals
end

local ZL_LOOT_MATCH = {
	-- Items looted from a corpse/object (the always-on "active" category)
	loot     = Build_loot_match({ LOOT_ITEM_SELF, LOOT_ITEM_SELF_MULTIPLE }, ZL_LOOTMESSAGE),
	-- Items produced by crafting / professions. ZL_CRAFTMESSAGE2 ("You receive
	-- object") has no global equivalent, so it is always kept.
	crafted  = Build_loot_match({ LOOT_ITEM_CREATED_SELF, LOOT_ITEM_CREATED_SELF_MULTIPLE }, ZL_CRAFTMESSAGE, ZL_CRAFTMESSAGE2),
	-- Items pushed to your bags (quests, mail, trade, vendor, etc.)
	received = Build_loot_match({ LOOT_ITEM_PUSHED_SELF, LOOT_ITEM_PUSHED_SELF_MULTIPLE }, ZL_RECEIVEMESSAGE),
}

local function Matches_loot(msg, literals)
	for _, lit in ipairs(literals) do
		if (string.find(msg, lit, 1, true)) then
			return true
		end
	end
	return false
end

function ZeldaFrame_OnEvent(self, event, ...)
	local quality, zl_group

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

	if (event == "CHAT_MSG_LOOT") then
		for colorCode, info in pairs(ZL_QUALITY_COLORS) do
			if (string.find(arg1, colorCode, 1, true)) then
				if (info.inherited and not ZL_config["inherited"]["include"]) then
					break
				end
				quality = info.quality
				zl_group = info.group
				break
			end
		end

		if (quality and zl_group and ZL_config[zl_group]["active"]) then
			if (
				Matches_loot(arg1, ZL_LOOT_MATCH.loot) or
				(ZL_config[zl_group]["crafted"] and Matches_loot(arg1, ZL_LOOT_MATCH.crafted)) or
				(ZL_config[zl_group]["received"] and Matches_loot(arg1, ZL_LOOT_MATCH.received))
			) then
				Play_zeldaSound(quality - 1, ZL_config[zl_group]["sound"])
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