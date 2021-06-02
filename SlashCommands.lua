local zl = {};

function zl.SlashCommandHandler(msg)
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

SLASH_ZL1 = "/zl";
SLASH_ZELDALOOT1 = "/zeldaloot";
SlashCmdList["ZL"] = zl.SlashCommandHandler;
SlashCmdList["ZELDALOOT"] = zl.SlashCommandHandler;