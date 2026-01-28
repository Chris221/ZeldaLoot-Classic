local zl = {};

local function printCmd(cmd, desc)
	print('|cffffaa00/zl ' .. cmd .. '|r- ' .. desc)
	print('|cffffaa00/zeldaloot ' .. cmd .. '|r- ' .. desc)
end

function zl.SlashCommandHandler(msg)
	if (msg == 'help' or msg == '?' or msg == 'h') then
		ZL_Print(ZL_SLASH_COMMANDS)
		printCmd('', ZL_SLASH_OPEN_SETTINGS)
		printCmd('dump ', ZL_SLASH_DUMP_CONFIG)
		printCmd('debug ', ZL_SLASH_DEBUG)
		printCmd('[warnings|warning|warn] ', ZL_SLASH_WARNINGS)
		printCmd('ext ', ZL_SLASH_EXT)
		printCmd('ext [wav|ogg|mp3] ', ZL_SLASH_EXT_2)
		print(ZL_SLASH_EXT_EXTRA)
		printCmd('channel [Master|SFX|Music|Ambience|Dialog] ', ZL_SLASH_CHANNELS)
		print(ZL_SLASH_CHANNELS_EXTRA)
		printCmd('reset ', ZL_SLASH_RESETS)
		print('|cffffaa00/zl test [green|blue|purple|orange] |r- ' .. ZL_SLASH_TEST)
	elseif (msg == 'dump') then
		Dump_config(msg)
	elseif (msg == 'debug') then
		if (ZL_debug_bool) then
			ZL_debug_bool = false
			ZL_Print(ZL_SLASH_DEBUG_DISABLED)
		else
			ZL_debug_bool = true
			ZL_Print(ZL_SLASH_DEBUG_ENABLED)
		end
	elseif (msg == 'warnings' or msg == 'warning' or msg == 'warn') then
		if (ZL_warning_bool) then
			ZL_warning_bool = false
			ZL_Print(ZL_SLASH_WARNING_DISABLED)
		else
			ZL_warning_bool = true
			ZL_Print(ZL_SLASH_WARNING_ENABLED)
		end
	elseif (msg:find('^ext')) then
		local msgLower = string.lower(msg)
		if (msgLower:find('mp3')) then
			ZL_config["settings"]["ext"] = "mp3"
			ZL_Print(ZL_SLASH_MP3)
		elseif (msgLower:find('wav')) then
			ZL_config["settings"]["ext"] = "wav"
			ZL_Print(ZL_SLASH_WAV)
		elseif (msgLower:find('ogg')) then
			ZL_config["settings"]["ext"] = "ogg"
			ZL_Print(ZL_SLASH_OGG)
		elseif (ZL_config["settings"]["ext"] == "wav") then
			ZL_config["settings"]["ext"] = "ogg"
			ZL_Print(ZL_SLASH_OGG)
		else
			ZL_config["settings"]["ext"] = "wav"
			ZL_Print(ZL_SLASH_WAV)
		end
	elseif (msg:find('^channel')) then
		local msgLower = string.lower(msg)
		if (msgLower:find('master')) then
			ZL_config["settings"]["channel"] = "Master"
			ZL_Print(ZL_SLASH_MASTER)
		elseif (msgLower:find('sfx')) then
			ZL_config["settings"]["channel"] = "SFX"
			ZL_Print(ZL_SLASH_SFX)
		elseif (msgLower:find('music')) then
			ZL_config["settings"]["channel"] = "Music"
			ZL_Print(ZL_SLASH_MUSIC)
		elseif (msgLower:find('ambience')) then
			ZL_config["settings"]["channel"] = "Ambience"
			ZL_Print(ZL_SLASH_AMBIENCE)
		elseif (msgLower:find('dialog')) then
			ZL_config["settings"]["channel"] = "Dialog"
			ZL_Print(ZL_SLASH_DIALOG)
		else
			ZL_config["settings"]["channel"] = "SFX"
			ZL_Print(ZL_SLASH_DEFAULT)
		end
	elseif (msg == 'reset') then
		Reset_config(true)
	elseif (msg:find('^test')) then
		local msgLower = string.lower(msg)
		if (msgLower:find('green')) then
			Test_zl_sound(2)
			ZL_Print(ZL_SLASH_TEST_GREEN)
		elseif (msgLower:find('blue')) then
			Test_zl_sound(3)
			ZL_Print(ZL_SLASH_TEST_BLUE)
		elseif (msgLower:find('purple') or msgLower:find('epic')) then
			Test_zl_sound(4)
			ZL_Print(ZL_SLASH_TEST_PURPLE)
		elseif (msgLower:find('orange') or msgLower:find('legendary')) then
			Test_zl_sound(5)
			ZL_Print(ZL_SLASH_TEST_ORANGE)
		else
			ZL_Print(ZL_SLASH_TEST_USAGE)
		end
	else
		if Settings and Settings.OpenToCategory then
			Settings.OpenToCategory(ZL_SettingsCategory or ZL_AddonName)
		elseif InterfaceOptionsFrame_OpenToCategory then
			InterfaceOptionsFrame_OpenToCategory(ZL_AddonName)
		end
	end
end

SLASH_ZELDALOOT1 = "/zl";
SLASH_ZELDALOOT2 = "/zeldaloot";
SlashCmdList["ZELDALOOT"] = zl.SlashCommandHandler;