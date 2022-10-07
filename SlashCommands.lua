local zl = {};

function zl.SlashCommandHandler(msg)
	if (msg == 'help' or msg == '?' or msg == 'h') then
		ZL_Print(ZL_SLASH_COMMANDS)
		print('|cffffaa00/zl |r- Opens the settings.')
		print('|cffffaa00/zeldaloot |r- Opens the settings.')
		print('|cffffaa00/zl dump |r- Dumps the config.')
		print('|cffffaa00/zeldaloot dump |r- Dumps the config.')
		print('|cffffaa00/zl debug |r- Enables/Disables debug mode.')
		print('|cffffaa00/zeldaloot debug |r- Enables/Disables debug mode.')
		print('|cffffaa00/zl [warnings|warning|warn] |r- Enables/Disables warnings.')
		print('|cffffaa00/zeldaloot [warnings|warning|warn] |r- Enables/Disables warnings.')
		print('|cffffaa00/zl ext |r- Switches the audio file type between ogg and wav files.')
		print('|cffffaa00/zeldaloot ext |r- Switches the audio file type between ogg and wav files.')
		print('|cffffaa00/zl channel [Master|SFX|Music|Ambience|Dialog] |r- Switches the channel the audio plays on. (See `Channel Options`)')
		print('|cffffaa00/zeldaloot channel [Master|SFX|Music|Ambience|Dialog] |r- Switches the channel the audio plays on. (See `Channel Options`)')
		print('Channel Options: "Master", "SFX" (Sound) [Default], "Music", "Ambience", "Dialog"')
		print('|cffffaa00/zl reset |r- Resets the config.')
		print('|cffffaa00/zeldaloot reset |r- Resets the config.')
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
			ZL_Print("Audio ext has been switched to .mp3 files [Experimental]")
		elseif (msg:find('[wW][aA][vV]') ~= nil) then
			ZL_config["settings"]["ext"] = "wav"
			ZL_Print("Audio ext has been switched to .wav files [Recommended for better client support]")
		elseif (msg:find('[oO][gG][gG]') ~= nil) then
			ZL_config["settings"]["ext"] = "ogg"
			ZL_Print("Audio ext has been switched to .ogg files [Blizard Recommended, doesn't seem to work on all clients]")
		elseif (ZL_config["settings"]["ext"] == "wav") then
			ZL_config["settings"]["ext"] = "ogg"
			ZL_Print("Audio ext has been switched to .ogg files [Blizard Recommended, doesn't seem to work on all clients]")
		else
			ZL_config["settings"]["ext"] = "wav"
			ZL_Print("Audio ext has been switched to .wav files [Recommended for better client support]")
		end
	elseif (msg:find('^channel') ~= nil) then
		if (msg:find('[mM]aster') ~= nil) then
			ZL_config["settings"]["channel"] = "Master"
			ZL_Print("Audio channel was changed to Master [Not Recommended]")
		elseif (msg:find('[sS][fF][xX]') ~= nil) then
			ZL_config["settings"]["channel"] = "SFX"
			ZL_Print("Audio channel was changed to SFX (Sound) [Recommended]")
		elseif (msg:find('[mM]usic') ~= nil) then
			ZL_config["settings"]["channel"] = "Music"
			ZL_Print("Audio channel was changed to Music")
		elseif (msg:find('[aA]mbience') ~= nil) then
			ZL_config["settings"]["channel"] = "Ambience"
			ZL_Print("Audio channel was changed to Ambience")
		elseif (msg:find('[dD]ialog') ~= nil) then
			ZL_config["settings"]["channel"] = "Dialog"
			ZL_Print("Audio channel was changed to Dialog [Recommended]")
		else
			ZL_config["settings"]["channel"] = "SFX"
			ZL_Print('Audio channel was changed to the default: "SFX" (Sound) [Recommended]')
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