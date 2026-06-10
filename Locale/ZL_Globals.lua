-- Global Text Variables
ZL_SET_ALTTP            = "ALTTP: A Link to the Past"
ZL_SET_OOT              = "OOT: Ocarina of Time Orchestrated"
ZL_SET_TP               = "TP: Twilight Princess"

-- General Global Variables
ZL_AddonVersion         = "|cff00ff002.4.0|r"
ZL_AddonName            = "ZeldaLoot Classic"
ZL_AddonColor           = "|cff00ffff"
ZL_soundHandle          = 0

ZL_TOOLTIP_ANCHOR       = "ANCHOR_RIGHT"

-- Sound Set Constants
ZL_SOUND_SETS = {
	[0] = "ALTTP",
	[1] = "OOT",
	[2] = "TP"
}

ZL_SOUND_SET_IDS = {
	ALTTP = 0,
	OOT = 1,
	TP = 2
}

ZL_SOUND_COUNTS = {
	ALTTP = 5,
	OOT = 4,
	TP = 5
}

-- Quality index to group name mapping
ZL_QUALITY_GROUPS = {
	[2] = "green",
	[3] = "blue",
	[4] = "purple",
	[5] = "orange"
}

-- Config version for migration
ZL_CONFIG_VERSION = 2

-- Seconds to keep a temporarily-scaled channel volume before restoring it.
-- Must comfortably exceed the longest sound in any set.
ZL_VOLUME_RESTORE_DELAY = 5