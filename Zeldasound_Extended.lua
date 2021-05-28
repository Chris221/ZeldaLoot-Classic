function play_zeldaSound(index)
	local sound_set

	update_config()

	if ((zle_config_temp["sounds"]["set"] == nil) or (zle_config_temp["sounds"]["set"] == 0))
		then sound_set = "ALTTP"
	elseif (zle_config_temp["sounds"]["set"] == 1)
		then sound_set = "OOT"
	elseif (zle_config_temp["sounds"]["set"] == 2)
		then sound_set = "TP"
	else
		sound_set = "ALTTP"
	end

	if (index == 5)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_Extended\\Sounds\\Sets\\"..sound_set.."\\04 - Orange - Legendary objects.wav")
	end

	if (index == 4)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_Extended\\Sounds\\Sets\\"..sound_set.."\\03 - Purple - Epic objects.wav")
	end

	if (index == 3)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_Extended\\Sounds\\Sets\\"..sound_set.."\\02 - Blue - Rare objects.wav")
	end

	if (index == 2)
		then PlaySoundFile("Interface\\AddOns\\ZeldaLoot_Extended\\Sounds\\Sets\\"..sound_set.."\\01 - Green - Not common objects.wav")
	end
end

function zeldaFrame_OnEvent(self, event, ...)
	local obj

	local iCat, vCat
	local iSub, vSub

	local scanCateg = {"green", "blue", "purple", "orange"}
	local scanValues = {active = "loot", crafted = "crafts", received = "received"}

	local qualities_dic = {nil, nil, "green", "blue", "purple", "orange"}
	local quality, zle_group

	local arg1 = select(1, ...)

	if (((event == "ADDON_LOADED") and (arg1 == "ZeldaLoot_Extended")) or (event == "PLAYER_LOGOUT")) then
		if ((zle_config == nil) or (zle_config_temp == nil)) then
			-- First initialization
			zle_config = {
				green = {
					active   = true,
					received = false,
					crafted  = false
				},

				blue = {
					active   = true,
					received = false,
					crafted  = false
				},

				purple = {
					active   = true,
					received = false,
					crafted  = false
				},

				orange = {
					active   = true,
					received = false,
					crafted  = false
				},

				inherited = {
					include  = true
				},

				sounds = {
					set = 0
				}
			}

			zle_config_temp = zle_config
		end

		if (event ~= "PLAYER_LOGOUT") then
			for iCat, vCat in ipairs(scanCateg) do
				for iSub, vSub in pairs(scanValues) do
					obj = getglobal("check_" .. vCat .. vSub)
					obj:SetChecked(zle_config[vCat][iSub])
				end
			end

			obj = getglobal("check_inheritedstuff")
			obj:SetChecked(zle_config["inherited"]["include"])
		end
	end

	if (event == "CHAT_MSG_LOOT") then

		-- Inherited stuff ("artefacts", bind to account)
		if (strfind(arg1, "cffe6cc80")) then
			if (zle_config["inherited"]["include"]) then
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
			zle_group = qualities_dic[quality]

			if (zle_config[zle_group]["active"]) then
				if (
				    (strfind(arg1, ZLE_LOOTMESSAGE)) or
					(((strfind(arg1, ZLE_CRAFTMESSAGE)) or (strfind(arg1, ZLE_CRAFTMESSAGE2))) and zle_config[zle_group]["crafted"]) or
					((strfind(arg1, ZLE_RECEIVEMESSAGE)) and zle_config[zle_group]["received"])

				   ) then
				   play_zeldaSound(quality - 1)
				end
			end
		end
	end
end