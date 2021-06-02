debug = false

function update_config()
	local set
	if ((zl_config["sounds"]["set"] ~= nil)) then
		set = zl_config["sounds"]["set"]
		zl_config["sounds"]["set"] = nil
		zl_config_temp["sounds"]["set"] = nil
	end

	if ((zl_config_temp["green"]["set"] == nil) or (zl_config["green"]["set"] == nil)) then
		if (set ~= nil) then
			zl_config["green"]["set"] = set
			zl_config_temp["green"]["set"] = set
		else
			zl_config["green"]["set"] = 0
			zl_config_temp["green"]["set"] = 0
		end
	end
	if ((zl_config_temp["blue"]["set"] == nil) or (zl_config["blue"]["set"] == nil)) then
		if (set ~= nil) then
			zl_config["blue"]["set"] = set
			zl_config_temp["blue"]["set"] = set
		else
			zl_config["blue"]["set"] = 0
			zl_config_temp["blue"]["set"] = 0
		end
	end
	if ((zl_config_temp["purple"]["set"] == nil) or (zl_config["purple"]["set"] == nil)) then
		if (set ~= nil) then
			zl_config["purple"]["set"] = set
			zl_config_temp["purple"]["set"] = set
		else
			zl_config["purple"]["set"] = 0
			zl_config_temp["purple"]["set"] = 0
		end
	end
	if ((zl_config_temp["orange"]["set"] == nil) or (zl_config["orange"]["set"] == nil)) then
		if (set ~= nil) then
			zl_config["orange"]["set"] = set
			zl_config_temp["orange"]["set"] = set
		else
			zl_config["orange"]["set"] = 0
			zl_config_temp["orange"]["set"] = 0
		end
	end
end

-- Hide zl config frame (if visible)
function hide_zl_frame()
	local frame = getglobal("ZL_ConfigPanel")
	if (frame) then
		if (frame:IsVisible()) then
			frame:Hide();
		end
	end
end

-- Show zl config frame (if not visible)
function show_zl_frame()
	local frame = getglobal("ZL_ConfigPanel")

	update_config()

	if (frame) then
		if (not frame:IsVisible()) then
			if (zl_config) then
				zl_config_temp = zl_config

				local scanCateg = {"green", "blue", "purple", "orange"}
				local scanValues = {active = "loot", crafted = "crafts", received = "received"}
				local obj

				for iCat, vCat in ipairs(scanCateg) do
					for iSub, vSub in pairs(scanValues) do
						obj = getglobal("check_" .. vCat .. vSub)
						obj:SetChecked(zl_config[vCat][iSub])
					end
				end

				obj = getglobal("check_inheritedstuff")
				obj:SetChecked(zl_config["inherited"]["include"])
			end
			frame:Show();
		end
	end
end

-- Sound test
function test_zl_sound(index)
	play_zeldaSound(index)
end

function btn_ok_onclick()
	-- Write temporary conf to current conf
	zl_config = zl_config_temp
	hide_zl_frame()
end

function btn_cancel_onclick()
	-- Restore current conf to temporary conf
	zl_config_temp = zl_config
	hide_zl_frame()
end


function zl_toBool(num)
	if (num == 1) then
		return true
	else
		return false
	end
end

function get_sound_set(index)
	local sound_index

	if (index == 5) then sound_index = zl_config['orange'].set
	elseif (index == 4) then sound_index = zl_config['purple'].set
	elseif (index == 3) then sound_index = zl_config['blue'].set
	elseif (index == 2) then sound_index = zl_config['green'].set
	end

	if ((sound_index == nil) or (sound_index == 0))
		then return "ALTTP"
	elseif (sound_index == 1)
		then return "OOT"
	elseif (sound_index == 2)
		then return "TP"
	else
		return "ALTTP"
	end
end

-- Main checkboxes
function check_loot_onclick(obj, quality, loot_type)
	local qualities_dic  = {nil, nil, "green", "blue", "purple", "orange"}
	local loot_types_dic = {"active", "crafted", "received"}

	if (debug) then
		print('qualities_dic: '..qualities_dic[quality + 1]..' loot_types_dic: '..loot_types_dic[loot_type + 1]..' value:'..(obj:GetChecked() and 'true' or 'false'))
	end

	zl_config_temp[qualities_dic[quality + 1]][loot_types_dic[loot_type + 1]] = obj:GetChecked()
end

-- Include inherited stuff checkbox
function check_inheritedstuff_onclick(obj)
	zl_config_temp["inherited"]["include"] = zl_toBool(obj:GetChecked())
end

-- Debug prints to see when "UIDropDownMenu_Initialize" is called for your dropdown:
hooksecurefunc("UIDropDownMenu_Initialize", function(frame, func) end)

function dropdown_sound_Initialize(self)
	UIDropDownMenu_SetWidth(self, 90)
end

function dropdown_sound_Show(self)
	local selected
	local name = self:GetName()
	local item_level

	if (name == 'dropdown_greenloot') then item_level = 'green'
	elseif (name == 'dropdown_blueloot') then item_level = 'blue'
	elseif (name == 'dropdown_purpleloot') then item_level = 'purple'
	elseif (name == 'dropdown_orangeloot') then item_level = 'orange'
	end

	if (zl_config_temp[item_level]["set"] == 0) then selected = 'ALTTP'
	elseif (zl_config_temp[item_level]["set"] == 1) then selected = 'OOT'
	elseif (zl_config_temp[item_level]["set"] == 2) then selected = 'TP'
	end

	UIDropDownMenu_SetText(self, selected)

	local info
	local items = {'ALTTP', 'OOT', 'TP'}
	for k,v in pairs(items) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		if (selected == v) then info.checked = true
		else info.checked = false
		end
		info.arg1 = self
		info.arg2 = item_level .. "_" .. v
		info.func = dropdown_sound_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function dropdown_sound_OnClick(self, arg1, arg2)
	local item_level
	local selected

	for k, v in string.gmatch(arg2, "(%w+)_(%w+)") do
		item_level = k
		selected = v
	end

	UIDropDownMenu_SetText(arg1, selected)

	if (selected == 'ALTTP') then zl_config_temp[item_level]["set"] = 0
	elseif (selected == 'OOT') then zl_config_temp[item_level]["set"] = 1
	elseif (selected == 'TP') then zl_config_temp[item_level]["set"] = 2
	end
end

function MYFRAME12345_OnLoad()
	-- Comment or uncomment this line for testing:
	UIDropDownMenu_Initialize(dropdown_greenloot, MYBUTTON12345_Initialize)
end