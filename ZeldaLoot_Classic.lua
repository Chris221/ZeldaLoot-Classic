function ZL_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(ZL_AddonColor .. ZL_AddonName .. '|r ' .. tostring(msg))
end

function Play_zeldaSound(index, sound_file)
	local sound_set = Get_sound_set(index)
	local willPlay = nil
	local sound_ext = Get_sound_ext()
	local sound_channel = Get_sound_channel()
	local warning_text = ""

	if (ZL_soundHandle ~= 0 and ZL_soundHandle ~= nil) then
		if (ZL_debug_bool) then
			ZL_Print(ZL_STOPPING_SOUND .. " " .. ZL_soundHandle)
		end
		StopSound(ZL_soundHandle, 0)
	end

	if (ZL_warning_bool) then
		warning_text = "|cffffff00" .. ZL_WARNING .. "|r "
	end

	Update_config(false)

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

		if (event ~= "PLAYER_LOGOUT") then
			Sync_panel_widgets()
		end
	end

	if (event == "CHAT_MSG_LOOT") then
		for colorCode, info in pairs(ZL_QUALITY_COLORS) do
			if (string.find(arg1, colorCode)) then
				if (info.inherited and not ZL_config["inherited"]["include"]) then
					break
				end
				quality = info.quality
				zl_group = info.group
				break
			end
		end

		if (quality and zl_group) then
			if (ZL_config[zl_group]["active"]) then
				if (
					(string.find(arg1, ZL_LOOTMESSAGE)) or
					(((string.find(arg1, ZL_CRAFTMESSAGE)) or (string.find(arg1, ZL_CRAFTMESSAGE2))) and ZL_config[zl_group]["crafted"]) or
					((string.find(arg1, ZL_RECEIVEMESSAGE)) and ZL_config[zl_group]["received"])
				) then
					Play_zeldaSound(quality - 1, ZL_config[zl_group]["sound"])
				end
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
			channel = "SFX"
		},

		version = 1
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