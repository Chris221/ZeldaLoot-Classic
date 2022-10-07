-- English translation (default)

if ((GetLocale() ~= "frFR") and (GetLocale() ~= "esES") and (GetLocale() ~= "deDE") and (GetLocale() ~= "ruRU")) then

	ZL_config_TITLE       = "ZeldaLoot Configuration"

	ZL_TEST               = "Test"
	ZL_OK                 = "OK"
	ZL_CANCEL             = "Cancel"
	ZL_GREENLOOT          = "Green (uncommon)"
	ZL_BLUELOOT           = "Blue (rare)"
	ZL_PURPLELOOT         = "Purple (epic)"
	ZL_ORANGELOOT         = "Orange (legendary)"

	ZL_CRAFTS             = "Crafted"
	ZL_RECEIVED           = "Received"
	ZL_INHERITED          = "Inherited"

	ZL_INCLUDEALSO        = "Include also these objects:"

	ZL_USE_SOUND_SET      = "Sound sets:"

	-- Messages (for events)
	ZL_LOOTMESSAGE        = "You receive loot"
	ZL_RECEIVEMESSAGE     = "You receive"
	ZL_CRAFTMESSAGE       = "You create"
	ZL_CRAFTMESSAGE2      = "You receive object"

	ZL_FILE_TYPE          = "File Type"
	ZL_FILE_CHANNEL       = "Audio Channel"

	ZL_DEBUG              = "Enable debugging"
	ZL_WARN               = "Enable warnings"

	ZL_WARNING_ENABLING   = "Enabling warnings"
	ZL_WARNING_DIDABLING  = "Disabling warnings"
	ZL_DEBUG_ENABLING     = "Enabling debugging"
	ZL_DEBUG_DIDABLING    = "Disabling debugging"

	ZL_DUMP_START         = "Dumping config"
	ZL_DUMP_FINISH        = "Finished dumping config"

	ZL_STARTING_SOUND     = "Playing sound for"
	ZL_STOPPING_SOUND     = "Stopping sound for"
	ZL_WARNING            = "WARNING"

	ZL_DEBUG_ENABLED      = "Debug mode is enabled"

	ZL_RESET_DEBUG_TEXT   = "Debug mode has been disabled. Type |cffffff00/zl debug|r to re-enable"
	ZL_RESET_WARNING_TEXT = "Warnings have been enabled. Type |cffffff00/zl warn|r to disable"
	ZL_RESET_DONE         = "Config has been reset"

	ZL_LOADED             = " Loaded."
	ZL_LOADED_TEXT_1      = "Type |cffffff00/zeldaloot|r or |cffffff00/zl|r for the settings"
	ZL_LOADED_TEXT_2      = "Type |cffffff00/zeldaloot ?|r or |cffffff00/zl ?|r for the help menu"

	ZL_SLASH_COMMANDS     = "Slash Commands:"

	ZL_END_TEXT           = "end"
	ZL_SETTINGS_CLOSED    = "Settings closed"
	ZL_NOT_PLAYING        = "NOT playing sound for"
	ZL_LIKELY_DUE_TO      = "likely due to"
	ZL_BEING_MUTED        = "being muted"
	ZL_ON_SOUND_CHANNEL   = "on sound channel"

	-- XML
	ZL_XML_TITLE_GREEN_SET         = "Green Set"
	ZL_XML_TITLE_BLUE_SET          = "Blue Set"
	ZL_XML_TITLE_PURPLE_SET        = "Purple Set"
	ZL_XML_TITLE_ORANGE_SET        = "Orange Set"
	ZL_XML_TITLE_GREEN_EFFECT      = "Green Effect"
	ZL_XML_TITLE_BLUE_EFFECT       = "Blue Effect"
	ZL_XML_TITLE_PURPLE_EFFECT     = "Purple Effect"
	ZL_XML_TITLE_ORANGE_EFFECT     = "Orange Effect"
	ZL_XML_TITLE_GREEN_TEST        = "Test green audio"
	ZL_XML_TITLE_BLUE_TEST         = "Test blue audio"
	ZL_XML_TITLE_PURPLE_TEST       = "Test purple audio"
	ZL_XML_TITLE_ORANGE_TEST       = "Test orange audio"
	ZL_XML_TITLE_GREEN_CRAFTED     = "Green Crafted"
	ZL_XML_TITLE_BLUE_CRAFTED      = "Blue Crafted"
	ZL_XML_TITLE_PURPLE_CRAFTED    = "Purple Crafted"
	ZL_XML_TITLE_ORANGE_CRAFTED    = "Orange Crafted"
	ZL_XML_TITLE_GREEN_RECEIVED    = "Green Received"
	ZL_XML_TITLE_BLUE_RECEIVED     = "Blue Received"
	ZL_XML_TITLE_PURPLE_RECEIVED   = "Purple Received"
	ZL_XML_TITLE_ORANGE_RECEIVED   = "Orange Received"
	ZL_XML_TOOLTIP_GREEN_LOOT      = "Enables/Disables audio effects for green items"
	ZL_XML_TOOLTIP_BLUE_LOOT       = "Enables/Disables audio effects for blue items"
	ZL_XML_TOOLTIP_PURPLE_LOOT     = "Enables/Disables audio effects for purple items"
	ZL_XML_TOOLTIP_ORANGE_LOOT     = "Enables/Disables audio effects for orange items"
	ZL_XML_TOOLTIP_GREEN_SET       = "Green audio set"
	ZL_XML_TOOLTIP_BLUE_SET        = "Blue audio set"
	ZL_XML_TOOLTIP_PURPLE_SET      = "Purple audio set"
	ZL_XML_TOOLTIP_ORANGE_SET      = "Orange audio set"
	ZL_XML_TOOLTIP_GREEN_EFFECT    = "Green audio sound effect"
	ZL_XML_TOOLTIP_BLUE_EFFECT     = "Blue audio sound effect"
	ZL_XML_TOOLTIP_PURPLE_EFFECT   = "Purple audio sound effect"
	ZL_XML_TOOLTIP_ORANGE_EFFECT   = "Orange audio sound effect"
	ZL_XML_TOOLTIP_GREEN_TEST      = "Test the green audio effect"
	ZL_XML_TOOLTIP_BLUE_TEST       = "Test the blue audio effect"
	ZL_XML_TOOLTIP_PURPLE_TEST     = "Test the purple audio effect"
	ZL_XML_TOOLTIP_ORANGE_TEST     = "Test the orange audio effect"
	ZL_XML_TOOLTIP_GREEN_CRAFTED   = "Green items that are crafted"
	ZL_XML_TOOLTIP_BLUE_CRAFTED    = "Blue items that are crafted"
	ZL_XML_TOOLTIP_PURPLE_CRAFTED  = "Purple items that are crafted"
	ZL_XML_TOOLTIP_ORANGE_CRAFTED  = "Orange items that are crafted"
	ZL_XML_TOOLTIP_GREEN_RECEIVED  = "Green items received through quests, trade, and the mail"
	ZL_XML_TOOLTIP_BLUE_RECEIVED   = "Blue items received through quests, trade, and the mail"
	ZL_XML_TOOLTIP_PURPLE_RECEIVED = "Purple items received through quests, trade, and the mail"
	ZL_XML_TOOLTIP_ORANGE_RECEIVED = "Orange items received through quests, trade, and the mail"
	ZL_XML_TOOLTIP_FILE_CHANNEL    = "Select which audio channel you would like to use.\n\nSFX is Recommended"
	ZL_XML_TOOLTIP_INHERITED       = "Enables audio sounds for account bound items"
	ZL_XML_TOOLTIP_FILE_TYPE       = "Select which file type you would like to use"
	ZL_XML_TOOLTIP_WARN            = "Enables/Disables warnings\n\nRecommended to leave this on."
	ZL_XML_TOOLTIP_DEBUG           = "Enables/Disables debug mode\n\n|cffff0000THIS WILL FLOOD THE CHAT!!"

	-- SLASH COMMANDS
	ZL_SLASH_DEBUG_ENABLED = "Debug mode has been enabled"
	ZL_SLASH_DEBUG_DISABLED = "Debug mode has been disabled"
	ZL_SLASH_WARNING_ENABLED = "Warnings have been enabled"
	ZL_SLASH_WARNING_DISABLED = "Warnings have been disabled"

	ZL_SLASH_OPEN_SETTINGS = "Opens the settings."
	ZL_SLASH_DUMP_CONFIG = "Dumps the config."
	ZL_SLASH_DEBUG = "Enables/Disables debug mode."
	ZL_SLASH_WARNINGS = "Enables/Disables warnings."
	ZL_SLASH_EXT = "Switches the audio file type between ogg and wav files."
	ZL_SLASH_EXT_2 = "Switches the channel the audio file type that plays. (See `Type Options`)"
	ZL_SLASH_EXT_EXTRA = 'Type Options: "wav", "ogg" [Default], "mp3"'
	ZL_SLASH_CHANNELS = "Switches the channel the audio plays on. (See `Channel Options`)"
	ZL_SLASH_CHANNELS_EXTRA = 'Channel Options: "Master", "SFX" (Sound) [Default], "Music", "Ambience", "Dialog"'
	ZL_SLASH_RESETS = "Resets the config."

	ZL_SLASH_MP3 = "Audio ext has been switched to .mp3 files [Experimental]"
	ZL_SLASH_WAV = "Audio ext has been switched to .wav files [Recommended for better client support]"
	ZL_SLASH_OGG = "Audio ext has been switched to .ogg files [Blizard Recommended, doesn't seem to work on all clients]"

	ZL_SLASH_MASTER = "Audio channel was changed to Master [Not Recommended]"
	ZL_SLASH_SFX = "Audio channel was changed to SFX (Sound) [Recommended]"
	ZL_SLASH_MUSIC = "Audio channel was changed to Music"
	ZL_SLASH_AMBIENCE = "Audio channel was changed to Ambience"
	ZL_SLASH_DIALOG = "Audio channel was changed to Dialog [Recommended]"
	ZL_SLASH_DEFAULT = 'Audio channel was changed to the default: "SFX" (Sound) [Recommended]'
end