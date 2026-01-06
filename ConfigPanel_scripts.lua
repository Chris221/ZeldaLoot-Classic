function Update_config(allow_debug)
	local set
	if (allow_debug == nil) then
		allow_debug = true
	end

	if (ZL_debug_bool == nil) then
		ZL_debug_bool = false
	end

	if (ZL_warning_bool == nil) then
		ZL_warning_bool = true
	end

	if (ZL_debug_bool and allow_debug) then
		Dump_config("Update_config")
	end

	if (ZL_config == nil) then
		Reset_config(false)
	end

	if (ZL_config["sounds"] ~= nil) then
		if (ZL_config["sounds"]["set"] ~= nil) then
			set = ZL_config["sounds"]["set"]
			ZL_config["sounds"]["set"] = nil
		end
	end

	if (ZL_config["settings"] == nil) then
		local settings = {
			ext = "wav",
			channel = "SFX"
		}

		ZL_config["settings"] = settings
	end

	if (ZL_config["settings"]["ext"] == nil) then
		ZL_config["settings"]["ext"] = "wav"
	end

	if (ZL_config["settings"]["channel"] == nil) then
		ZL_config["settings"]["channel"] = "SFX"
	end

	if (ZL_config["green"]["set"] == nil) then
		if (set ~= nil) then
			ZL_config["green"]["set"] = set
		else
			ZL_config["green"]["set"] = 0
		end
	end

	if (ZL_config["blue"]["set"] == nil) then
		if (set ~= nil) then
			ZL_config["blue"]["set"] = set
		else
			ZL_config["blue"]["set"] = 0
		end
	end

	if (ZL_config["purple"]["set"] == nil) then
		if (set ~= nil) then
			ZL_config["purple"]["set"] = set
		else
			ZL_config["purple"]["set"] = 0
		end
	end

	if (ZL_config["orange"]["set"] == nil) then
		if (set ~= nil) then
			ZL_config["orange"]["set"] = set
		else
			ZL_config["orange"]["set"] = 0
		end
	end

	if (ZL_config["green"]["sound"] == nil) then
		ZL_config["green"]["sound"] = 1
	end

	if (ZL_config["blue"]["sound"] == nil) then
		ZL_config["blue"]["sound"] = 2
	end

	if (ZL_config["purple"]["sound"] == nil) then
		ZL_config["purple"]["sound"] = 3
	end

	if (ZL_config["orange"]["sound"] == nil) then
		ZL_config["orange"]["sound"] = 4
	end

	if (ZL_debug_bool and allow_debug) then
		Dump_config(ZL_END_TEXT .. " Update_config")
	end

end

function Dump_config(text)
	local value
	ZL_Print(ZL_DUMP_START .. "... |cff00ff00" .. text)
	for top_level_key, top_level_value in pairs(ZL_config) do
		for second_level_key, second_level_value in pairs(top_level_value) do
			if (second_level_value == true) then value = "true"
			elseif (second_level_value == false) then value = "false"
			else value = second_level_value
			end
			ZL_Print("top_level_key: |cff00ffff" .. top_level_key .. "|r second_level_key: |cff00ffff" .. second_level_key .. "|r second_level_value: |cff00ffff" .. value)
		end
	end
	ZL_Print(ZL_DUMP_FINISH .. "... |cff00ff00" .. text)
end

function Refresh_zl_frame()
	local frame = _G["ZL_configPanel"]
	if (frame) then
		if (frame:IsVisible()) then
			frame:Hide();
			frame:Show();
		end
	end
end

-- Sound test
function Test_zl_sound(index)
	local qualities_dic = {nil, nil, "green", "blue", "purple", "orange"}
	local zl_group

	zl_group = qualities_dic[index + 1]

	Play_zeldaSound(index, ZL_config[zl_group]["sound"])
end

function Btn_ok_onclick()
	if (ZL_debug_bool) then
		Dump_config(ZL_SETTINGS_CLOSED)
	end
end

function Btn_cancel_onclick()
	if (ZL_debug_bool) then
		Dump_config(ZL_SETTINGS_CLOSED)
	end
end

function ZL_toBool(num)
	if (num == 1) then
		return true
	elseif (num == true) then
		return true
	else
		return false
	end
end

function ZL_BoolToNum(b)
	if (b) then
		return 1
	else
		return 0
	end
end

function Get_sound_ext()
	local sound_ext

	sound_ext = ZL_config['settings'].ext

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

function Get_sound_channel()
	local sound_channel

	sound_channel = ZL_config['settings'].channel

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

function Get_sound_set(index)
	local sound_index

	if (index == 5) then sound_index = ZL_config['orange'].set
	elseif (index == 4) then sound_index = ZL_config['purple'].set
	elseif (index == 3) then sound_index = ZL_config['blue'].set
	elseif (index == 2) then sound_index = ZL_config['green'].set
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
function Check_loot_onclick(obj, quality, loot_type)
	local qualities_dic  = {nil, nil, "green", "blue", "purple", "orange"}
	local loot_types_dic = {"active", "crafted", "received"}

	if (ZL_debug_bool) then
		print('qualities_dic: '..qualities_dic[quality + 1]..' loot_types_dic: '..loot_types_dic[loot_type + 1]..' value:'..(obj:GetChecked() and 'true' or 'false'))
	end

	ZL_config[qualities_dic[quality + 1]][loot_types_dic[loot_type + 1]] = obj:GetChecked()
end

