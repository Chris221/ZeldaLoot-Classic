-- Traditional Chinese (Taiwan) translation / 繁體中文 (台灣) 翻譯

if (GetLocale() == "zhTW") then

	ZL_config_TITLE       = "ZeldaLoot 設定"

	ZL_TEST               = "測試"
	ZL_OK                 = "確定"
	ZL_CANCEL             = "取消"
	ZL_GREENLOOT          = "綠色 (優良)"
	ZL_BLUELOOT           = "藍色 (稀有)"
	ZL_PURPLELOOT         = "紫色 (史詩)"
	ZL_ORANGELOOT         = "橘色 (傳說)"

	ZL_CRAFTS             = "製作"
	ZL_RECEIVED           = "收到"
	ZL_INHERITED          = "傳家寶"

	ZL_INCLUDEALSO        = "同時包含這些物品："

	ZL_USE_SOUND_SET      = "音效套裝："

	-- Messages (for events)
	ZL_LOOTMESSAGE        = "你獲得了戰利品"
	ZL_RECEIVEMESSAGE     = "你收到"
	ZL_CRAFTMESSAGE       = "你製作了"
	ZL_CRAFTMESSAGE2      = "你收到物品"

	ZL_FILE_TYPE          = "檔案類型"
	ZL_FILE_CHANNEL       = "音訊頻道"

	ZL_DEBUG              = "啟用除錯"
	ZL_WARN               = "啟用警告"

	ZL_WARNING_ENABLING   = "正在啟用警告"
	ZL_WARNING_DISABLING  = "正在停用警告"
	ZL_DEBUG_ENABLING     = "正在啟用除錯"
	ZL_DEBUG_DISABLING    = "正在停用除錯"

	ZL_DUMP_START         = "正在匯出設定"
	ZL_DUMP_FINISH        = "設定匯出完成"

	ZL_STARTING_SOUND     = "正在播放音效："
	ZL_STOPPING_SOUND     = "正在停止音效："
	ZL_WARNING            = "警告"

	ZL_DEBUG_ENABLED      = "除錯模式已啟用"

	ZL_RESET_DEBUG_TEXT   = "除錯模式已停用。輸入 |cffffff00/zl debug|r 重新啟用"
	ZL_RESET_WARNING_TEXT = "警告已啟用。輸入 |cffffff00/zl warn|r 停用"
	ZL_RESET_DONE         = "設定已重置"

	ZL_LOADED             = " 已載入。"
	ZL_LOADED_TEXT_1      = "輸入 |cffffff00/zeldaloot|r 或 |cffffff00/zl|r 開啟設定"
	ZL_LOADED_TEXT_2      = "輸入 |cffffff00/zeldaloot ?|r 或 |cffffff00/zl ?|r 開啟說明選單"

	ZL_SLASH_COMMANDS     = "斜線指令："

	ZL_END_TEXT           = "結束"
	ZL_SETTINGS_CLOSED    = "設定已關閉"
	ZL_NOT_PLAYING        = "未播放音效："
	ZL_LIKELY_DUE_TO      = "可能原因："
	ZL_BEING_MUTED        = "已靜音"
	ZL_ON_SOUND_CHANNEL   = "音效頻道："

	ZL_XML_TITLE_GREEN_SET         = "綠色套裝"
	ZL_XML_TITLE_BLUE_SET          = "藍色套裝"
	ZL_XML_TITLE_PURPLE_SET        = "紫色套裝"
	ZL_XML_TITLE_ORANGE_SET        = "橘色套裝"
	ZL_XML_TITLE_GREEN_EFFECT      = "綠色效果"
	ZL_XML_TITLE_BLUE_EFFECT       = "藍色效果"
	ZL_XML_TITLE_PURPLE_EFFECT     = "紫色效果"
	ZL_XML_TITLE_ORANGE_EFFECT     = "橘色效果"
	ZL_XML_TITLE_GREEN_TEST        = "測試綠色音效"
	ZL_XML_TITLE_BLUE_TEST         = "測試藍色音效"
	ZL_XML_TITLE_PURPLE_TEST       = "測試紫色音效"
	ZL_XML_TITLE_ORANGE_TEST       = "測試橘色音效"
	ZL_XML_TITLE_GREEN_CRAFTED     = "綠色製作"
	ZL_XML_TITLE_BLUE_CRAFTED      = "藍色製作"
	ZL_XML_TITLE_PURPLE_CRAFTED    = "紫色製作"
	ZL_XML_TITLE_ORANGE_CRAFTED    = "橘色製作"
	ZL_XML_TITLE_GREEN_RECEIVED    = "綠色收到"
	ZL_XML_TITLE_BLUE_RECEIVED     = "藍色收到"
	ZL_XML_TITLE_PURPLE_RECEIVED   = "紫色收到"
	ZL_XML_TITLE_ORANGE_RECEIVED   = "橘色收到"
	ZL_XML_TOOLTIP_GREEN_LOOT      = "啟用/停用綠色物品的音效"
	ZL_XML_TOOLTIP_BLUE_LOOT       = "啟用/停用藍色物品的音效"
	ZL_XML_TOOLTIP_PURPLE_LOOT     = "啟用/停用紫色物品的音效"
	ZL_XML_TOOLTIP_ORANGE_LOOT     = "啟用/停用橘色物品的音效"
	ZL_XML_TOOLTIP_GREEN_SET       = "綠色音效套裝"
	ZL_XML_TOOLTIP_BLUE_SET        = "藍色音效套裝"
	ZL_XML_TOOLTIP_PURPLE_SET      = "紫色音效套裝"
	ZL_XML_TOOLTIP_ORANGE_SET      = "橘色音效套裝"
	ZL_XML_TOOLTIP_GREEN_EFFECT    = "綠色音效"
	ZL_XML_TOOLTIP_BLUE_EFFECT     = "藍色音效"
	ZL_XML_TOOLTIP_PURPLE_EFFECT   = "紫色音效"
	ZL_XML_TOOLTIP_ORANGE_EFFECT   = "橘色音效"
	ZL_XML_TOOLTIP_GREEN_TEST      = "測試綠色音效"
	ZL_XML_TOOLTIP_BLUE_TEST       = "測試藍色音效"
	ZL_XML_TOOLTIP_PURPLE_TEST     = "測試紫色音效"
	ZL_XML_TOOLTIP_ORANGE_TEST     = "測試橘色音效"
	ZL_XML_TOOLTIP_GREEN_CRAFTED   = "製作的綠色物品"
	ZL_XML_TOOLTIP_BLUE_CRAFTED    = "製作的藍色物品"
	ZL_XML_TOOLTIP_PURPLE_CRAFTED  = "製作的紫色物品"
	ZL_XML_TOOLTIP_ORANGE_CRAFTED  = "製作的橘色物品"
	ZL_XML_TOOLTIP_GREEN_RECEIVED  = "透過任務、交易和郵件收到的綠色物品"
	ZL_XML_TOOLTIP_BLUE_RECEIVED   = "透過任務、交易和郵件收到的藍色物品"
	ZL_XML_TOOLTIP_PURPLE_RECEIVED = "透過任務、交易和郵件收到的紫色物品"
	ZL_XML_TOOLTIP_ORANGE_RECEIVED = "透過任務、交易和郵件收到的橘色物品"
	ZL_XML_TOOLTIP_FILE_CHANNEL    = "選擇您想使用的音訊頻道。\n\n建議使用 SFX"
	ZL_XML_TOOLTIP_INHERITED       = "為帳號綁定物品啟用音效"
	ZL_XML_TOOLTIP_FILE_TYPE       = "選擇您想使用的檔案類型"
	ZL_XML_TOOLTIP_WARN            = "啟用/停用警告\n\n建議保持啟用。"
	ZL_XML_TOOLTIP_DEBUG           = "啟用/停用除錯模式\n\n|cffff0000這會刷屏聊天視窗！！"

	ZL_VOLUME                      = "音量"
	ZL_XML_TOOLTIP_VOLUME          = "調整音效音量 (0-100%)\n\n播放時暫時調整音訊頻道音量。"

	ZL_SLASH_DEBUG_ENABLED = "除錯模式已啟用"
	ZL_SLASH_DEBUG_DISABLED = "除錯模式已停用"
	ZL_SLASH_WARNING_ENABLED = "警告已啟用"
	ZL_SLASH_WARNING_DISABLED = "警告已停用"

	ZL_SLASH_OPEN_SETTINGS = "開啟設定。"
	ZL_SLASH_DUMP_CONFIG = "匯出設定。"
	ZL_SLASH_DEBUG = "啟用/停用除錯模式。"
	ZL_SLASH_WARNINGS = "啟用/停用警告。"
	ZL_SLASH_EXT = "在 ogg 和 wav 檔案之間切換音訊檔案類型。"
	ZL_SLASH_EXT_2 = "切換播放的音訊檔案類型的頻道。（參見 `類型選項`）"
	ZL_SLASH_EXT_EXTRA = '類型選項："wav"、"ogg" [預設]、"mp3"'
	ZL_SLASH_CHANNELS = "切換音訊播放的頻道。（參見 `頻道選項`）"
	ZL_SLASH_CHANNELS_EXTRA = '頻道選項："Master"、"SFX"（音效）[預設]、"Music"、"Ambience"、"Dialog"'
	ZL_SLASH_RESETS = "重置設定。"

	ZL_SLASH_MP3 = "音訊副檔名已切換為 .mp3 檔案 [實驗性]"
	ZL_SLASH_WAV = "音訊副檔名已切換為 .wav 檔案 [建議以獲得更好的客戶端支援]"
	ZL_SLASH_OGG = "音訊副檔名已切換為 .ogg 檔案 [暴雪建議，但可能不適用於所有客戶端]"

	ZL_SLASH_MASTER = "音訊頻道已更改為 Master [不建議]"
	ZL_SLASH_SFX = "音訊頻道已更改為 SFX（音效）[建議]"
	ZL_SLASH_MUSIC = "音訊頻道已更改為 Music"
	ZL_SLASH_AMBIENCE = "音訊頻道已更改為 Ambience"
	ZL_SLASH_DIALOG = "音訊頻道已更改為 Dialog [建議]"
	ZL_SLASH_DEFAULT = '音訊頻道已更改為預設值："SFX"（音效）[建議]'

	ZL_SLASH_TEST = "測試音效。"
	ZL_SLASH_TEST_USAGE = "用法：/zl test [green|blue|purple|orange]"
	ZL_SLASH_TEST_GREEN = "正在測試綠色（優良）音效..."
	ZL_SLASH_TEST_BLUE = "正在測試藍色（稀有）音效..."
	ZL_SLASH_TEST_PURPLE = "正在測試紫色（史詩）音效..."
	ZL_SLASH_TEST_ORANGE = "正在測試橘色（傳說）音效..."
end