AddonVersion = "|cff00ff001.1.0|r"
ZL_AddonName = "ZeldaLoot BCC"
ZL_AddonColor = "|cff00ffff"

function zl_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(ZL_AddonColor .. ZL_AddonName .. '|r ' .. tostring(msg))
end

function play_zeldaSound(index)
	local sound_set = get_sound_set(index)

	update_config()

	if (index == 5)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_BCC\\Sounds\\Sets\\"..sound_set.."\\04 - Orange - Legendary objects.wav")
	end

	if (index == 4)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_BCC\\Sounds\\Sets\\"..sound_set.."\\03 - Purple - Epic objects.wav")
	end

	if (index == 3)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_BCC\\Sounds\\Sets\\"..sound_set.."\\02 - Blue - Rare objects.wav")
	end

	if (index == 2)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_BCC\\Sounds\\Sets\\"..sound_set.."\\01 - Green - Not common objects.wav")
	end
end

function zeldaFrame_OnEvent(self, event, ...)
	local obj

	local scanCateg = {"green", "blue", "purple", "orange"}
	local scanValues = {active = "loot", crafted = "crafts", received = "received"}

	local qualities_dic = {nil, nil, "green", "blue", "purple", "orange"}
	local quality, zl_group

	local arg1 = select(1, ...)

	if ((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_BCC")) then
		zl_Print(AddonVersion..' Loaded.')
		zl_Print('Type |cffffff00/zeldaloot|r or |cffffff00/zl|r for the settings')
	end

	if (((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_BCC")) or (event == "PLAYER_LOGOUT")) then
		if ((zl_config == nil) or (zl_config_temp == nil)) then
			-- First initialization
			zl_config = {
				green = {
					active   = true,
					received = false,
					crafted  = false,
					set = 0
				},

				blue = {
					active   = true,
					received = false,
					crafted  = false,
					set = 0
				},

				purple = {
					active   = true,
					received = false,
					crafted  = false,
					set = 0
				},

				orange = {
					active   = true,
					received = false,
					crafted  = false,
					set = 0
				},

				inherited = {
					include  = true
				}
			}

			zl_config_temp = zl_config
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
				   ) then play_zeldaSound(quality - 1)
				end
			end
		end
	end
end