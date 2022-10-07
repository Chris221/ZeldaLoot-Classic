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

function ZeldaFrame_OnEvent(self, event, ...)
	local obj

	local scanCateg = { "green", "blue", "purple", "orange" }
	local scanValues = { active = "loot", crafted = "crafts", received = "received" }

	local qualities_dic = { nil, nil, "green", "blue", "purple", "orange" }
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

		local panel = getglobal("ZL_configPanel")
		panel.name = ZL_AddonName
		panel.okay = Btn_ok_onclick
		panel.cancel = Btn_cancel_onclick
		panel.default = Reset_config
		panel.refresh = Refresh_zl_frame

		InterfaceOptions_AddCategory(panel, true)
		InterfaceAddOnsList_Update()
	end

	if (((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_Classic")) or (event == "PLAYER_LOGOUT")) then
		if ((ZL_config == nil)) then
			-- First initialization
			Reset_config(false)
		end

		if (event ~= "PLAYER_LOGOUT") then
			for iCat, vCat in ipairs(scanCateg) do
				for iSub, vSub in pairs(scanValues) do
					obj = getglobal("check_" .. vCat .. vSub)
					if (obj ~= nil) then
						obj:SetChecked(ZL_config[vCat][iSub])
					end
				end
			end

			obj = getglobal("check_inheritedstuff")
			if (obj ~= nil) then
				obj:SetChecked(ZL_config["inherited"]["include"])
			end

			obj = getglobal("check_warnings")
			if (obj ~= nil) then
				obj:SetChecked(ZL_warning_bool)
			end

			obj = getglobal("check_debug")
			if (obj ~= nil) then
				obj:SetChecked(ZL_debug_bool)
			end
		end
	end

	if (event == "CHAT_MSG_LOOT") then
		-- Inherited stuff ("artefacts", bind to account)
		if (strfind(arg1, "cffe6cc80")) then
			if (ZL_config["inherited"]["include"]) then
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

			if (ZL_config[zl_group]["active"]) then
				if (
					(strfind(arg1, ZL_LOOTMESSAGE)) or
					(((strfind(arg1, ZL_CRAFTMESSAGE)) or (strfind(arg1, ZL_CRAFTMESSAGE2))) and ZL_config[zl_group]["crafted"]) or
					((strfind(arg1, ZL_RECEIVEMESSAGE)) and ZL_config[zl_group]["received"])
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
		}
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
end