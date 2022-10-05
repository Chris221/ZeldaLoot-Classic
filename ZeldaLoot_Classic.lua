AddonVersion = "|cff00ff001.3.0|r"
ZL_AddonName = "ZeldaLoot Classic"
ZL_AddonColor = "|cff00ffff"
ZL_soundHandle = 0

function zl_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(ZL_AddonColor .. ZL_AddonName .. '|r ' .. tostring(msg))
end

function play_zeldaSound(index, sound_file)
	local sound_set = get_sound_set(index)
	local willPlay = nil
	local sound_ext = get_sound_type()
	local sound_channel = get_sound_channel()
	local warning_text = ""

	if (ZL_soundHandle ~= 0) then
		if (zl_debug_bool) then
			zl_Print("Stopping sound for " .. ZL_soundHandle)
		end
		StopSound(ZL_soundHandle, 0)
	end

	if (zl_warning_bool) then
		warning_text = "WARNING "
	end

	update_config(false)
	willPlay, ZL_soundHandle = PlaySoundFile("Interface\\AddOns\\ZeldaLoot_Classic\\Sounds\\Sets\\" .. sound_set .. "\\" .. sound_file .. "." .. sound_ext, sound_channel)

	local mess = "[" .. sound_set .. "\\" .. sound_file .. "." .. sound_ext .. "] on sound channel [" .. sound_channel .. "]"
	if (willPlay and zl_debug_bool) then
		zl_Print("Playing sound for " .. mess)
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
		if (zl_debug_bool) then
			zl_Print('Debug mode is enabled')
		end
	end

	if (((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_Classic")) or (event == "PLAYER_LOGOUT")) then
		if ((zl_config == nil) or (zl_config_temp == nil)) then
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
			received = false,
			crafted  = false,
			set = 0,
			sound = 1
		},

		blue = {
			active   = true,
			received = false,
			crafted  = false,
			set = 0,
			sound = 2
		},

		purple = {
			active   = true,
			received = false,
			crafted  = false,
			set = 0,
			sound = 3
		},

		orange = {
			active   = true,
			received = false,
			crafted  = false,
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

	zl_config_temp = zl_config

	if (print_text) then
		zl_Print('Config has been reset')
	end
end