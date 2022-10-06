local zl = {};

function zl.SlashCommandHandler(msg)
	if (msg == 'help' or msg == '?' or msg == 'h') then
		zl_Print(ZL_SLASH_COMMANDS)
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
		dump_config(msg)
	elseif (msg == 'debug') then
		if (zl_debug_bool) then
			zl_debug_bool = false
			zl_Print('Debug mode has been disabled')
		else
			zl_debug_bool = true
			zl_Print('Debug mode has been enabled')
		end
	elseif (msg == 'warnings' or msg == 'warning' or msg == 'warn') then
		if (zl_warning_bool) then
			zl_warning_bool = false
			zl_Print('Warnings have been disabled')
		else
			zl_warning_bool = true
			zl_Print('Warnings have been enabled')
		end
	elseif (msg:find('^ext') ~= nil) then
		if (msg:find('[mM][pP]3') ~= nil) then
			zl_config["settings"]["ext"] = "mp3"
			zl_Print("Audio ext has been switched to .mp3 files [Experimental]")
		elseif (msg:find('[wW][aA][vV]') ~= nil) then
			zl_config["settings"]["ext"] = "wav"
			zl_Print("Audio ext has been switched to .wav files [Recommended for better client support]")
		elseif (msg:find('[oO][gG][gG]') ~= nil) then
			zl_config["settings"]["ext"] = "ogg"
			zl_Print("Audio ext has been switched to .ogg files [Blizard Recommended, doesn't seem to work on all clients]")
		elseif (zl_config["settings"]["ext"] == "wav") then
			zl_config["settings"]["ext"] = "ogg"
			zl_Print("Audio ext has been switched to .ogg files [Blizard Recommended, doesn't seem to work on all clients]")
		else
			zl_config["settings"]["ext"] = "wav"
			zl_Print("Audio ext has been switched to .wav files [Recommended for better client support]")
		end
	elseif (msg:find('^channel') ~= nil) then
		if (msg:find('[mM]aster') ~= nil) then
			zl_config["settings"]["channel"] = "Master"
			zl_Print("Audio channel was changed to Master [Not Recommended]")
		elseif (msg:find('[sS][fF][xX]') ~= nil) then
			zl_config["settings"]["channel"] = "SFX"
			zl_Print("Audio channel was changed to SFX (Sound) [Recommended]")
		elseif (msg:find('[mM]usic') ~= nil) then
			zl_config["settings"]["channel"] = "Music"
			zl_Print("Audio channel was changed to Music")
		elseif (msg:find('[aA]mbience') ~= nil) then
			zl_config["settings"]["channel"] = "Ambience"
			zl_Print("Audio channel was changed to Ambience")
		elseif (msg:find('[dD]ialog') ~= nil) then
			zl_config["settings"]["channel"] = "Dialog"
			zl_Print("Audio channel was changed to Dialog [Recommended]")
		else
			zl_config["settings"]["channel"] = "SFX"
			zl_Print('Audio channel was changed to the default: "SFX" (Sound) [Recommended]')
		end
	elseif (msg == 'reset') then
		reset_config(true)
	else
		InterfaceOptionsFrame_OpenToCategory(ZL_AddonName)
	end
end

SLASH_ZL1 = "/zl";
SLASH_ZELDALOOT1 = "/zeldaloot";
SlashCmdList["ZL"] = zl.SlashCommandHandler;
SlashCmdList["ZELDALOOT"] = zl.SlashCommandHandler;