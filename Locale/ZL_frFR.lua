-- French translation / traduction française

if (GetLocale() == "frFR") then

	ZL_config_TITLE       = "Configuration de ZeldaLoot"

	ZL_TEST               = "Tester"
	ZL_OK                 = "OK"
	ZL_CANCEL             = "Annuler"
	ZL_GREENLOOT          = "Vert (inhabituel)"
	ZL_BLUELOOT           = "Bleu (rare)"
	ZL_PURPLELOOT         = "Violet (épique)"
	ZL_ORANGELOOT         = "Orange (légendaire)"

	ZL_CRAFTS             = "Crées"
	ZL_RECEIVED           = "Reçus"
	ZL_INHERITED          = "Liés au compte"

	ZL_INCLUDEALSO        = "Inclure également\nces objets:"

	ZL_USE_SOUND_SET      = "Ensembles de sons:"

	-- Messages (for events)
	ZL_LOOTMESSAGE        = "Vous recevez le butin"
	ZL_RECEIVEMESSAGE     = "Vous recevez"
	ZL_CRAFTMESSAGE       = "Vous créez"
	ZL_CRAFTMESSAGE2      = "Vous recevez l'objet"

	ZL_FILE_TYPE          = "Type de fichier"
	ZL_FILE_CHANNEL       = "Canal audio"

	ZL_DEBUG              = "Activer le débogage"
	ZL_WARN               = "Activer les avertissements"

	ZL_WARNING_ENABLING   = "Activation des avertissements"
	ZL_WARNING_DIDABLING  = "Désactivation des avertissements"
	ZL_DEBUG_ENABLING     = "Activation du débogage"
	ZL_DEBUG_DIDABLING    = "Désactiver le débogage"

	ZL_DUMP_START         = "Configuration de vidage"
	ZL_DUMP_FINISH        = "Configuration de vidage terminée"

	ZL_STARTING_SOUND     = "Lecture du son pour"
	ZL_STOPPING_SOUND     = "Arrêt du son pour"
	ZL_WARNING            = "ATTENTION"

	ZL_DEBUG_ENABLED      = "Le mode débogage est activé"

	ZL_RESET_DEBUG_TEXT   = "Le mode débogage a été désactivé. Tapez |cffffff00/zl debug|r pour réactiver"
	ZL_RESET_WARNING_TEXT = "Les avertissements ont été activés. Tapez |cffffff00/zl warn|r pour désactiver"
	ZL_RESET_DONE         = "La configuration a été réinitialisée"

	ZL_LOADED             = " Chargé."
	ZL_LOADED_TEXT_1      = "Tapez |cffffff00/zeldaloot|r ou |cffffff00/zl|r pour les paramètres"
	ZL_LOADED_TEXT_2      = "Tapez |cffffff00/zeldaloot ?|r ou |cffffff00/zl ?|r pour le menu d'aide"

	ZL_SLASH_COMMANDS     = "Commandes de barre oblique:"

	ZL_END_TEXT           = "fin"
	ZL_SETTINGS_CLOSED    = "Paramètres fermés"
	ZL_NOT_PLAYING        = "PAS de son pour"
	ZL_LIKELY_DUE_TO      = "probablement en raison de"
	ZL_BEING_MUTED        = "être mis en sourdine"
	ZL_ON_SOUND_CHANNEL   = "sur le canal sonore"

	-- XML
	ZL_XML_TITLE_GREEN_SET = "Ensemble vert"
	ZL_XML_TITLE_BLUE_SET = "Ensemble bleu"
	ZL_XML_TITLE_PURPLE_SET = "Ensemble violet"
	ZL_XML_TITLE_ORANGE_SET = "Ensemble orange"
	ZL_XML_TITLE_GREEN_EFFECT = "Effet vert"
	ZL_XML_TITLE_BLUE_EFFECT = "Effet bleu"
	ZL_XML_TITLE_PURPLE_EFFECT = "Effet violet"
	ZL_XML_TITLE_ORANGE_EFFECT = "Effet orange"
	ZL_XML_TITLE_GREEN_TEST = "Tester l'audio vert"
	ZL_XML_TITLE_BLUE_TEST = "Tester l'audio bleu"
	ZL_XML_TITLE_PURPLE_TEST = "Tester l'audio violet"
	ZL_XML_TITLE_ORANGE_TEST = "Tester l'audio orange"
	ZL_XML_TITLE_GREEN_CRAFTED = "Fabriqué en vert"
	ZL_XML_TITLE_BLUE_CRAFTED = "Fabriqué en bleu"
	ZL_XML_TITLE_PURPLE_CRAFTED = "Fabriqué violet"
	ZL_XML_TITLE_ORANGE_CRAFTED = "Orange fabriqué"
	ZL_XML_TITLE_GREEN_RECEIVED = "Vert reçu"
	ZL_XML_TITLE_BLUE_RECEIVED = "Bleu reçu"
	ZL_XML_TITLE_PURPLE_RECEIVED = "Violet reçu"
	ZL_XML_TITLE_ORANGE_RECEIVED = "Orange reçu"
	ZL_XML_TOOLTIP_GREEN_LOOT = "Active/Désactive les effets audio pour les objets verts"
	ZL_XML_TOOLTIP_BLUE_LOOT = "Active/Désactive les effets audio pour les éléments bleus"
	ZL_XML_TOOLTIP_PURPLE_LOOT = "Active/Désactive les effets audio pour les éléments violets"
	ZL_XML_TOOLTIP_ORANGE_LOOT = "Active/Désactive les effets audio pour les éléments orange"
	ZL_XML_TOOLTIP_GREEN_SET = "Ensemble audio vert"
	ZL_XML_TOOLTIP_BLUE_SET = "Ensemble audio bleu"
	ZL_XML_TOOLTIP_PURPLE_SET = "Ensemble audio violet"
	ZL_XML_TOOLTIP_ORANGE_SET = "Ensemble audio orange"
	ZL_XML_TOOLTIP_GREEN_EFFECT = "Effet sonore audio vert"
	ZL_XML_TOOLTIP_BLUE_EFFECT = "Effet sonore audio bleu"
	ZL_XML_TOOLTIP_PURPLE_EFFECT = "Effet sonore audio violet"
	ZL_XML_TOOLTIP_ORANGE_EFFECT = "Effet sonore audio orange"
	ZL_XML_TOOLTIP_GREEN_TEST = "Tester l'effet audio vert"
	ZL_XML_TOOLTIP_BLUE_TEST = "Tester l'effet audio bleu"
	ZL_XML_TOOLTIP_PURPLE_TEST = "Tester l'effet audio violet"
	ZL_XML_TOOLTIP_ORANGE_TEST = "Tester l'effet audio orange"
	ZL_XML_TOOLTIP_GREEN_CRAFTED = "Objets verts fabriqués"
	ZL_XML_TOOLTIP_BLUE_CRAFTED = "Objets bleus fabriqués"
	ZL_XML_TOOLTIP_PURPLE_CRAFTED = "Objets violets fabriqués"
	ZL_XML_TOOLTIP_ORANGE_CRAFTED = "Objets orange qui sont fabriqués"
	ZL_XML_TOOLTIP_GREEN_RECEIVED = "Objets verts reçus via les quêtes, le commerce et le courrier"
	ZL_XML_TOOLTIP_BLUE_RECEIVED = "Objets bleus reçus via les quêtes, le commerce et le courrier"
	ZL_XML_TOOLTIP_PURPLE_RECEIVED = "Objets violets reçus via les quêtes, le commerce et le courrier"
	ZL_XML_TOOLTIP_ORANGE_RECEIVED = "Objets orange reçus via les quêtes, le commerce et le courrier"
	ZL_XML_TOOLTIP_FILE_CHANNEL = "Sélectionnez le canal audio que vous souhaitez utiliser.\n\nSFX est recommandé"
	ZL_XML_TOOLTIP_INHERITED = "Active les sons audio pour les éléments liés au compte"
	ZL_XML_TOOLTIP_FILE_TYPE = "Sélectionnez le type de fichier que vous souhaitez utiliser"
	ZL_XML_TOOLTIP_WARN = "Active/Désactive les avertissements\n\nIl est recommandé de laisser ceci activé."
	ZL_XML_TOOLTIP_DEBUG = "Active/Désactive le mode débogage\n\n|cffff0000CELA VA INONDER LE CHAT!!"

end