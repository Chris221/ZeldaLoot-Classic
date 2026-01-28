local function Migrate_config()
	local config_version = ZL_config["version"] or 0

	if config_version < 1 then
		local set = nil
		if ZL_config["sounds"] and ZL_config["sounds"]["set"] then
			set = ZL_config["sounds"]["set"]
			ZL_config["sounds"] = nil
		end

		ZL_config["settings"] = ZL_config["settings"] or { ext = "wav", channel = "SFX" }
		ZL_config["settings"]["ext"] = ZL_config["settings"]["ext"] or "wav"
		ZL_config["settings"]["channel"] = ZL_config["settings"]["channel"] or "SFX"
		ZL_config["settings"]["volume"] = ZL_config["settings"]["volume"] or 100

		local defaults = { green = 1, blue = 2, purple = 3, orange = 4 }
		for group, default_sound in pairs(defaults) do
			ZL_config[group] = ZL_config[group] or {}
			ZL_config[group]["set"] = ZL_config[group]["set"] or set or 0
			ZL_config[group]["sound"] = ZL_config[group]["sound"] or default_sound
			if ZL_config[group]["active"] == nil then ZL_config[group]["active"] = true end
			if ZL_config[group]["received"] == nil then ZL_config[group]["received"] = true end
			if ZL_config[group]["crafted"] == nil then ZL_config[group]["crafted"] = true end
		end

		ZL_config["inherited"] = ZL_config["inherited"] or { include = true }

		ZL_config["version"] = 1
	end
end

function Update_config(allow_debug)
	if allow_debug == nil then
		allow_debug = true
	end

	if ZL_debug_bool == nil then
		ZL_debug_bool = false
	end

	if ZL_warning_bool == nil then
		ZL_warning_bool = true
	end

	if ZL_debug_bool and allow_debug then
		Dump_config("Update_config")
	end

	if ZL_config == nil then
		Reset_config(false)
	end

	Migrate_config()

	if ZL_debug_bool and allow_debug then
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
	return num == 1 or num == true
end

function ZL_BoolToNum(b)
	if (b) then
		return 1
	else
		return 0
	end
end

function Get_sound_ext()
	local sound_ext = ZL_config['settings'].ext
	local valid_exts = { mp3 = true, ogg = true, wav = true }
	return valid_exts[sound_ext] and sound_ext or "wav"
end

function Get_sound_channel()
	local sound_channel = ZL_config['settings'].channel
	local valid_channels = { Master = true, SFX = true, Music = true, Ambience = true, Dialog = true }
	return valid_channels[sound_channel] and sound_channel or "SFX"
end

function Get_sound_volume()
	local volume = ZL_config and ZL_config.settings and ZL_config.settings.volume or 100
	return math.max(0, math.min(100, volume)) / 100
end

function Slider_volume_OnValueChanged(self, value)
	local vol = math.floor(value + 0.5)
	if ZL_config and ZL_config.settings then
		ZL_config.settings.volume = vol
	end
	if self and self.Text then
		self.Text:SetText(ZL_VOLUME .. ": " .. vol .. "%")
	elseif self then
		local textObj = _G[self:GetName().."Text"]
		if textObj then
			textObj:SetText(ZL_VOLUME .. ": " .. vol .. "%")
		end
	end
end

function Get_sound_set(index)
	local group = ZL_QUALITY_GROUPS[index]
	local sound_index = group and ZL_config[group].set or 0
	return ZL_SOUND_SETS[sound_index] or "ALTTP"
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

local QUALITY_INDEX = { green = 2, blue = 3, purple = 4, orange = 5 }

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

	local index = QUALITY_INDEX[item_level]
	if index then
		Test_zl_sound(index)
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

	local index = QUALITY_INDEX[item_level]
	if index then
		Test_zl_sound(index)
	end
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