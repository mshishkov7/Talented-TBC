local Talented = Talented
local L = LibStub("AceLocale-3.0"):GetLocale("Talented")

function Talented:WriteToChat(text, ...)
	if text:find("%", 1, true) then text = text:format(...) end
	local edit = ChatEdit_GetLastActiveWindow and ChatEdit_GetLastActiveWindow() or DEFAULT_CHAT_FRAME.editBox
	local type = edit:GetAttribute("chatType")
	local lang = edit.language
	if type == "WHISPER" then
		local target = edit:GetAttribute("tellTarget")
		SendChatMessage(text, type, lang, target)
	elseif type == "CHANNEL" then
		local channel = edit:GetAttribute("channelTarget")
		SendChatMessage(text, type, lang, channel)
	else
		SendChatMessage(text, type, lang)
	end
end

StaticPopupDialogs.TALENTED_SHOW_DIALOG = {
	text = L["URL:"],
	button1 = OKAY,
	hasEditBox = 1,
	hasWideEditBox = 1,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		local editBox = _G[self:GetName().."EditBox"]
		if editBox then
			editBox:HighlightText()
		end
	end,
	OnAccept = function(self)
		self:Hide()
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
}

function Talented:ShowInDialog(text, ...)
	if text:find("%%", 1, true) then text = text:format(...) end
	
	StaticPopupDialogs.TALENTED_SHOW_DIALOG.OnShow = function(self)
		local editBox = _G[self:GetName().."EditBox"]
		if editBox then
			editBox:SetText(text)
			editBox:HighlightText()
		end
	end

	StaticPopup_Show("TALENTED_SHOW_DIALOG")
end