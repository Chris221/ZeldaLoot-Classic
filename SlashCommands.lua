local zl = {};

function zl.SlashCommandHandler(msg)
	if (msg == 'help' or msg == '?' or msg == 'h') then
		ZL_Print(ZL_SLASH_COMMANDS)
		print('|cffffaa00/zl |r- ' .. ZL_SLASH_OPEN_SETTINGS)
		print('|cffffaa00/zeldaloot |r- ' .. ZL_SLASH_OPEN_SETTINGS)
		print('|cffffaa00/zl dump |r- ' .. ZL_SLASH_DUMP_CONFIG)
		print('|cffffaa00/zeldaloot dump |r- ' .. ZL_SLASH_DUMP_CONFIG)
		print('|cffffaa00/zl debug |r- ' .. ZL_SLASH_DEBUG)
		print('|cffffaa00/zeldaloot debug |r- ' .. ZL_SLASH_DEBUG)
		print('|cffffaa00/zl [warnings|warning|warn] |r- ' .. ZL_SLASH_WARNINGS)
		print('|cffffaa00/zeldaloot [warnings|warning|warn] |r- ' .. ZL_SLASH_WARNINGS)
		print('|cffffaa00/zl ext |r- ' .. ZL_SLASH_EXT)
		print('|cffffaa00/zeldaloot ext |r- ' .. ZL_SLASH_EXT)
		print('|cffffaa00/zl ext [wav|ogg|mp3] |r- ' .. ZL_SLASH_EXT_2)
		print('|cffffaa00/zeldaloot ext [wav|ogg|mp3] |r- ' .. ZL_SLASH_EXT_2)
		print(ZL_SLASH_EXT_EXTRA)
		print('|cffffaa00/zl channel [Master|SFX|Music|Ambience|Dialog] |r- ' .. ZL_SLASH_CHANNELS)
		print('|cffffaa00/zeldaloot channel [Master|SFX|Music|Ambience|Dialog] |r- ' .. ZL_SLASH_CHANNELS)
		print(ZL_SLASH_CHANNELS_EXTRA)
		print('|cffffaa00/zl reset |r- ' .. ZL_SLASH_RESETS)
		print('|cffffaa00/zeldaloot reset |r- ' .. ZL_SLASH_RESETS)
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
	elseif (msg:find('^ext') ~= nil) then
		if (msg:find('[mM][pP]3') ~= nil) then
			ZL_config["settings"]["ext"] = "mp3"
			ZL_Print(ZL_SLASH_MP3)
		elseif (msg:find('[wW][aA][vV]') ~= nil) then
			ZL_config["settings"]["ext"] = "wav"
			ZL_Print(ZL_SLASH_WAV)
		elseif (msg:find('[oO][gG][gG]') ~= nil) then
			ZL_config["settings"]["ext"] = "ogg"
			ZL_Print(ZL_SLASH_OGG)
		elseif (ZL_config["settings"]["ext"] == "wav") then
			ZL_config["settings"]["ext"] = "ogg"
			ZL_Print(ZL_SLASH_OGG)
		else
			ZL_config["settings"]["ext"] = "wav"
			ZL_Print(ZL_SLASH_WAV)
		end
	elseif (msg:find('^channel') ~= nil) then
		if (msg:find('[mM]aster') ~= nil) then
			ZL_config["settings"]["channel"] = "Master"
			ZL_Print(ZL_SLASH_MASTER)
		elseif (msg:find('[sS][fF][xX]') ~= nil) then
			ZL_config["settings"]["channel"] = "SFX"
			ZL_Print(ZL_SLASH_SFX)
		elseif (msg:find('[mM]usic') ~= nil) then
			ZL_config["settings"]["channel"] = "Music"
			ZL_Print(ZL_SLASH_MUSIC)
		elseif (msg:find('[aA]mbience') ~= nil) then
			ZL_config["settings"]["channel"] = "Ambience"
			ZL_Print(ZL_SLASH_AMBIENCE)
		elseif (msg:find('[dD]ialog') ~= nil) then
			ZL_config["settings"]["channel"] = "Dialog"
			ZL_Print(ZL_SLASH_DIALOG)
		else
			ZL_config["settings"]["channel"] = "SFX"
			ZL_Print(ZL_SLASH_DEFAULT)
		end
	elseif (msg == 'reset') then
		Reset_config(true)
	else
		InterfaceOptionsFrame_OpenToCategory(ZL_AddonName)
	end
end

SLASH_ZL1 = "/zl";
SLASH_ZELDALOOT1 = "/zeldaloot";
SlashCmdList["ZL"] = zl.SlashCommandHandler;
SlashCmdList["ZELDALOOT"] = zl.SlashCommandHandler;