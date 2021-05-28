function update_config()
	if ((zle_config_temp["sounds"] == nil) or (zle_config["sounds"] == nil))
		then zle_config["sounds"] = {set = 0}
		zle_config_temp["sounds"] = {set = 0}
	end
end

-- Hide ZLE config frame (if visible)
function hide_zle_frame()
	local frame = getglobal("ZLE_ConfigPanel")
	if (frame) then
		if (frame:IsVisible()) then
			frame:Hide();
		end
	end
end

-- Show ZLE config frame (if not visible)
function show_zle_frame()
	local frame = getglobal("ZLE_ConfigPanel")

	update_config()

	if (frame) then
		if (not frame:IsVisible()) then
			if (zle_config) then
				zle_config_temp = zle_config

				local scanCateg = {"green", "blue", "purple", "orange"}
				local scanValues = {active = "loot", crafted = "crafts", received = "received"}
				local obj

				for iCat, vCat in ipairs(scanCateg) do
					for iSub, vSub in pairs(scanValues) do
						obj = getglobal("check_" .. vCat .. vSub)
						obj:SetChecked(zle_config[vCat][iSub])
					end
				end

				obj = getglobal("check_inheritedstuff")
				obj:SetChecked(zle_config["inherited"]["include"])

				obj = getglobal("check_alttp_set")
				obj:SetChecked(((not zle_config["sounds"]["set"]) or (zle_config["sounds"]["set"] > 2) or (zle_config["sounds"]["set"] <= 0)))

				obj = getglobal("check_oot_set")
				obj:SetChecked(((zle_config["sounds"]["set"]) and (zle_config["sounds"]["set"] == 1)))

				obj = getglobal("check_tp_set")
				obj:SetChecked(((zle_config["sounds"]["set"]) and (zle_config["sounds"]["set"] == 2)))
			end
			frame:Show();
		end
	end
end

-- Sound test
function test_zle_sound(index)
	play_zeldaSound(index)
end

function btn_ok_onclick()
	-- Write temporary conf to current conf
	zle_config = zle_config_temp
	hide_zle_frame()
end

function btn_cancel_onclick()
	-- Restore current conf to temporary conf
	zle_config_temp = zle_config
	hide_zle_frame()
end


function zle_toBool(num)
	if (num == 1) then
		return true
	else
		return false
	end
end

-- Main checkboxes
function check_loot_onclick(obj, quality, loot_type)
	local qualities_dic  = {nil, nil, "green", "blue", "purple", "orange"}
	local loot_types_dic = {"active", "crafted", "received"}

	zle_config_temp[qualities_dic[quality + 1]][loot_types_dic[loot_type + 1]] = zle_toBool(obj:GetChecked())
end

-- Include inherited stuff checkbox
function check_inheritedstuff_onclick(obj)
	zle_config_temp["inherited"]["include"] = zle_toBool(obj:GetChecked())
end

function check_soundset(obj, idx)
	local o1, o2, o3
	local c1, c2, c3

	o1 = getglobal("check_alttp_set")
	o2 = getglobal("check_oot_set")
	o3 = getglobal("check_tp_set")

	c1 = zle_toBool(o1:GetChecked())
	c2 = zle_toBool(o2:GetChecked())
	c3 = zle_toBool(o3:GetChecked())

	-- Default config: set to ALTTP sound set
	if (not zle_config_temp["sounds"])
		then zle_config_temp["sounds"] = {
			set = 0
		}
	end

	if (idx == 0) -- A Link to the past
		then o1:SetChecked(true)
		o2:SetChecked(false)
		o3:SetChecked(false)
		zle_config_temp["sounds"]["set"] = 0
	elseif (idx == 1) -- Ocarina of Time Orchestrated
		then o1:SetChecked(false)
		o2:SetChecked(true)
		o3:SetChecked(false)
		zle_config_temp["sounds"]["set"] = 1
	elseif (idx == 2) -- Twilight Princess
		then o1:SetChecked(false)
		o2:SetChecked(false)
		o3:SetChecked(true)
		zle_config_temp["sounds"]["set"] = 2
	end
end