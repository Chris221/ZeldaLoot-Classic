-- English translation (default)

if ((GetLocale() ~= "frFR") and (GetLocale() ~= "esES") and (GetLocale() ~= "deDE")) then

	ZLE_CONFIG_TITLE = "ZeldaLoot Extended configuration"

	ZLE_TEST         = "Test"
	ZLE_OK           = "OK"
	ZLE_CANCEL       = "Cancel"
	ZLE_GREENLOOT    = "Green (not common)"
	ZLE_BLUELOOT     = "Blue (rare)"
	ZLE_PURPLELOOT   = "Purple (epic)"
	ZLE_ORANGELOOT   = "Orange (legendary)"

	ZLE_CRAFTS       = "Crafted"
	ZLE_RECEIVED     = "Received"
	ZLE_INHERITED    = "Inherited"

	ZLE_INCLUDEALSO  = "Include also\nthese objects:"

	ZLE_USE_SOUND_SET  = "Sound set to use:"
	ZLE_SET_ALTTP      = "A Link to the Past"
	ZLE_SET_OOT        = "Ocarina of Time Orchestrated"
	ZLE_SET_TP         = "Twilight Princess"

	-- Messages (for events)
	ZLE_LOOTMESSAGE    = "You receive loot"
	ZLE_RECEIVEMESSAGE = "You receive"
	ZLE_CRAFTMESSAGE   = "You create"
	ZLE_CRAFTMESSAGE2  = "You receive object"
end