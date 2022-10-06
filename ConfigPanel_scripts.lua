function update_config(allow_debug)
	local set
	if (allow_debug == nil) then
		allow_debug = true
	end

	if (zl_debug_bool == nil) then
		zl_debug_bool = false
	end

	if (zl_warning_bool == nil) then
		zl_warning_bool = true
	end

	if (zl_debug_bool and allow_debug) then
		dump_config("update_config")
	end

	if (zl_config == nil) then
		reset_config(false)
	end

	if (zl_config["sounds"] ~= nil) then
		if (zl_config["sounds"]["set"] ~= nil) then
			set = zl_config["sounds"]["set"]
			zl_config["sounds"]["set"] = nil
		end
	end

	if (zl_config["settings"] == nil) then
		local settings = {
			ext = "wav",
			channel = "SFX"
		}

		zl_config["settings"] = settings
	end

	if (zl_config["settings"]["ext"] == nil) then
		zl_config["settings"]["ext"] = "wav"
	end

	if (zl_config["settings"]["channel"] == nil) then
		zl_config["settings"]["channel"] = "SFX"
	end

	if (zl_config["green"]["set"] == nil) then
		if (set ~= nil) then
			zl_config["green"]["set"] = set
		else
			zl_config["green"]["set"] = 0
		end
	end

	if (zl_config["blue"]["set"] == nil) then
		if (set ~= nil) then
			zl_config["blue"]["set"] = set
		else
			zl_config["blue"]["set"] = 0
		end
	end

	if (zl_config["purple"]["set"] == nil) then
		if (set ~= nil) then
			zl_config["purple"]["set"] = set
		else
			zl_config["purple"]["set"] = 0
		end
	end

	if (zl_config["orange"]["set"] == nil) then
		if (set ~= nil) then
			zl_config["orange"]["set"] = set
		else
			zl_config["orange"]["set"] = 0
		end
	end

	if (zl_config["green"]["sound"] == nil) then
		zl_config["green"]["sound"] = 1
	end

	if (zl_config["blue"]["sound"] == nil) then
		zl_config["blue"]["sound"] = 2
	end

	if (zl_config["purple"]["sound"] == nil) then
		zl_config["purple"]["sound"] = 3
	end

	if (zl_config["orange"]["sound"] == nil) then
		zl_config["orange"]["sound"] = 4
	end

	if (zl_debug_bool and allow_debug) then
		dump_config("end update_config")
	end

end

function dump_config(text)
	local value
	zl_Print("Dumping config... |cff00ff00" .. text)
	for top_level_key, top_level_value in pairs(zl_config) do
		for second_level_key, second_level_value in pairs(top_level_value) do
			if (second_level_value == true) then value = "true"
			elseif (second_level_value == false) then value = "false"
			else value = second_level_value
			end
			zl_Print("top_level_key: |cff00ffff" .. top_level_key .. "|r second_level_key: |cff00ffff" .. second_level_key .. "|r second_level_value: |cff00ffff" .. value)
		end
	end
	zl_Print("Finsihed dumping config... |cff00ff00" .. text)
end

function refresh_zl_frame()
	local frame = getglobal("ZL_ConfigPanel")
	if (frame) then
		if (frame:IsVisible()) then
			frame:Hide();
			frame:Show();
		end
	end
end

-- Sound test
function test_zl_sound(index)
	local qualities_dic = {nil, nil, "green", "blue", "purple", "orange"}
	local zl_group

	zl_group = qualities_dic[index + 1]

	play_zeldaSound(index, zl_config[zl_group]["sound"])
end

function btn_ok_onclick()
	if (zl_debug_bool) then
		dump_config("Closed settings")
	end
end

function btn_cancel_onclick()
	if (zl_debug_bool) then
		dump_config("Closed settings")
	end
end

function zl_toBool(num)
	if (num == 1) then
		return true
	elseif (num == true) then
		return true
	else
		return false
	end
end

function zl_BoolToNum(b)
	if (b) then
		return 1
	else
		return 0
	end
end

function get_sound_ext()
	local sound_ext

	sound_ext = zl_config['settings'].ext

	if ((sound_ext == nil) or (sound_ext == "wav"))
		then return "wav"
	elseif (sound_ext == "mp3")
		then return "mp3"
	elseif (sound_ext == "ogg")
		then return "ogg"
	else
		return "wav"
	end
end

function get_sound_channel()
	local sound_channel

	sound_channel = zl_config['settings'].channel

	-- "Master", "SFX" (Sound), "Music", "Ambience", "Dialog"
	if ((sound_channel == nil) or (sound_channel == "SFX"))
		then return "SFX"
	elseif (sound_channel == "Master")
		then return "Master"
	elseif (sound_channel == "Music")
		then return "Music"
	elseif (sound_channel == "Ambience")
		then return "Ambience"
	elseif (sound_channel == "Dialog")
		then return "Dialog"
	else
		return "SFX"
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

	if (zl_debug_bool) then
		print('qualities_dic: '..qualities_dic[quality + 1]..' loot_types_dic: '..loot_types_dic[loot_type + 1]..' value:'..(obj:GetChecked() and 'true' or 'false'))
	end

	zl_config[qualities_dic[quality + 1]][loot_types_dic[loot_type + 1]] = obj:GetChecked()
end

