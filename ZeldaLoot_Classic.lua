AddonVersion = "|cff00ff002.0.0|r"
ZL_AddonName = "ZeldaLoot Classic"
ZL_AddonColor = "|cff00ffff"
ZL_soundHandle = 0

function zl_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(ZL_AddonColor .. ZL_AddonName .. '|r ' .. tostring(msg))
end

function play_zeldaSound(index, sound_file)
	local sound_set = get_sound_set(index)
	local willPlay = nil
	local sound_ext = get_sound_ext()
	local sound_channel = get_sound_channel()
	local warning_text = ""

	if (ZL_soundHandle ~= 0 and ZL_soundHandle ~= nil) then
		if (zl_debug_bool) then
			zl_Print("Stopping sound for " .. ZL_soundHandle)
		end
		StopSound(ZL_soundHandle, 0)
	end

	if (zl_warning_bool) then
		warning_text = "|cffffff00WARNING|r "
	end

	update_config(false)
	willPlay, ZL_soundHandle = PlaySoundFile("Interface\\AddOns\\ZeldaLoot_Classic\\Sounds\\Sets\\" .. sound_set .. "\\" .. sound_file .. "." .. sound_ext, sound_channel)

	local mess = "[" .. sound_set .. "\\" .. sound_file .. "." .. sound_ext .. "] on sound channel [" .. sound_channel .. "]"
	if (willPlay) then
		if (zl_debug_bool) then
			zl_Print("Playing sound for " .. mess)
		end
	elseif (zl_warning_bool or zl_debug_bool) then
		zl_Print(warning_text .. "NOT playing sound for " .. mess .. " likey due to [" .. sound_channel .. "] being muted")
	end
end

function zeldaFrame_OnEvent(self, event, ...)
	local obj

	local scanCateg = {"green", "blue", "purple", "orange"}
	local scanValues = {active = "loot", crafted = "crafts", received = "received"}

	local qualities_dic = {nil, nil, "green", "blue", "purple", "orange"}
	local quality, zl_group

	local arg1 = select(1, ...)

	if ((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_Classic")) then
		update_config(false)
		zl_Print(AddonVersion..' Loaded.')
		zl_Print('Type |cffffff00/zeldaloot|r or |cffffff00/zl|r for the settings')
		zl_Print('Type |cffffff00/zeldaloot ?|r or |cffffff00/zl ?|r for the help menu')
		if (zl_debug_bool) then
			zl_Print('Debug mode is enabled')
		end

		local panel = getglobal("ZL_ConfigPanel")
		panel.name = ZL_AddonName
		panel.okay = btn_ok_onclick
		panel.cancel = btn_cancel_onclick
		panel.default = reset_config
		panel.refresh = refresh_zl_frame

		InterfaceOptions_AddCategory(panel, true)
		InterfaceAddOnsList_Update()
	end

	if (((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_Classic")) or (event == "PLAYER_LOGOUT")) then
		if ((zl_config == nil)) then
			-- First initialization
			reset_config(false)
		end

		if (event ~= "PLAYER_LOGOUT") then
			for iCat, vCat in ipairs(scanCateg) do
				for iSub, vSub in pairs(scanValues) do
					obj = getglobal("check_" .. vCat .. vSub)
					obj:SetChecked(zl_config[vCat][iSub])
				end
			end

			obj = getglobal("check_inheritedstuff")
			obj:SetChecked(zl_config["inherited"]["include"])

			obj = getglobal("check_warnings")
			obj:SetChecked(zl_warning_bool)

			obj = getglobal("check_debug")
			obj:SetChecked(zl_debug_bool)
		end
	end

	if (event == "CHAT_MSG_LOOT") then
		-- Inherited stuff ("artefacts", bind to account)
		if (strfind(arg1, "cffe6cc80")) then
			if (zl_config["inherited"]["include"]) then
				quality = 6
			else
				quality = nil
			end

		-- Legendary (orange)
		elseif (strfind(arg1, "cffff8000")) then
			quality = 6

		-- Epic (purple)
		elseif (strfind(arg1, "cffa335ee")) then
			quality = 5

		-- Rare (blue)
		elseif (strfind(arg1, "cff0070dd")) then
			quality = 4

		-- Not common (green)
		elseif (strfind(arg1, "cff1eff00")) then
			quality = 3

		-- Trash: common and low quality (white and grey), no sound for those ones !
		else
			quality = nil
		end

		if (quality) then
			zl_group = qualities_dic[quality]

			if (zl_config[zl_group]["active"]) then
				if (
					(strfind(arg1, ZL_LOOTMESSAGE)) or
					(((strfind(arg1, ZL_CRAFTMESSAGE)) or (strfind(arg1, ZL_CRAFTMESSAGE2))) and zl_config[zl_group]["crafted"]) or
					((strfind(arg1, ZL_RECEIVEMESSAGE)) and zl_config[zl_group]["received"])
				) then
					play_zeldaSound(quality - 1, zl_config[zl_group]["sound"])
				end
			end
		end
	end
end

function reset_config(print_text)
	zl_config = {
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
		}
	}

	if (zl_debug_bool) then
		zl_debug_bool = false
		zl_Print('Debug mode has been disabled. Type |cffffff00/zl debug|r to re-enable')
	end

	if (zl_warning_bool ~= true) then
		zl_warning_bool = true
		zl_Print('Warnings have been enabled. Type |cffffff00/zl warn|r to disable')
	end

	if (print_text) then
		zl_Print('Config has been reset')
	end
end