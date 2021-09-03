local zl = {};

function zl.SlashCommandHandler(msg)
	if (msg == 'help') then
		zl_Print('Slash Commands:')
		print('|cffffaa00/zl |r- Opens the settings.')
		print('|cffffaa00/zeldaloot |r- Opens the settings.')
		print('|cffffaa00/zl dump |r- Dumps the config.')
		print('|cffffaa00/zeldaloot dump |r- Dumps the config.')
		print('|cffffaa00/zl debug |r- Enables debug mode.')
		print('|cffffaa00/zeldaloot debug |r- Enables debug mode.')
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
	elseif (msg == 'reset') then
		reset_config(true)
	else
		local frame = getglobal("ZL_ConfigPanel")

		if (frame) then
			if (frame:IsVisible()) then
				--frame:Hide();
				hide_zl_frame();
			else
				--frame:Show();
				show_zl_frame();
			end
		end
	end
end

SLASH_ZL1 = "/zl";
SLASH_ZELDALOOT1 = "/zeldaloot";
SlashCmdList["ZL"] = zl.SlashCommandHandler;
SlashCmdList["ZELDALOOT"] = zl.SlashCommandHandler;