-- Include inherited stuff checkbox
function check_inheritedstuff_onclick(obj)
	zl_config["inherited"]["include"] = zl_toBool(obj:GetChecked())
end

-- Debug prints to see when "UIDropDownMenu_Initialize" is called for your dropdown:
hooksecurefunc("UIDropDownMenu_Initialize", function(frame, func) end)

function dropdown_set_Initialize(self)
	UIDropDownMenu_SetWidth(self, 90)
end

function dropdown_sound_Initialize(self)
	UIDropDownMenu_SetWidth(self, 90)
end

function dropdown_settings_Initialize(self)
	UIDropDownMenu_SetWidth(self, 90)
end

function dropdown_set_Show(self)
	local selected
	local name = self:GetName()
	local item_level

	if (name == 'dropdown_greenloot_set') then item_level = 'green'
	elseif (name == 'dropdown_blueloot_set') then item_level = 'blue'
	elseif (name == 'dropdown_purpleloot_set') then item_level = 'purple'
	elseif (name == 'dropdown_orangeloot_set') then item_level = 'orange'
	end

	if (zl_config[item_level]["set"] == 0) then selected = 'ALTTP'
	elseif (zl_config[item_level]["set"] == 1) then selected = 'OOT'
	elseif (zl_config[item_level]["set"] == 2) then selected = 'TP'
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
		info.func = dropdown_set_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function dropdown_sound_Show(self)
	local sound_set, selected
	local name = self:GetName()
	local item_level

	if (name == 'dropdown_greenloot_sound') then item_level = 'green'
	elseif (name == 'dropdown_blueloot_sound') then item_level = 'blue'
	elseif (name == 'dropdown_purpleloot_sound') then item_level = 'purple'
	elseif (name == 'dropdown_orangeloot_sound') then item_level = 'orange'
	end

	UIDropDownMenu_SetText(self, zl_config[item_level]["sound"])

	if (zl_config[item_level]["set"] == 0) then sound_set = 'ALTTP'
	elseif (zl_config[item_level]["set"] == 1) then sound_set = 'OOT'
	elseif (zl_config[item_level]["set"] == 2) then sound_set = 'TP'
	end

	local info
	local item_sets = {
		ALTTP = { 1, 2, 3, 4, 5 },
		OOT = { 1, 2, 3, 4 },
		TP = { 1, 2, 3, 4, 5 }
	}
	local items = item_sets[sound_set]

	for k,v in ipairs(items) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		if (zl_config[item_level]["sound"] == v) then info.checked = true
		else info.checked = false
		end
		info.arg1 = self
		info.arg2 = item_level .. "_" .. v
		info.func = dropdown_sound_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function dropdown_set_OnClick(self, arg1, arg2)
	local item_level, selected

	for k, v in string.gmatch(arg2, "(%w+)_(%w+)") do
		item_level = k
		selected = v
	end

	UIDropDownMenu_SetText(arg1, selected)

	if (selected == 'ALTTP') then
		zl_config[item_level]["set"] = 0
	elseif (selected == 'OOT') then
		zl_config[item_level]["set"] = 1
		if (zl_config[item_level]["sound"] == 5) then
			zl_config[item_level]["sound"] = 4
			obj = getglobal("dropdown_" .. item_level .. "loot_sound")
			UIDropDownMenu_SetText(obj, 4)
		end
	elseif (selected == 'TP') then
		zl_config[item_level]["set"] = 2
	end
end

function dropdown_sound_OnClick(self, arg1, arg2)
	local item_level, selected

	for k, v in string.gmatch(arg2, "(%w+)_(%w+)") do
		item_level = k
		selected = tonumber(v)
	end

	UIDropDownMenu_SetText(arg1, selected)
	zl_config[item_level]["sound"] = selected
end

function dropdown_settings_Show(self)
	local selected
	local name = self:GetName()
	local setting

	if (name == 'dropdown_setting_ext') then setting = 'ext'
	elseif (name == 'dropdown_setting_channel') then setting = 'channel'
	end

	selected = zl_config["settings"][setting]

	UIDropDownMenu_SetText(self, selected)

	local info
	local settings = {
		ext = { "mp3", "ogg", "wav" }, 
		channel = { "Ambience", "Dialog", "Master", "Music", "SFX"}
	}
	for k,v in pairs(settings[setting]) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		if (selected == v) then info.checked = true
		else info.checked = false
		end
		info.arg1 = self
		info.arg2 = setting .. "_" .. v
		info.func = dropdown_settings_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function dropdown_settings_OnClick(self, arg1, arg2)
	local setting, selected

	for k, v in string.gmatch(arg2, "(%w+)_(%w+)") do
		setting = k
		selected = v
	end

	UIDropDownMenu_SetText(arg1, selected)
	zl_config["settings"][setting] = selected
end

function toggle_warnings(obj)
	local c = obj:GetChecked()
	local b = zl_toBool(c)
	zl_warning_bool = b

	if (zl_debug_bool) then
		if (b) then
			zl_Print('Enabling warnings')
		else
			zl_Print('Disabling warnings')
		end
	end
end

function toggle_debug(obj)
	local b = zl_toBool(obj:GetChecked())
	zl_debug_bool = b

	if (b) then
		zl_Print('Enabling debugging')
	else
		zl_Print('Disabling debugging')
	end
end