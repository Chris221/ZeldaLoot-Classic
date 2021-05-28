local zle = {};

function zle.SlashCommandHandler(msg)
	local frame = getglobal("ZLE_ConfigPanel")

	if (frame) then
		if (frame:IsVisible()) then
			--frame:Hide();
			hide_zle_frame();
		else
			--frame:Show();
			show_zle_frame();
		end
	end
end

SLASH_ZLE1 = "/zle";
SlashCmdList["ZLE"] = zle.SlashCommandHandler;