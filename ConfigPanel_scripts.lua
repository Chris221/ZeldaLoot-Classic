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

	if config_version < 2 then
		ZL_config["settings"] = ZL_config["settings"] or {}
		ZL_config["settings"]["volume"] = ZL_config["settings"]["volume"] or 100

		ZL_config["version"] = 2
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

local function Reinit_dropdown(name, init_func)
	local dd = _G[name]
	if (dd ~= nil) then
		UIDropDownMenu_Initialize(dd, init_func)
	end
end

-- Push the current ZL_config values into every panel widget. Safe to call
-- before the panel exists (each widget is nil-guarded) and used both at load
-- and after /zl reset so an open panel never shows stale values.
function Sync_panel_widgets()
	if (ZL_config == nil) then return end

	local scanCateg = { "green", "blue", "purple", "orange" }
	local scanValues = { active = "loot", crafted = "crafts", received = "received" }
	local obj

	for iCat, vCat in ipairs(scanCateg) do
		for iSub, vSub in pairs(scanValues) do
			obj = _G["check_" .. vCat .. vSub]
			if (obj ~= nil) then
				obj:SetChecked(ZL_config[vCat][iSub])
			end
		end

		Reinit_dropdown("dropdown_" .. vCat .. "loot_set", Dropdown_set_Show)
		Reinit_dropdown("dropdown_" .. vCat .. "loot_sound", Dropdown_sound_Show)
	end

	Reinit_dropdown("dropdown_setting_ext", Dropdown_settings_Show)
	Reinit_dropdown("dropdown_setting_channel", Dropdown_settings_Show)

	obj = _G["check_inheritedstuff"]
	if (obj ~= nil) then obj:SetChecked(ZL_config["inherited"]["include"]) end

	obj = _G["check_warnings"]
	if (obj ~= nil) then obj:SetChecked(ZL_warning_bool) end

	obj = _G["check_debug"]
	if (obj ~= nil) then obj:SetChecked(ZL_debug_bool) end

	obj = _G["slider_setting_volume"]
	if (obj ~= nil) then obj:SetValue(Get_sound_volume()) end
end

-- Sound test
function Test_zl_sound(index)
	local qualities_dic = {nil, nil, "green", "blue", "purple", "orange"}
	local zl_group

	zl_group = qualities_dic[index + 1]

	Play_zeldaSound(index, ZL_config[zl_group]["sound"])
end

function ZL_toBool(num)
	return num == 1 or num == true
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
	local v = tonumber(ZL_config['settings'].volume)
	if (not v) then return 100 end
	if (v < 0) then v = 0 elseif (v > 100) then v = 100 end
	return v
end

-- Clamp a sound index to what the given set actually ships (e.g. OOT has 4),
-- so a bad saved config can never request a missing file like OOT\5.wav.
function Get_clamped_sound(sound_set, sound)
	local max_sound = ZL_SOUND_COUNTS[sound_set] or 1
	sound = tonumber(sound) or 1
	if (sound < 1) then sound = 1 elseif (sound > max_sound) then sound = max_sound end
	return sound
end

-- Shared tooltip handlers used by every widget's OnEnter/OnLeave in the panel.
-- Each widget sets self.title / self.tooltip in its OnLoad.
function ZL_ShowTooltip(self)
	GameTooltip:SetOwner(self, ZL_TOOLTIP_ANCHOR)
	GameTooltip:AddLine(self.title, 0.9215686275, 0.6823529412, 0.2039215686, 1, true)
	GameTooltip:AddLine(self.tooltip, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

function ZL_HideTooltip(self)
	GameTooltip:Hide()
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

	ZL_config[qualities_dic[quality + 1]][loot_types_dic[loot_type + 1]] = ZL_toBool(obj:GetChecked())
end

-- Include inherited stuff checkbox
function Check_inheritedstuff_onclick(obj)
	ZL_config["inherited"]["include"] = ZL_toBool(obj:GetChecked())
end

-- Debug prints to see when "UIDropDownMenu_Initialize" is called for your dropdown:
-- hooksecurefunc("UIDropDownMenu_Initialize", function(frame, func) end)

function Dropdown_width_Initialize(self)
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

	selected = ZL_SOUND_SETS[ZL_config[item_level]["set"]] or 'ALTTP'

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

	sound_set = ZL_SOUND_SETS[ZL_config[item_level]["set"]] or 'ALTTP'

	local info
	local count = ZL_SOUND_COUNTS[sound_set] or 0

	for v = 1, count do
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

	ZL_config[item_level]["set"] = ZL_SOUND_SET_IDS[selected] or 0

	-- Clamp the selected sound if the new set offers fewer sounds (e.g. OOT has 4)
	local clamped = Get_clamped_sound(selected, ZL_config[item_level]["sound"])
	if (ZL_config[item_level]["sound"] ~= clamped) then
		ZL_config[item_level]["sound"] = clamped
		obj = _G["dropdown_" .. item_level .. "loot_sound"]
		UIDropDownMenu_SetText(obj, clamped)
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

-- Volume slider
local function Update_volume_text(self, value)
	local label = _G[self:GetName() .. "Text"]
	if (label ~= nil) then
		label:SetText(math.floor(value + 0.5) .. "%")
	end
end

function Slider_volume_Show(self)
	local value = Get_sound_volume()
	self:SetValue(value)
	Update_volume_text(self, value)
end

function Slider_volume_OnValueChanged(self, value)
	value = math.floor((tonumber(value) or 100) + 0.5)
	if (value < 0) then value = 0 elseif (value > 100) then value = 100 end

	if (ZL_config ~= nil and ZL_config["settings"] ~= nil) then
		ZL_config["settings"]["volume"] = value
	end

	Update_volume_text(self, value)
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