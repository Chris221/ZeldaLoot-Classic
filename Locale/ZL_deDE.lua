-- Deutch translation / Deutsch-Übersetzung

if (GetLocale() == "deDE") then

	ZL_config_TITLE       = "Konfiguration von ZeldaLoot"

	ZL_TEST               = "Test"
	ZL_OK                 = "OK"
	ZL_CANCEL             = "Abbrechen"
	ZL_GREENLOOT          = "Grün (außergewöhnlich)"
	ZL_BLUELOOT           = "Blau (rar)"
	ZL_PURPLELOOT         = "Lila (episch)"
	ZL_ORANGELOOT         = "Orange (legendär)"

	ZL_CRAFTS             = "Hergestellt"
	ZL_RECEIVED           = "Receipts"
	ZL_INHERITED         = "Geerbt"

	ZL_INCLUDEALSO       = "Auch diese Objekte einschließen:"

	ZL_USE_SOUND_SET      = "Geluidssets:"

	-- Messages (for events)
	ZL_LOOTMESSAGE        = "Ihr erhaltet Beute"
	ZL_RECEIVEMESSAGE     = "Ihr bekommt einen Gegenstand"
	ZL_CRAFTMESSAGE       = "Ihr stellt her"
	ZL_CRAFTMESSAGE2      = "Ihr stellt"

	ZL_FILE_TYPE          = "Dateityp"
	ZL_FILE_CHANNEL       = "Audiokanal"

	ZL_DEBUG              = "Debuggen aktivieren"
	ZL_WARN               = "Warnungen aktivieren"

	ZL_WARNING_ENABLING   = "Warnungen aktivieren"
	ZL_WARNING_DIDABLING  = "Warnungen deaktivieren"
	ZL_DEBUG_ENABLING     = "Debugging aktivieren"
	ZL_DEBUG_DIDABLING    = "Debugging deaktivieren"

	ZL_DUMP_START         = "Konfiguration ausgeben"
	ZL_DUMP_FINISH        = "Fertige Dumping-Konfiguration"

	ZL_STARTING_SOUND     = "Ton abspielen für"
	ZL_STOPPING_SOUND     = "Stoppton für"
	ZL_WARNING            = "WARNUNG"

	ZL_DEBUG_ENABLED      = "Der Debug-Modus ist aktiviert"

	ZL_RESET_DEBUG_TEXT   = "Der Debug-Modus wurde deaktiviert. Geben Sie |cffffff00/zl debug|r ein, um es wieder zu aktivieren"
	ZL_RESET_WARNING_TEXT = "Warnungen wurden aktiviert. Geben Sie zum Deaktivieren |cffffff00/zl warn|r ein"
	ZL_RESET_DONE         = "Konfig wurde zurückgesetzt"

	ZL_LOADED             = " Geladen."
	ZL_LOADED_TEXT_1      = "Geben Sie |cffffff00/zeldaloot|r oder |cffffff00/zl|r für die Einstellungen ein"
	ZL_LOADED_TEXT_2      = "Geben Sie |cffffff00/zeldaloot ?|r oder |cffffff00/zl ?|r für das Hilfemenü ein"

	ZL_SLASH_COMMANDS     = "Slash-Befehle:"

	ZL_END_TEXT           = "Ende"
	ZL_SETTINGS_CLOSED    = "Einstellungen geschlossen"
	ZL_NOT_PLAYING        = "KEINE Tonwiedergabe für"
	ZL_LIKELY_DUE_TO      = "wahrscheinlich wegen"
	ZL_BEING_MUTED        = "stummgeschaltet werden"
	ZL_ON_SOUND_CHANNEL   = "auf Tonkanal"

	-- XML
	ZL_XML_TITLE_GREEN_SET = "Grünes Set"
	ZL_XML_TITLE_BLUE_SET = "Blaues Set"
	ZL_XML_TITLE_PURPLE_SET = "Lila Satz"
	ZL_XML_TITLE_ORANGE_SET = "Orangefarbener Satz"
	ZL_XML_TITLE_GREEN_EFFECT = "Grüner Effekt"
	ZL_XML_TITLE_BLUE_EFFECT = "Blauer Effekt"
	ZL_XML_TITLE_PURPLE_EFFECT = "Lila-Effekt"
	ZL_XML_TITLE_ORANGE_EFFECT = "Orange-Effekt"
	ZL_XML_TITLE_GREEN_TEST = "Grünes Audio testen"
	ZL_XML_TITLE_BLUE_TEST = "Blue-Audio testen"
	ZL_XML_TITLE_PURPLE_TEST = "Lila Audio testen"
	ZL_XML_TITLE_ORANGE_TEST = "Orange Audio testen"
	ZL_XML_TITLE_GREEN_CRAFTED = "Grün hergestellt"
	ZL_XML_TITLE_BLUE_CRAFTED = "Blaues Handwerk"
	ZL_XML_TITLE_PURPLE_CRAFTED = "Lila hergestellt"
	ZL_XML_TITLE_ORANGE_CRAFTED = "Orange hergestellt"
	ZL_XML_TITLE_GREEN_RECEIVED = "Grün erhalten"
	ZL_XML_TITLE_BLUE_RECEIVED = "Blau erhalten"
	ZL_XML_TITLE_PURPLE_RECEIVED = "Lila erhalten"
	ZL_XML_TITLE_ORANGE_RECEIVED = "Orange erhalten"
	ZL_XML_TOOLTIP_GREEN_LOOT = "Aktiviert/Deaktiviert Audioeffekte für grüne Gegenstände"
	ZL_XML_TOOLTIP_BLUE_LOOT = "Aktiviert/Deaktiviert Audioeffekte für blaue Gegenstände"
	ZL_XML_TOOLTIP_PURPLE_LOOT = "Aktiviert/deaktiviert Audioeffekte für violette Gegenstände"
	ZL_XML_TOOLTIP_ORANGE_LOOT = "Aktiviert/Deaktiviert Audioeffekte für orange Gegenstände"
	ZL_XML_TOOLTIP_GREEN_SET = "Grünes Audio-Set"
	ZL_XML_TOOLTIP_BLUE_SET = "Blaues Audioset"
	ZL_XML_TOOLTIP_PURPLE_SET = "Lila Audioset"
	ZL_XML_TOOLTIP_ORANGE_SET = "Orange Audioset"
	ZL_XML_TOOLTIP_GREEN_EFFECT = "Grüner Audio-Soundeffekt"
	ZL_XML_TOOLTIP_BLUE_EFFECT = "Blauer Audio-Soundeffekt"
	ZL_XML_TOOLTIP_PURPLE_EFFECT = "Lila Audio-Soundeffekt"
	ZL_XML_TOOLTIP_ORANGE_EFFECT = "Orange Audio-Soundeffekt"
	ZL_XML_TOOLTIP_GREEN_TEST = "Teste den grünen Audioeffekt"
	ZL_XML_TOOLTIP_BLUE_TEST = "Teste den blauen Audioeffekt"
	ZL_XML_TOOLTIP_PURPLE_TEST = "Teste den violetten Audioeffekt"
	ZL_XML_TOOLTIP_ORANGE_TEST = "Teste den orangefarbenen Audioeffekt"
	ZL_XML_TOOLTIP_GREEN_CRAFTED = "Hergestellte grüne Gegenstände"
	ZL_XML_TOOLTIP_BLUE_CRAFTED = "Hergestellte blaue Gegenstände"
	ZL_XML_TOOLTIP_PURPLE_CRAFTED = "Lila Gegenstände, die hergestellt werden"
	ZL_XML_TOOLTIP_ORANGE_CRAFTED = "Orange Gegenstände, die hergestellt werden"
	ZL_XML_TOOLTIP_GREEN_RECEIVED = "Grüne Items erhalten durch Quests, Handel und die Post"
	ZL_XML_TOOLTIP_BLUE_RECEIVED = "Blaue Gegenstände, erhalten durch Quests, Handel und die Post"
	ZL_XML_TOOLTIP_PURPLE_RECEIVED = "Lila Gegenstände, erhalten durch Quests, Handel und die Post"
	ZL_XML_TOOLTIP_ORANGE_RECEIVED = "Orange Gegenstände erhalten durch Quests, Handel und die Post"
	ZL_XML_TOOLTIP_FILE_CHANNEL = "Wählen Sie aus, welchen Audiokanal Sie verwenden möchten.\n\nSFX wird empfohlen"
	ZL_XML_TOOLTIP_INHERITED = "Aktiviert Audio-Sounds für kontogebundene Gegenstände"
	ZL_XML_TOOLTIP_FILE_TYPE = "Wählen Sie aus, welchen Dateityp Sie verwenden möchten"
	ZL_XML_TOOLTIP_WARN = "Aktiviert/deaktiviert Warnungen\n\nEs wird empfohlen, dies aktiviert zu lassen."
	ZL_XML_TOOLTIP_DEBUG = "Aktiviert/deaktiviert den Debug-Modus\n\n|cffff0000DAS WIRD DEN CHAT ÜBERFLUTEN!!"

	-- SLASH COMMANDS
	ZL_SLASH_DEBUG_ENABLED = "Debug-Modus wurde aktiviert"
	ZL_SLASH_DEBUG_DISABLED = "Debug-Modus wurde deaktiviert"
	ZL_SLASH_WARNING_ENABLED = "Warnungen wurden aktiviert"
	ZL_SLASH_WARNING_DISABLED = "Warnungen wurden deaktiviert"

	ZL_SLASH_OPEN_SETTINGS = "Öffnet die Einstellungen."
	ZL_SLASH_DUMP_CONFIG = "Speichert die Konfiguration."
	ZL_SLASH_DEBUG = "Aktiviert/Deaktiviert den Debug-Modus."
	ZL_SLASH_WARNINGS = "Aktiviert/deaktiviert Warnungen."
	ZL_SLASH_EXT = "Schaltet den Audiodateityp zwischen ogg und wav Dateien um."
	ZL_SLASH_EXT_2 = "Wechselt den Kanal des abgespielten Audiodateityps. (Siehe `Typ-Optionen`)"
	ZL_SLASH_EXT_EXTRA = 'Optionen eingeben: "wav", "ogg" [Standard], "mp3"'
	ZL_SLASH_CHANNELS = "Schaltet den Kanal um, auf dem die Audiowiedergabe läuft. (Siehe `Kanaloptionen`)"
	ZL_SLASH_CHANNELS_EXTRA = 'Kanaloptionen: "Master", "SFX" (Ton) [Standard], "Musik", "Ambiente", "Dialog"'
	ZL_SLASH_RESETS = "Setzt die Konfiguration zurück."

	ZL_SLASH_MP3 = "Audioerweiterung wurde auf .mp3 Dateien umgestellt [Experimentell]"
	ZL_SLASH_WAV = "Audioerweiterung wurde auf .wav Dateien umgestellt [empfohlen für besseren Client-Support]"
	ZL_SLASH_OGG = "Audioerweiterung wurde auf .ogg Dateien umgestellt [Von Blizard empfohlen, scheint nicht auf allen Clients zu funktionieren]"

	ZL_SLASH_MASTER = "Audiokanal wurde auf Master geändert [Nicht empfohlen]"
	ZL_SLASH_SFX = "Audiokanal wurde auf SFX (Ton) geändert [empfohlen]"
	ZL_SLASH_MUSIC = "Audiokanal wurde auf Musik geändert"
	ZL_SLASH_AMBIENCE = "Audiokanal wurde auf Umgebung geändert"
	ZL_SLASH_DIALOG = "Audiokanal wurde auf Dialog geändert [empfohlen]"
	ZL_SLASH_DEFAULT = 'Audiokanal wurde auf Standard geändert: "SFX" (Ton) [Empfohlen]'
end