-- Include inherited stuff checkbox
function Check_inheritedstuff_onclick(obj)
	ZL_config["inherited"]["include"] = ZL_toBool(obj:GetChecked())
end

-- Debug prints to see when "UIDropDownMenu_Initialize" is called for your dropdown:
-- hooksecurefunc("UIDropDownMenu_Initialize", function(frame, func) end)

function Dropdown_set_Initialize(self)
	UIDropDownMenu_SetWidth(self, 90)
end

function Dropdown_sound_Initialize(self)
	UIDropDownMenu_SetWidth(self, 90)
end

function Dropdown_settings_Initialize(self)
	UIDropDownMenu_SetWidth(self, 90)
end

function Dropdown_set_Show(self)
	local selected
	local name = self:GetName()
	local item_level

	if (name == 'dropdown_greenloot_set') then item_level = 'green'
	elseif (name == 'dropdown_blueloot_set') then item_level = 'blue'
	elseif (name == 'dropdown_purpleloot_set') then item_level = 'purple'
	elseif (name == 'dropdown_orangeloot_set') then item_level = 'orange'
	end

	if (ZL_config[item_level]["set"] == 0) then selected = 'ALTTP'
	elseif (ZL_config[item_level]["set"] == 1) then selected = 'OOT'
	elseif (ZL_config[item_level]["set"] == 2) then selected = 'TP'
	end

	UIDropDownMenu_SetText(self, selected)

	local info
	local items = {'ALTTP', 'OOT', 'TP'}
	for i, v in ipairs(items) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		if (selected == v) then info.checked = true
		else info.checked = false
		end
		info.arg1 = self
		info.arg2 = item_level .. "_" .. v
		info.func = Dropdown_set_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function Dropdown_sound_Show(self)
	local sound_set, selected
	local name = self:GetName()
	local item_level

	if (name == 'dropdown_greenloot_sound') then item_level = 'green'
	elseif (name == 'dropdown_blueloot_sound') then item_level = 'blue'
	elseif (name == 'dropdown_purpleloot_sound') then item_level = 'purple'
	elseif (name == 'dropdown_orangeloot_sound') then item_level = 'orange'
	end

	UIDropDownMenu_SetText(self, ZL_config[item_level]["sound"])

	if (ZL_config[item_level]["set"] == 0) then sound_set = 'ALTTP'
	elseif (ZL_config[item_level]["set"] == 1) then sound_set = 'OOT'
	elseif (ZL_config[item_level]["set"] == 2) then sound_set = 'TP'
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
		if (ZL_config[item_level]["sound"] == v) then info.checked = true
		else info.checked = false
		end
		info.arg1 = self
		info.arg2 = item_level .. "_" .. v
		info.func = Dropdown_sound_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function Dropdown_set_OnClick(self, arg1, arg2)
	local item_level, selected, obj

	for k, v in string.gmatch(arg2, "(%w+)_(%w+)") do
		item_level = k
		selected = v
	end

	UIDropDownMenu_SetText(arg1, selected)

	if (selected == 'ALTTP') then
		ZL_config[item_level]["set"] = 0
	elseif (selected == 'OOT') then
		ZL_config[item_level]["set"] = 1
		if (ZL_config[item_level]["sound"] == 5) then
			ZL_config[item_level]["sound"] = 4
			obj = _G["dropdown_" .. item_level .. "loot_sound"]
			UIDropDownMenu_SetText(obj, 4)
		end
	elseif (selected == 'TP') then
		ZL_config[item_level]["set"] = 2
	end
end

function Dropdown_sound_OnClick(self, arg1, arg2)
	local item_level, selected

	for k, v in string.gmatch(arg2, "(%w+)_(%w+)") do
		item_level = k
		selected = tonumber(v)
	end

	UIDropDownMenu_SetText(arg1, selected)
	ZL_config[item_level]["sound"] = selected
end

function Dropdown_settings_Show(self)
	local selected
	local name = self:GetName()
	local setting

	if (name == 'dropdown_setting_ext') then setting = 'ext'
	elseif (name == 'dropdown_setting_channel') then setting = 'channel'
	end

	selected = ZL_config["settings"][setting]

	UIDropDownMenu_SetText(self, selected)

	local info
	local settings = {
		ext = { "mp3", "ogg", "wav" }, 
		channel = { "Ambience", "Dialog", "Master", "Music", "SFX"}
	}
	for k,v in ipairs(settings[setting]) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		if (selected == v) then info.checked = true
		else info.checked = false
		end
		info.arg1 = self
		info.arg2 = setting .. "_" .. v
		info.func = Dropdown_settings_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function Dropdown_settings_OnClick(self, arg1, arg2)
	local setting, selected

	for k, v in string.gmatch(arg2, "(%w+)_(%w+)") do
		setting = k
		selected = v
	end

	UIDropDownMenu_SetText(arg1, selected)
	ZL_config["settings"][setting] = selected
end

function Toggle_warnings(obj)
	local c = obj:GetChecked()
	local b = ZL_toBool(c)
	ZL_warning_bool = b

	if (ZL_debug_bool) then
		if (b) then
			ZL_Print(ZL_WARNING_ENABLING)
		else
			ZL_Print(ZL_WARNING_DISABLING)
		end
	end
end

function Toggle_debug(obj)
	local b = ZL_toBool(obj:GetChecked())
	ZL_debug_bool = b

	if (b) then
		ZL_Print(ZL_DEBUG_ENABLING)
	else
		ZL_Print(ZL_DEBUG_DISABLING)
	end
end