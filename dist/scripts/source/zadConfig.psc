Scriptname zadConfig extends SKI_ConfigBase Conditional

;Libraries
zadLibs Property libs Auto
zadcLibs Property clibs Auto Hidden ; Contraptions ESM has to load after Integration, so we can't refer to zadcLibs on zadcQuest as a property. Instead we load it via form on runtime init.
zadBeltedAnims Property beltedAnims Auto

Function OnInit()
	clibs = Quest.GetQuest("zadcQuest") as zadcLibs
	parent.OnInit()
EndFunction

;Configuration File
String File = "../DD/DDConfig.json"

;Config Menu Script Version
Int Function GetVersion()
	Return 33
EndFunction

;Difficulty
Int Property EscapeDifficulty = 4 Auto Hidden
Int Property CooldownDifficulty = 4 Auto Hidden
Int Property KeyDifficulty = 4 Auto Hidden
Bool Property GlobalDestroyKey = True Auto Hidden
Bool Property DisableLockJam = False Auto Hidden
Bool Property UseItemManipulation = False Auto Hidden
Bool Property UseBoundCombat = True Auto Hidden
Bool Property UseBoundCombatPerks = True Auto Hidden
Bool Property LockMenuWhenTied = False Auto Hidden

;Arousal
Float Property BeltRateMult = 1.5 Auto Hidden
Float Property PlugRateMult = 3.0 Auto Hidden

;Animation
Bool Property useAnimFilter =  True Auto Hidden
Bool Property preserveAggro = True Auto Hidden

;Debug And Logging
Bool Property LogMessages = True Auto Hidden
Bool Property debugSigTerm = False Auto Hidden
Bool Property NpcMessages = True Auto Hidden
Bool Property PlayerMessages = True Auto Hidden

;Morphs
Bool Property breastNodeManagement = False Auto Hidden
Bool Property bellyNodeManagement = False Auto Hidden

;Restraints
Int Property blindfoldMode = 2 Auto Hidden ; 0 == DD's mode, 1 == DD's mode w/ leeches, 2 == leeches
Float Property blindfoldStrength = 0.5 Auto Hidden
Int Property darkfogStrength = 500 Auto Hidden
Bool Property BlindfoldTooltip = True Auto Hidden

Bool Property GagTooltip = True Auto Hidden
Bool Property bootsSlowdownToggle = True Auto Hidden Conditional
Bool Property mittensDropToggle = True Auto Hidden Conditional
Int Property HobbleSkirtSpeedDebuff = 50 Auto Hidden 

;Keys
Int Property FurnitureNPCActionKey = 0xC9 Auto Hidden ; mapped to PgUp key

;Events and Effects
Float Property EventInterval = 1.5 Auto Hidden
Int Property EffectVibrateChance = 25 Auto Hidden
Int Property EffectHealthDrainChance = 50 Auto Hidden
Int Property EffectManaDrainChance = 50 Auto Hidden
Int Property EffectStaminaDrainChance = 50 Auto Hidden
Int Property BaseMessageChance = 10 Auto Hidden
Int Property BaseHornyChance = 5 Auto Hidden
Int Property BaseBumpPumpChance = 17 Auto Hidden
Int Property numNpcs = 15 Auto Hidden Conditional

;Sounds
Float Property VolumeOrgasm = 1.0 Auto Hidden
Float Property VolumeEdged = 1.0 Auto Hidden
Float Property VolumeVibrator = 0.5 Auto Hidden
Float Property VolumeVibratorNPC = 0.25 Auto Hidden
Int Property RubberSoundMode = 1 Auto Hidden
Bool Property MuffleTooltip = True Auto Hidden
Float Property VolumeMuffled = 0.2 Auto Hidden
Float Property VolumeMuffleWhiteNoise = 0.5 Auto Hidden

;Device Hider
Bool Property DevicesUnderneathEnabled = True Auto Hidden
Int Property DevicesUnderneathSlot = 12 Auto Hidden

;Compatibility
Bool Property GotOSLA = False Auto Hidden
Bool Property GotSLIF = False Auto Hidden

; Contraption escape minigame
Bool Property ScheduleMinigameOptionsUpdate = False Auto Hidden ; Used to flag to the minigame that an options was changed.
Bool Property ShowMinigameTutorial = True Auto Hidden
Bool Property ShowMinigameNotifications = True Auto Hidden
Int Property MinigameMinSequenceLength = 3 Auto Hidden
Int Property MinigameMaxSequenceLength = 9 Auto Hidden
Float Property MinigameMinKeyHoldTime = 0.5 Auto Hidden
Float Property MinigameMaxKeyHoldTime = 1.0 Auto Hidden
Float Property MinigameCriticalFailChance = 10.0 Auto Hidden
Float Property MinigameEscalationChance = 10.0 Auto Hidden

;Option IDs - legacy, only used for events and slotmasks for simplicity
Int[] eventOIDs
Int[] slotMaskOIDs

;Menu Option Arrays
String[] Property EsccapeDifficultyList Auto Hidden
String[] difficultyList
String[] blindfoldList
String[] slotMasks
String[] hiderSetting
String[] SoundList
Int[] SlotMaskValues

Function SetupBlindfolds()
	blindfoldList = new String[4]
	blindfoldList[0] = "DD Blindfold"
	blindfoldList[1] = "DD Blindfold with Leeche's Effect"
	blindfoldList[2] = "Leeche's Mode"
	blindfoldList[3] = "Dark Fog" 
EndFunction

Function SetupSoundDuration()
	SoundList = new String[4]
	SoundList[0] = "Never"
	SoundList[1] = "Rare"
	SoundList[2] = "Often"
	SoundList[3] = "Frequently" 
EndFunction

Function SetupEscapeDifficulties()
	; This can be extended as desired, but ALWAYS make it uneven length to centre the modifier at 0%
	EsccapeDifficultyList = new String[9]
	EsccapeDifficultyList[0] = "Born Slave [Hardest]"
	EsccapeDifficultyList[1] = "Submissive"
	EsccapeDifficultyList[2] = "Plaything"
	EsccapeDifficultyList[3] = "Handcuff Girl"
	EsccapeDifficultyList[4] = "Kinky [Default]"
	EsccapeDifficultyList[5] = "Questioning"
	EsccapeDifficultyList[6] = "Experimenting"
	EsccapeDifficultyList[7] = "First time"
	EsccapeDifficultyList[8] = "Vanilla [Easiest]"
EndFunction

Function SetupDifficulties()
	difficultyList = new String[4]
	difficultyList[0] = "Easy"
	difficultyList[1] = "Hard"
	difficultyList[2] = "Medium"
	difficultyList[3] = "Disabled"
EndFunction

Function SetupPages()
	Pages = new string[6]
	Pages[0] = "Devices"
	Pages[1] = "Contraptions"
	Pages[2] = "Events"
	Pages[3] = "Device Hider 1"
	Pages[4] = "Device Hider 2"
	Pages[5] = "Debug"
EndFunction

Function SetupSlotMasks()
	SlotMasks = new String[33]
	SlotMaskValues = new int[33]
	SlotMasks[0] = "None (Disabled)"
	int i = 1
	while i <= 32
		SlotMasks[i] = "Slot " + (30 + i - 1)
		SlotMaskValues[i] = Math.LeftShift(1, (i - 1))
		i += 1
	EndWhile
	SlotMasks[1] = "Head (30)"
	SlotMasks[2] = "Hair (31)"
	SlotMasks[3] = "Body - Full (32)"
	SlotMasks[4] = "Hands (33)"
	SlotMasks[5] = "Forearms (34)"
	SlotMasks[6] = "Amulet (35)"
	SlotMasks[7] = "Ring (36)"
	SlotMasks[8] = "Feet (37)"
	SlotMasks[9] = "Calves (38)"
	SlotMasks[10] = "Shield (39)"
	SlotMasks[11] = "Tail (40)"
	SlotMasks[12] = "Long Hair (41)"
	SlotMasks[13] = "Circlet (42)"
	SlotMasks[14] = "Ears (43)"
	SlotMasks[15] = "Gag (44)"
	SlotMasks[16] = "Collar (45)"
	SlotMasks[17] = "Heavy Bondage/Cloak (46)"
	SlotMasks[18] = "Backpack (47)"
	SlotMasks[19] = "Anal Plug (48)"
	SlotMasks[20] = "Chastity Belt (49)"
	SlotMasks[21] = "Genital Piercing (50)"
	SlotMasks[22] = "Nipple Piercings (51)"
	SlotMasks[23] = "SoS (52)"
	SlotMasks[24] = "Leg Cuffs (53)"

	SlotMasks[26] = "Blindfold (55)"
	SlotMasks[27] = "Chastity Bra (56)"
	SlotMasks[28] = "Vaginal Plug (57)"
	SlotMasks[29] = "Harness/Corset (58)"
	SlotMasks[30] = "Arm Cuffs/Armbinder (59)"

    hiderSetting = new String[3]
    hiderSetting[0] = "No Hide"
    hiderSetting[1] = "Hide When Bound"
    hiderSetting[2] = "Always Hide"
EndFunction

Event OnConfigInit()
	libs.Log("Building configuration menu.")
	SetupPages()
	SetupDifficulties()
	SetupEscapeDifficulties()
	SetupBlindfolds()
	SetupSoundDuration()
	SetupSlotMasks()
	SlotMaskOIDS = new int[128]
EndEvent

Event OnVersionUpdate(Int newVersion)
	libs.Log("OnVersionUpdate("+newVersion+"/"+CurrentVersion+")")
	if newVersion != CurrentVersion
		SlotMaskOIDS = new int[128]
		SetupPages()
		SetupDifficulties()
		SetupEscapeDifficulties()
		SetupBlindfolds()
		SetupSoundDuration()
		eventOIDs = new int[125]
		if !darkfogStrength
			darkfogStrength = 500
		EndIf
	EndIf	
EndEvent

Event OnPageReset(String page)
	If (page == "")
		LoadCustomContent("DeviousIntegrationTitle.dds", 100, 0)
		Return
	Else
		UnloadCustomContent()
	EndIf
	
	If page == "Devices"
		SetCursorFillMode(TOP_TO_BOTTOM)		
		AddHeaderOption("Device Difficulty")
		If LockMenuWhenTied && libs.PlayerRef.WornHasKeyword(libs.zad_Lockable)
			AddTextOptionST("Lock", "This menu is locked while wearing restraints.", "", OPTION_FLAG_DISABLED)
		Else
			AddMenuOptionST("DifficultyModST", "Difficulty Modifier", EsccapeDifficultyList[EscapeDifficulty])
			AddMenuOptionST("CooldownModST", "Cooldown Modifier", EsccapeDifficultyList[CooldownDifficulty])
			AddMenuOptionST("KeyBreakModST", "Keybreak Modifier", EsccapeDifficultyList[KeyDifficulty])
			AddToggleOptionST("ConsumeKeysST", "Consume Keys", GlobalDestroyKey)
			AddToggleOptionST("DisableLockJamST", "Disable Lock Jam", DisableLockJam)
			AddToggleOptionST("LockManipulationST", "Enable Lock Manipulation", UseItemManipulation)
			AddToggleOptionST("LockMenuST", "Lock This Menu When Tied", LockMenuWhentied)
		EndIf

		AddHeaderOption("Sex Options")
		AddToggleOptionST("AnimFilterST", "Use Animation Filter", useAnimFilter)
		AddToggleOptionST("PreserveAggroST", "Preserve Scene Aggressiveness", preserveAggro)

		AddHeaderOption("Arousal Options")
		AddSliderOptionST("ArousalRateMultBeltST", "Belted Arousal Rate Multiplier", beltRateMult, "{1}")
		AddSliderOptionST("ArousalRateMultPlugST", "Plugged Arousal Rate Multiplier", plugRateMult, "{1}")

		AddHeaderOption("Morph Options")
		If libs.PlayerRef.WornHasKeyword(libs.zad_DeviousBra)
			AddToggleOptionST("BreastNodeST", "Breast Node Management", breastNodeManagement, OPTION_FLAG_DISABLED)
		Else
			AddToggleOptionST("BreastNodeST", "Breast Node Management", breastNodeManagement)
		EndIf
		If libs.PlayerRef.WornHasKeyword(libs.zad_DeviousCorset) || libs.PlayerRef.WornHasKeyword(libs.zad_DeviousBelt)
			AddToggleOptionST("BellyNodeST", "Belly Node Management", bellyNodeManagement, OPTION_FLAG_DISABLED)
		Else
			AddToggleOptionST("BellyNodeST", "Belly Node Management", bellyNodeManagement)
		EndIf

		SetCursorPosition(1) 

		AddHeaderOption("Restraint Effects")
		AddToggleOptionST("BoundCombatST", "Enable Bound Combat", UseBoundCombat)
		AddToggleOptionST("BoundCombatPerksST", "Enable Bound Combat Perks", UseBoundCombatPerks)
		AddToggleOptionST("BootsSlowdownST", "Boots Slowdown Effect", bootsSlowdownToggle)
		AddToggleOptionST("HardcoreMittensST", "Hardcore Bondage Mittens", mittensDropToggle)
		AddSliderOptionST("HobbleDressSlowST", "Hobble Dress Slowdown Strength", HobbleSkirtSpeedDebuff, "{0}")
		AddEmptyOption()
		AddMenuOptionST("BlindfoldModeST", "Blindfold Mode", blindfoldList[blindfoldMode])
		If blindfoldMode < 3 ;all except dark fog
			AddSliderOptionST("BlindfoldStrengthST", "Blindfold Effect Strength", blindfoldStrength, "{2}")
			AddSliderOptionST("DarkFogStrengthST", "Dark Fog Effect Strength", darkfogStrength, "{0}", OPTION_FLAG_DISABLED)
		Else
			AddSliderOptionST("BlindfoldStrengthST", "Blindfold Effect Strength", blindfoldStrength, "{2}", OPTION_FLAG_DISABLED)
			AddSliderOptionST("DarkFogStrengthST", "Dark Fog Effect Strength", darkfogStrength, "{0}")
		EndIf

		AddHeaderOption("Sound Options")
		AddSliderOptionST("OrgasmVolST", "Orgasm Volume", VolumeOrgasm, "{3}")
		AddSliderOptionST("EdgedVolST", "Edged Volume", VolumeEdged, "{3}")
		AddSliderOptionST("PlayerVibVolST", "Player Vibrator Volume", VolumeVibrator, "{3}")	
		AddSliderOptionST("NPCVibVolST", "NPC Vibrator Volume", VolumeVibratorNPC, "{3}")	
		AddSliderOptionST("MuffledVolST", "Muffled Volume", VolumeMuffled, "{3}")
		AddSliderOptionST("MuffledNoiseVolST", "Muffle Noise Volume", VolumeMuffleWhiteNoise, "{3}")
		AddMenuOptionST("RubberSoundFreqST", "Rubber Sound Frequency", SoundList[RubberSoundMode])

	ElseIf page == "Contraptions"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Active Struggle Minigame")
		If LockMenuWhenTied && clibs.GetDevice(libs.PlayerRef) != None
			AddTextOptionST("Lock", "This menu is locked while locked into a contraption.", "", OPTION_FLAG_DISABLED)
		Else
			AddToggleOptionST("ShowMinigameTutorialST", "Show Tutorial", ShowMinigameTutorial)
			AddToggleOptionST("ShowMinigameNotificationsST", "Show Notifications", ShowMinigameNotifications)
			AddSliderOptionST("MinigameMinSequenceLengthST", "Actions Needed", MinigameMinSequenceLength, "{0}")
			AddSliderOptionST("MinigameMaxSequenceLengthST", "Max Actions with Escalation", MinigameMaxSequenceLength, "{0}")
			AddSliderOptionST("MinigameMinKeyHoldTimeST", "Minimum Hold Duration", MinigameMinKeyHoldTime, "{1}")
			AddSliderOptionST("MinigameMaxKeyHoldTimeST", "Maximum Hold Duration", MinigameMaxKeyHoldTime, "{1}")
			AddSliderOptionST("MinigameCriticalFailChanceST", "Critical Fail Chance", MinigameCriticalFailChance, "{1}")
			AddSliderOptionST("MinigameEscalationChanceST", "Escalation Chance", MinigameEscalationChance, "{1}")
		EndIf
	ElseIf page == "Events"
		SetCursorFillMode(LEFT_TO_RIGHT)
		AddSliderOptionST("EventIntervalST", "Polling Interval", EventInterval, "{2}")		
		AddSliderOptionST("numNPCsST", "Number of Slotted NPCs", numNpcs, "{1}")
		AddHeaderOption("Polled Events Configuration ("+libs.EventSlots.Slotted+"):")
		AddEmptyOption()
		Int i = 0
		While i < libs.EventSlots.Slotted
			eventOIDs[i] = AddSliderOption(libs.EventSlots.Slots[i].Name+" Chance", libs.EventSlots.Slots[i].Probability, "{1}")
			i += 1
		EndWhile
	ElseIf page == "Device Hider 1"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddMenuOptionST("DeviceHiderST", "Device Hider Slot", SlotMasks[DevicesUnderneathSlot])
		AddMenuOptionST("DeviceHiderNPCST", "Device Hider on NPCs", hiderSetting[libs.DevicesUnderneath.Setting])
		Int i = 1

		While i < 8
			Int index = (i - 1) * 4
			Int j = 0
			AddHeaderOption(SlotMasks[i])
			While j < 4
				slotMaskOIDs[index + j] = AddMenuOption(SlotMasks[i] + " #"+j, SlotMasks[LookupSlotMask(index+j)])
				j += 1
			EndWhile
			i += 1
		EndWhile

		SetCursorPosition(1)

		While i < 16
			Int index = (i - 1) * 4
			Int j = 0
			AddHeaderOption(SlotMasks[i])
			While j < 4
				slotMaskOIDs[index + j] = AddMenuOption(SlotMasks[i] + " #"+j, SlotMasks[LookupSlotMask(index+j)])
				j += 1
			EndWhile
			i += 1
		EndWhile

	ElseIf page == "Device Hider 2"
		SetCursorFillMode(TOP_TO_BOTTOM)
		Int i = 16

		While i < 24
			Int index = (i - 1) * 4
			Int j = 0
			AddHeaderOption(SlotMasks[i])
			While j < 4
				slotMaskOIDs[index + j] = AddMenuOption(SlotMasks[i] + " #"+j, SlotMasks[LookupSlotMask(index+j)])
				j += 1
			EndWhile
			i += 1
		EndWhile

		SetCursorPosition(1)

		While i < 32
			Int index = (i - 1) * 4
			Int j = 0
			AddHeaderOption(SlotMasks[i])
			While j < 4
				slotMaskOIDs[index + j] = AddMenuOption(SlotMasks[i] + " #"+j, SlotMasks[LookupSlotMask(index+j)])
				j += 1
			EndWhile
			i += 1
		EndWhile

	ElseIf page == "Debug"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Messages and Notifications")
		AddToggleOptionST("PlayerMsgST", "Show Player Messages", PlayerMessages)
		AddToggleOptionST("NPCMsgST", "Show NPC Messages", NpcMessages)
		AddToggleOptionST("BlindfoldTooltipST", "Blindfold Tooltips", BlindfoldTooltip)
		AddToggleOptionST("GagTooltipST", "Gag Tooltips", GagTooltip)
		AddToggleOptionST("MuffleTooltipST", "Muffling Tooltips", MuffleTooltip)
		AddHeaderOption("Keybinds")
		AddKeyMapOptionST("FurnKeyST", "Contraption NPC Action Key", FurnitureNPCActionKey)

		SetCursorPosition(1)

		AddHeaderOption("Debug Options")
		AddToggleOptionST("DebugLoggingST", "Enable Debug Logging", LogMessages)
		AddTextOptionST("ExportST", "Export Settings To File", "EXPORT")
		AddTextOptionST("ImportST", "Import Settings From File", "IMPORT")
		AddTextOptionST("RemoveDebugST", "Remove All Devices", "REMOVE")
	Endif
EndEvent

;===========================================================================================CONFIG OPTION STATES===========================================================================================

;----------------------------------------------------------------------------------------------TOGGLE OPTIONS----------------------------------------------------------------------------------------------

State AnimFilterST
	Event OnSelectST()
		useAnimFilter = !useAnimFilter
		SetToggleOptionValueST(useAnimFilter)
	EndEvent
	Event OnDefaultST()
		useAnimFilter = True
		SetToggleOptionValueST(useAnimFilter)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Toggle the use of the animation filter.\nWhen enabled, DD will make sure that only animations compatible with worn devices are played. For example, if an actor is belted, she can't have vaginal sex.\nWhen disabled, devices conflicting with the selected animation will be unequipped for the duration of the sex scene.")
	EndEvent
EndState

State BellyNodeST
	Event OnSelectST()
		bellyNodeManagement = !bellyNodeManagement
		SetToggleOptionValueST(bellyNodeManagement)
	EndEvent
	Event OnDefaultST()
		bellyNodeManagement = False
		SetToggleOptionValueST(bellyNodeManagement)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, actors' belly will be resized to minimal when a chastity belt or corset is worn, to minimize physics clipping.")
	EndEvent
EndState

State BlindfoldTooltipST
	Event OnSelectST()
		BlindfoldTooltip = !BlindfoldTooltip
		SetToggleOptionValueST(BlindfoldTooltip)
	EndEvent
	Event OnDefaultST()
		BlindfoldTooltip = True
		SetToggleOptionValueST(BlindfoldTooltip)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, a message explaining blindfold effects will be shown upon equipping a blindfold.")
	EndEvent
EndState

State BootsSlowdownST
	Event OnSelectST()
		bootsSlowdownToggle = !bootsSlowdownToggle
		SetToggleOptionValueST(bootsSlowdownToggle)
	EndEvent
	Event OnDefaultST()
		bootsSlowdownToggle = True
		SetToggleOptionValueST(bootsSlowdownToggle)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Toggle the slowdown effect caused by some devious boots.")
	EndEvent
EndState

State BoundCombatST
	Event OnSelectST()
		UseBoundCombat = !UseBoundCombat
		SetToggleOptionValueST(UseBoundCombat)
	EndEvent
	Event OnDefaultST()
		UseBoundCombat = True
		SetToggleOptionValueST(UseBoundCombat)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, unarmed combat (kicking) will be enabled for the player while having bound wrists. Works in 3rd person only.")
	EndEvent
EndState

State BoundCombatPerksST
	Event OnSelectST()
		UseBoundCombatPerks = !UseBoundCombatPerks
		SetToggleOptionValueST(UseBoundCombatPerks)
	EndEvent
	Event OnDefaultST()
		UseBoundCombatPerks = True
		SetToggleOptionValueST(UseBoundCombatPerks)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, the strength of bound melee attacks will be influenced by which devices the player has been are wearing, and for how long.")
	EndEvent
EndState

State BreastNodeST
	Event OnSelectST()
		breastNodeManagement = !breastNodeManagement
		SetToggleOptionValueST(breastNodeManagement)
	EndEvent
	Event OnDefaultST()
		breastNodeManagement = False
		SetToggleOptionValueST(breastNodeManagement)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, actors' breasts will be resized to minimal when a chastity bra is worn, to minimize physics clipping.")
	EndEvent
EndState

State ConsumeKeysST
	Event OnSelectST()
		GlobalDestroyKey = !GlobalDestroyKey
		SetToggleOptionValueST(GlobalDestroyKey)
	EndEvent
	Event OnDefaultST()
		GlobalDestroyKey = True
		SetToggleOptionValueST(GlobalDestroyKey)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, keys can be used to unlock only one device, and will be consumed on use.\nThis feature will not affect custom keys, unless set by the mod author.")
	EndEvent
EndState

State DebugLoggingST
	Event OnSelectST()
		LogMessages = !LogMessages
		SetToggleOptionValueST(LogMessages)
	EndEvent
	Event OnDefaultST()
		LogMessages = False
		SetToggleOptionValueST(LogMessages)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Toggle DD debug logging in the Papyrus.0.log file. You don't need to enable this if everything is working properly.")
	EndEvent
EndState

State DisableLockJamST
	Event OnSelectST()
		DisableLockJam = !DisableLockJam
		SetToggleOptionValueST(DisableLockJam)
	EndEvent
	Event OnDefaultST()
		DisableLockJam = False
		SetToggleOptionValueST(DisableLockJam)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, device locks cannot jam when a restraint key breaks.")
	EndEvent
EndState

State GagTooltipST
	Event OnSelectST()
		GagTooltip = !GagTooltip
		SetToggleOptionValueST(GagTooltip)
	EndEvent
	Event OnDefaultST()
		GagTooltip = True
		SetToggleOptionValueST(GagTooltip)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, a message explaining gag effects will be shown upon equipping a gag.")
	EndEvent
EndState

State HardcoreMittensST
	Event OnSelectST()
		mittensDropToggle = !mittensDropToggle
		SetToggleOptionValueST(mittensDropToggle)
	EndEvent
	Event OnDefaultST()
		mittensDropToggle = False
		SetToggleOptionValueST(mittensDropToggle)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, picking up items while wearing bondage mittens will become more difficult.\nThe items will drop to the ground and you can try to pick them up again.")
	EndEvent
EndState

State LockManipulationST
	Event OnSelectST()
		UseItemManipulation = !UseItemManipulation
		SetToggleOptionValueST(UseItemManipulation)
	EndEvent
	Event OnDefaultST()
		UseItemManipulation = False
		SetToggleOptionValueST(UseItemManipulation)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, the player can manipulate the locks of devices they equip voluntarily.\nThis will allow unequipping them without a key or passing a check.")
	EndEvent
EndState

State LockMenuST
	Event OnSelectST()
		LockMenuWhentied = !LockMenuWhentied
		SetToggleOptionValueST(LockMenuWhentied)
	EndEvent
	Event OnDefaultST()
		LockMenuWhentied = False
		SetToggleOptionValueST(LockMenuWhentied)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, prevents access to the device difficulty settings when the player is restrained.\nThis is for players who want a more hardcore experience.")
	EndEvent
EndState

State MuffleTooltipST
	Event OnSelectST()
		MuffleTooltip = !MuffleTooltip
		SetToggleOptionValueST(MuffleTooltip)
	EndEvent
	Event OnDefaultST()
		MuffleTooltip = True
		SetToggleOptionValueST(MuffleTooltip)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabled, a message explaining muffling effects will be shown upon equipping a muffling device.")
	EndEvent
EndState

State NPCMsgST
	Event OnSelectST()
		NpcMessages = !NpcMessages
		SetToggleOptionValueST(NpcMessages)
	EndEvent
	Event OnDefaultST()
		NpcMessages = True
		SetToggleOptionValueST(NpcMessages)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Toggles device-related messages for NPCs.")
	EndEvent
EndState

State PlayerMsgST
	Event OnSelectST()
		PlayerMessages = !PlayerMessages
		SetToggleOptionValueST(PlayerMessages)
	EndEvent
	Event OnDefaultST()
		PlayerMessages = True
		SetToggleOptionValueST(PlayerMessages)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Toggles device-related messages for the player.\nMessages crucial to device functionality will display regardless of this setting. The creators of this mod recommend that you leave this option enabled, unless you really cannot stand the writing.")
	EndEvent
EndState

State PreserveAggroST
	Event OnSelectST()
		preserveAggro = !preserveAggro
		SetToggleOptionValueST(preserveAggro)
	EndEvent
	Event OnDefaultST()
		preserveAggro = True
		SetToggleOptionValueST(preserveAggro)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Toggle the preservation of a sex scene's aggressiveness. Disable this for more variety in animations, at the cost of a chance of seeing consensual animations in rape scenes.")
	EndEvent
EndState

State ShowMinigameTutorialST
	Event OnSelectST()
		ShowMinigameTutorial = !ShowMinigameTutorial
		SetToggleOptionValueST(ShowMinigameTutorial)
	EndEvent
	Event OnDefaultST()
		ShowMinigameTutorial = True
		SetToggleOptionValueST(ShowMinigameTutorial)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Whether or not tutorial messages are shown at the start of the contraption struggle escape minigame.")
	EndEvent
EndState

State ShowMinigameNotificationsST
	Event OnSelectST()
		ShowMinigameNotifications = !ShowMinigameNotifications
		SetToggleOptionValueST(ShowMinigameNotifications)
	EndEvent
	Event OnDefaultST()
		ShowMinigameNotifications = True
		SetToggleOptionValueST(ShowMinigameNotifications)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Whether or not notification messages are shown for minigame events. Turn off for maximum immersion.")
	EndEvent
EndState

;----------------------------------------------------------------------------------------------SLIDER OPTIONS----------------------------------------------------------------------------------------------

State ArousalRateMultBeltST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(beltRateMult)
		SetSliderDialogDefaultValue(1.5)
		SetSliderDialogRange(1.0, 5.0)
		SetSliderDialogInterval(0.1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		beltRateMult = value
		SetSliderOptionValueST(beltRateMult, "{1}")
	EndEvent
	Event OnDefaultST()
		beltRateMult = 1.5
		SetSliderOptionValueST(beltRateMult, "{1}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the arousal exposure multiplier for actors wearing chastity belts.")
	EndEvent
EndState

State ArousalRateMultPlugST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(plugRateMult)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(1.0, 5.0)
		SetSliderDialogInterval(0.1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		plugRateMult = value
		SetSliderOptionValueST(plugRateMult, "{1}")
	EndEvent
	Event OnDefaultST()
		plugRateMult = 3.0
		SetSliderOptionValueST(plugRateMult, "{1}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the arousal exposure multiplier for plugged actors.")
	EndEvent
EndState

State BlindfoldStrengthST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(blindfoldStrength)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		blindfoldStrength = value
		SetSliderOptionValueST(blindfoldStrength, "{2}")
		SendModEvent("zadBlindfoldEffectUpdate")
	EndEvent
	Event OnDefaultST()
		blindfoldStrength = 0.5
		SetSliderOptionValueST(blindfoldStrength, "{2}")
		SendModEvent("zadBlindfoldEffectUpdate")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the strength of the blindfold's vision-limiting effect.")
	EndEvent
EndState

State DarkFogStrengthST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(darkfogStrength)
		SetSliderDialogDefaultValue(500.0)
		SetSliderDialogRange(50.0, 3000.0)
		SetSliderDialogInterval(50.0)
	EndEvent
	Event OnSliderAcceptST(Float value)
		darkfogStrength = value as Int
		SetSliderOptionValueST(darkfogStrength, "{0}")
		SendModEvent("zadBlindfoldEffectUpdate")
	EndEvent
	Event OnDefaultST()
		darkfogStrength = 500 as Int
		SetSliderOptionValueST(darkfogStrength, "{0}")
		SendModEvent("zadBlindfoldEffectUpdate")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the strength of the dark fog effect, if it's selected as the vision-limiting effect of the blindfold.")
	EndEvent
EndState

State EdgedVolST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(VolumeEdged)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 1.0)
		SetSliderDialogInterval(0.01)
	EndEvent
	Event OnSliderAcceptST(Float value)
		VolumeEdged = value
		SetSliderOptionValueST(VolumeEdged, "{3}")
	EndEvent
	Event OnDefaultST()
		VolumeEdged = 1.0
		SetSliderOptionValueST(VolumeEdged, "{3}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how loud an actor's moans are after they've been edged.")
	EndEvent
EndState

State EventIntervalST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(EventInterval)
		SetSliderDialogDefaultValue(1.5)
		SetSliderDialogRange(0.5, 12.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	Event OnSliderAcceptST(Float value)
		EventInterval = value
		SetSliderOptionValueST(EventInterval, "{2}")
	EndEvent
	Event OnDefaultST()
		EventInterval = 1.5
		SetSliderOptionValueST(EventInterval, "{2}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the frequency of polling device events, measured in game hours. The lower this value, the more frequent all periodic events/effects are.")
	EndEvent
EndState

State HobbleDressSlowST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(HobbleSkirtSpeedDebuff)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(25.0, 70.0)
		SetSliderDialogInterval(1.0)
	EndEvent
	Event OnSliderAcceptST(Float value)
		HobbleSkirtSpeedDebuff = value as Int
		SetSliderOptionValueST(HobbleSkirtSpeedDebuff, "{0}")
	EndEvent
	Event OnDefaultST()
		HobbleSkirtSpeedDebuff = 50
		SetSliderOptionValueST(HobbleSkirtSpeedDebuff, "{0}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the strength of the movement speed debuff caused by wearing a hobble dress.\nThe higher the number, the slower actors wearing it can walk.\nThe animations are meant for the default value and will look off at lower values.")
	EndEvent
EndState

State MuffledVolST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(VolumeMuffled)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 1.0)
		SetSliderDialogInterval(0.01)
	EndEvent
	Event OnSliderAcceptST(Float value)
		VolumeMuffled = value
		SetSliderOptionValueST(VolumeMuffled, "{3}")
		SendModEvent("zadMuffleEffectUpdate")
	EndEvent
	Event OnDefaultST()
		VolumeMuffled = 1.0
		SetSliderOptionValueST(VolumeMuffled, "{3}")
		SendModEvent("zadMuffleEffectUpdate")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how much sound is muffled while wearing hoods or other sound muffling devices.")
	EndEvent
EndState

State MuffledNoiseVolST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(VolumeMuffleWhiteNoise)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 1.0)
		SetSliderDialogInterval(0.01)
	EndEvent
	Event OnSliderAcceptST(Float value)
		VolumeMuffleWhiteNoise = value
		SetSliderOptionValueST(VolumeMuffleWhiteNoise, "{3}")
		SendModEvent("zadMuffleEffectUpdate")
	EndEvent
	Event OnDefaultST()
		VolumeMuffleWhiteNoise = 1.0
		SetSliderOptionValueST(VolumeMuffleWhiteNoise, "{3}")
		SendModEvent("zadMuffleEffectUpdate")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how loud the white noise sound is while wearing hoods or other sound muffling devices.")
	EndEvent
EndState

State NPCVibVolST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(VolumeVibratorNPC)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0.1, 1.0)
		SetSliderDialogInterval(0.01)
	EndEvent
	Event OnSliderAcceptST(Float value)
		VolumeVibratorNPC = value
		SetSliderOptionValueST(VolumeVibratorNPC, "{3}")
	EndEvent
	Event OnDefaultST()
		VolumeVibratorNPC = 0.25
		SetSliderOptionValueST(VolumeVibratorNPC, "{3}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how loud the vibrators equipped on NPCs are.\nStronger vibrators are inherently louder than the weaker ones.")
	EndEvent
EndState

State numNPCsST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(numNpcs)
		SetSliderDialogDefaultValue(1.5)
		SetSliderDialogRange(5.0, 20.0)
		SetSliderDialogInterval(1.0)
	EndEvent
	Event OnSliderAcceptST(Float value)
		numNpcs = value as Int
		SetSliderOptionValueST(numNpcs, "{1}")
	EndEvent
	Event OnDefaultST()
		numNpcs = 15
		SetSliderOptionValueST(numNpcs, "{1}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the number of NPCs (per area) to be processed by DD's bondage features (like vibration effects).")
	EndEvent
EndState

State OrgasmVolST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(VolumeOrgasm)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 1.0)
		SetSliderDialogInterval(0.01)
	EndEvent
	Event OnSliderAcceptST(Float value)
		VolumeOrgasm = value
		SetSliderOptionValueST(VolumeOrgasm, "{3}")
	EndEvent
	Event OnDefaultST()
		VolumeOrgasm = 1.0
		SetSliderOptionValueST(VolumeOrgasm, "{3}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how loud an actor's moans are during orgasms.")
	EndEvent
EndState

State PlayerVibVolST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(VolumeVibrator)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.1, 1.0)
		SetSliderDialogInterval(0.01)
	EndEvent
	Event OnSliderAcceptST(Float value)
		VolumeVibrator = value
		SetSliderOptionValueST(VolumeVibrator, "{3}")
	EndEvent
	Event OnDefaultST()
		VolumeVibrator = 0.5
		SetSliderOptionValueST(VolumeVibrator, "{3}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how loud the player's vibrators are.\nStronger vibrators are inherently louder than the weaker ones.")
	EndEvent
EndState

State MinigameMinSequenceLengthST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(MinigameMinSequenceLength)
		SetSliderDialogDefaultValue(3)
		SetSliderDialogRange(1, 16)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		MinigameMinSequenceLength = value as int
		If MinigameMaxSequenceLength < MinigameMinSequenceLength
			MinigameMaxSequenceLength = MinigameMinSequenceLength
			SetSliderOptionValueST(MinigameMaxSequenceLength, "{0}", a_stateName = "MinigameMaxSequenceLengthST")
		EndIf
		SetSliderOptionValueST(MinigameMinSequenceLength, "{0}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnDefaultST()
		MinigameMinSequenceLength = 3
		SetSliderOptionValueST(MinigameMinSequenceLength, "{0}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnHighlightST()
		SetInfoText("How many key holds in a row the player needs to guess to escape. This is the starting length, escalation can extend the sequence.")
	EndEvent
EndState

State MinigameMaxSequenceLengthST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(MinigameMaxSequenceLength)
		SetSliderDialogDefaultValue(9)
		SetSliderDialogRange(1, 16) ; (Don't set the max of the range larger than the array size in the minigame script!)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		MinigameMaxSequenceLength = value as int
		If MinigameMaxSequenceLength < MinigameMinSequenceLength
			MinigameMaxSequenceLength = MinigameMinSequenceLength
		EndIf
		SetSliderOptionValueST(MinigameMaxSequenceLength, "{0}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnDefaultST()
		MinigameMaxSequenceLength = 9
		SetSliderOptionValueST(MinigameMaxSequenceLength, "{0}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnHighlightST()
		SetInfoText("Maximum number of key holds in a row the player will ever need to guess to escape.\nIf escalation is enabled, this value determines how long the sequence can get.")
	EndEvent
EndState

State MinigameMinKeyHoldTimeST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(MinigameMinKeyHoldTime)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.5, 20)
		SetSliderDialogInterval(0.1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		MinigameMinKeyHoldTime = value
		If MinigameMaxKeyHoldTime < MinigameMinKeyHoldTime 
			MinigameMaxKeyHoldTime = MinigameMinKeyHoldTime
			SetSliderOptionValueST(MinigameMaxKeyHoldTime, "{1}", a_stateName = "MinigameMaxKeyHoldTimeST")
		EndIf
		SetSliderOptionValueST(MinigameMinKeyHoldTime, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnDefaultST()
		MinigameMinKeyHoldTime = 0.5
		SetSliderOptionValueST(MinigameMinKeyHoldTime, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnHighlightST()
		SetInfoText("Minimum number of seconds any key in the sequence has to be pressed.")
	EndEvent
EndState

State MinigameMaxKeyHoldTimeST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(MinigameMaxKeyHoldTime)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.5, 20)
		SetSliderDialogInterval(0.1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		MinigameMaxKeyHoldTime = value
		If MinigameMaxKeyHoldTime < MinigameMinKeyHoldTime 
			MinigameMaxKeyHoldTime = MinigameMinKeyHoldTime
		EndIf
		SetSliderOptionValueST(MinigameMaxKeyHoldTime, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnDefaultST()
		MinigameMaxKeyHoldTime = 1.0
		SetSliderOptionValueST(MinigameMaxKeyHoldTime, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnHighlightST()
		SetInfoText("Maximum number of seconds any key in the sequence has to be pressed.")
	EndEvent
EndState

State MinigameCriticalFailChanceST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(MinigameCriticalFailChance)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		MinigameCriticalFailChance = value
		SetSliderOptionValueST(MinigameCriticalFailChance, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnDefaultST()
		MinigameCriticalFailChance = 10.0
		SetSliderOptionValueST(MinigameCriticalFailChance, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnHighlightST()
		SetInfoText("Percentage chance that holding the wrong key will completely reset the sequence and generate a new one.")
	EndEvent
EndState

State MinigameEscalationChanceST
	Event OnSliderOpenST()
		SetSliderDialogStartValue(MinigameEscalationChance)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	EndEvent
	Event OnSliderAcceptST(Float value)
		MinigameEscalationChance = value
		SetSliderOptionValueST(MinigameEscalationChance, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnDefaultST()
		MinigameEscalationChance = 10.0
		SetSliderOptionValueST(MinigameEscalationChance, "{1}")
		ScheduleMinigameOptionsUpdate = True
	EndEvent
	Event OnHighlightST()
		SetInfoText("Percentage chance that on a critical fail, one more key has to be guessed in the next attempt.")
	EndEvent
EndState

;-----------------------------------------------------------------------------------------------MENU OPTIONS-----------------------------------------------------------------------------------------------

State BlindfoldModeST
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(blindfoldMode)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(blindfoldList)
	EndEvent
	Event OnMenuAcceptST(Int index)
		If blindfoldMode == 3 && index != 3 ;Old mode was Dark Fog, remove it
			If Weather.GetSkyMode() == 0
				zadNativeFunctions.ExecuteConsoleCmd("ts")
			EndIf
			zadNativeFunctions.ExecuteConsoleCmd("setfog 0 0")
		EndIf
		blindfoldMode = index
		SetMenuOptionValueST(blindfoldList[index])
		ForcePageReset()
		libs.UpdateControls()
		SendModEvent("zadBlindfoldEffectUpdate")
	EndEvent
	Event OnDefaultST()
		If blindfoldMode == 3 ;Old mode was Dark Fog, remove it
			If Weather.GetSkyMode() == 0
				zadNativeFunctions.ExecuteConsoleCmd("ts")
			EndIf
			zadNativeFunctions.ExecuteConsoleCmd("setfog 0 0")
		EndIf
		blindfoldMode = 2
		SetMenuOptionValueST(blindfoldList[2])
		ForcePageReset()
		libs.UpdateControls()
		SendModEvent("zadBlindfoldEffectUpdate")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Switch between the provided blindfold modes.\nDD's mode is intended for 1st person play. In 1st person, the player is be able to move freely, and one of two effects will be applied to your screen. While in 3rd person, the player is unable to move, but you are able to see clearly. \nLeeche's mode applies a DOF-based blindfold effect, and is intended for 3rd person play.\nDark fog mode makes only a small radius around the player visible.")
	EndEvent
EndState

State CooldownModST
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(CooldownDifficulty)
		SetMenuDialogDefaultIndex(4)
		SetMenuDialogOptions(EsccapeDifficultyList)
	EndEvent
	Event OnMenuAcceptST(Int index)
		CooldownDifficulty = index
		SetMenuOptionValueST(EsccapeDifficultyList[index])
	EndEvent
	Event OnDefaultST()
		CooldownDifficulty = 4
		SetMenuOptionValueST(EsccapeDifficultyList[4])
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the modifier applied to device escape cooldowns (unlock, struggle, repair lock).\nIt applies to standard/generic devices and will not affect quest devices unless their creator enabled it.\nThe default modifier is zero.")
	EndEvent
EndState

State DeviceHiderST
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(DevicesUnderneathSlot)
		SetMenuDialogDefaultIndex(12)
		SetMenuDialogOptions(SlotMasks)
	EndEvent
	Event OnMenuAcceptST(Int index)
		DevicesUnderneathSlot = index
		SetMenuOptionValueST(SlotMasks[index])
	EndEvent
	Event OnDefaultST()
		DevicesUnderneathSlot = 12
		SetMenuOptionValueST(SlotMasks[12])
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set which equip slot the Device Hider uses. It doesn't matter what slot is set, though a slot must be set. If you set this to the same slot as one being used by a device, bad things will happen. Don't touch this unless you know what you're doing!")
	EndEvent
EndState

State DeviceHiderNPCST
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(libs.DevicesUnderneath.Setting)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(hiderSetting)
	EndEvent
	Event OnMenuAcceptST(Int index)
		libs.DevicesUnderneath.Setting = index
		SetMenuOptionValueST(hiderSetting[index])
		libs.DevicesUnderneath.SyncSetting()
	EndEvent
	Event OnDefaultST()
		libs.DevicesUnderneath.Setting = 1
		SetMenuOptionValueST(hiderSetting[1])
		libs.DevicesUnderneath.SyncSetting()
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how the Device Hider should handle non-Devious Device items on NPCs.")
	EndEvent
EndState

State DifficultyModST
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(EscapeDifficulty)
		SetMenuDialogDefaultIndex(4)
		SetMenuDialogOptions(EsccapeDifficultyList)
	EndEvent
	Event OnMenuAcceptST(Int index)
		EscapeDifficulty = index
		SetMenuOptionValueST(EsccapeDifficultyList[index])
	EndEvent
	Event OnDefaultST()
		EscapeDifficulty = 4
		SetMenuOptionValueST(EsccapeDifficultyList[4])
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the modifier applied to device escape difficulty chances (struggle and lockpick).\nIt applies to standard/generic devices and will not affect quest devices unless their creator enabled it.\nThe default modifier is zero.")
	EndEvent
EndState

State KeyBreakModST
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(KeyDifficulty)
		SetMenuDialogDefaultIndex(4)
		SetMenuDialogOptions(EsccapeDifficultyList)
	EndEvent
	Event OnMenuAcceptST(Int index)
		KeyDifficulty = index
		SetMenuOptionValueST(EsccapeDifficultyList[index])
	EndEvent
	Event OnDefaultST()
		KeyDifficulty = 4
		SetMenuOptionValueST(EsccapeDifficultyList[4])
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the modifier applied to restraint key break and lock jam chances.\nIt applies to standard/generic devices and will not affect quest devices unless their creator enabled it.\nThe default modifier is zero.")
	EndEvent
EndState

State RubberSoundFreqST
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(RubberSoundMode)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(SoundList)
	EndEvent
	Event OnMenuAcceptST(Int index)
		RubberSoundMode = index
		SetMenuOptionValueST(SoundList[index])
	EndEvent
	Event OnDefaultST()
		RubberSoundMode = 1
		SetMenuOptionValueST(SoundList[1])
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set how often rubber sounds are played when wearing ebonite restraints.")
	EndEvent
EndState

;----------------------------------------------------------------------------------------------KEYMAP OPTIONS----------------------------------------------------------------------------------------------

State FurnKeyST
	Event OnKeyMapChangeST(Int a_keyCode, String a_conflictControl, String a_conflictName)
		Bool Continue = True
		If (a_keyCode == 1)
			a_keyCode = 0
			a_conflictControl = ""
		Endif
		If (a_conflictControl != "")
			String msg
			If a_conflictName != ""
				msg = "This key is already mapped to:\n'" + a_conflictControl + "'\n(" + a_conflictName + ")\n\nAre you sure you want to continue?"
			Else
				msg = "This key is already mapped to:\n'" + a_conflictControl + "'\n\nAre you sure you want to continue?"
			Endif
			Continue = ShowMessage(msg, True, "$Yes", "$No")
		Endif		
		If Continue
			FurnitureNPCActionKey = a_keyCode
			SetKeymapOptionValueST(a_keyCode, False, "FurnKeyST")
			SendModEvent("zad_RegisteredMCMKeys")
		Endif
	EndEvent
	Event OnDefaultST()
		FurnitureNPCActionKey = 0xC9
		SetKeymapOptionValueST(0xC9, False, "FurnKeyST")
		SendModEvent("zad_RegisteredMCMKeys")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Set the keybind for DD Contraptions NPC interaction.")
	EndEvent
EndState

;-----------------------------------------------------------------------------------------------TEXT OPTIONS-----------------------------------------------------------------------------------------------

State ExportST
	Event OnSelectST()
		ExportSettings()
		ForcePageReset()
	EndEvent
	Event OnHighlightST()
		SetInfoText("Save mod settings to a configuration file.")
	EndEvent
EndState

State ImportST
	Event OnSelectST()
		ImportSettings()
		ForcePageReset()
	EndEvent
	Event OnHighlightST()
		SetInfoText("Load mod settings from a configuration file.")
	EndEvent
EndState

State RemoveDebugST
	Event OnSelectST()
		If ShowMessage("WARNING:\nThis function will try to remove all DD items. Wiping quest items may result in broken quest states! This feature is intended to be used for debug purposes and as a last resort only! Using it to escape DD restraints is strongly discouraged.\n\nAre you sure?")
			debugSigTerm = True
			libs.UnregisterForUpdate()
			libs.RegisterForSingleUpdate(1)	
			SetTextOptionValueST("Done. Exit config menu!")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("Remove all equipped DD items.\nUsing this function may result in unrecoverable, broken quest states! DO NOT use this function to escape inconvenient restraints!")
	EndEvent
EndState

;===============================================================================================OID HANDLERS===============================================================================================

Event OnOptionMenuOpen(Int option)
	Int i = 0
	While i < 128
		If option == slotMaskOIDs[i]
			SetMenuDialogOptions(SlotMasks)
			SetMenuDialogStartIndex(LookupSlotMask(i))
			SetMenuDialogDefaultIndex(0)
		EndIf
		i += 1
	EndWhile
EndEvent

Event OnOptionMenuAccept(int option, int index)
	Int i = 0
	While i < 128
		If option == slotMaskOIDs[i]
			Int value = 0
			value = Math.LeftShift(1, (index - 1))
			libs.Log("Index:" + index + " = " + value + "/" + SlotMaskValues.find(value))
            libs.DevicesUnderneath.Validate()
			libs.DevicesUnderneath.SlotMaskFilters[i] = value
			SetMenuOptionValue(option, SlotMasks[index])
            libs.DevicesUnderneath.SyncSetting()
		EndIf
		i += 1
	EndWhile
EndEvent

Event OnOptionSliderOpen(Int option)
	Int i = 0;
	While i < libs.EventSlots.Slotted
		if option == eventOIDs[i]
			SetSliderDialogStartValue(libs.EventSlots.Slots[i].Probability)
			SetSliderDialogDefaultValue(libs.EventSlots.Slots[i].DefaultProbability)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1)			
			Return
		EndIf
		i+= 1
	EndWhile
EndEvent

Event OnOptionDefault(int option)
	Int i = 0
	While i < libs.EventSlots.Slotted
		If option == eventOIDs[i]
			libs.EventSlots.Slots[i].Probability = libs.EventSlots.Slots[i].DefaultProbability
			SetSliderOptionValue(eventOIDs[i], libs.EventSlots.Slots[i].DefaultProbability, "{1}")
			Return
		EndIf
		i+= 1
	EndWhile
EndEvent

Event OnOptionHighlight(int option)
	Int i = 0
	While i < libs.EventSlots.Slotted
		If option == eventOIDs[i]
			String help = libs.EventSlots.Slots[i].help
			If help == ""
				help = "Set the chance for a(n) "+libs.EventSlots.Slots[i].Name +" event to occur."
			EndIf
			SetInfoText(help)
			Return
		EndIf
		i+= 1
	EndWhile	
EndEvent

Event OnOptionSliderAccept(int option, float value)
	Int i = 0
	While i < libs.EventSlots.Slotted
		If option == eventOIDs[i]
			libs.EventSlots.Slots[i].Probability = value as int
			SetSliderOptionValue(option, value, "{1}")
			Return
		EndIf
		i+= 1
	EndWhile
EndEvent

;===============================================================================================IMPORT/EXPORT==============================================================================================

Int Function LookupSlotMask(int i)
    libs.DevicesUnderneath.Validate()
	Int value = (libs.DevicesUnderneath.SlotMaskFilters[i])
	If value == 0
		Return 0
	Else
		Return SlotMaskValues.Find(value)
	EndIf
EndFunction

Function ExportInt(string Name, int Value)
	JsonUtil.SetIntValue(File, Name, Value)
EndFunction

Int Function ImportInt(string Name, int Value)
	Return JsonUtil.GetIntValue(File, Name, Value)
EndFunction

Function ExportBool(string Name, bool Value)
	JsonUtil.SetIntValue(File, Name, Value as int)
EndFunction

Bool function ImportBool(string Name, bool Value)
	Return JsonUtil.GetIntValue(File, Name, Value as int) as bool
EndFunction

Function ExportFloat(string Name, float Value)
	JsonUtil.SetFloatValue(File, Name, Value)
EndFunction

Float Function ImportFloat(string Name, float Value)
	Return JsonUtil.GetFloatValue(File, Name, Value)
EndFunction

Function ExportDevicesUnderneath()
	Int i = 0
	While i < 128
		ExportInt("DevicesUnderneathSlot" + i, libs.DevicesUnderneath.SlotMaskFilters[i])
		i += 1
	EndWhile
EndFunction

Function ImportDevicesUnderneath()
	Int i = 0
	While i < 128
		libs.DevicesUnderneath.SlotMaskFilters[i]=ImportInt("DevicesUnderneathSlot" + i, libs.DevicesUnderneath.SlotMaskFilters[i])
		i += 1
	EndWhile
	libs.DevicesUnderneath.RebuildSlotmask(libs.PlayerRef)
EndFunction
	
Function ExportEvents()
	Int i = 0
	while i < libs.EventSlots.Slotted
		ExportInt("Event"+libs.EventSlots.Slots[i].Name+"Chance", libs.EventSlots.Slots[i].Probability)
		i += 1
	EndWhile
EndFunction

Function ImportEvents()
	Int i = 0
	While i < libs.EventSlots.Slotted
		libs.EventSlots.Slots[i].Probability = ImportInt("Event" + libs.EventSlots.Slots[i]. Name+"Chance", libs.EventSlots.Slots[i].Probability)
		i += 1
	EndWhile
EndFunction

Function ExportSettings()
	JsonUtil.SetStringValue(File, "ExportLabel", Game.GetPlayer().GetLeveledActorBase().GetName()+" - "+Utility.GetCurrentRealTime() as int)
	JsonUtil.SetIntValue(File, "Version", GetVersion())
	ExportDevicesUnderneath()
	ExportEvents()

	;EXPORT INT
	ExportInt("blindfoldMode", blindfoldMode)
	ExportInt("CooldownDifficulty", CooldownDifficulty)
	ExportInt("darkfogStrength", darkfogStrength)
	ExportInt("DevicesUnderneathSlot", DevicesUnderneathSlot)
	ExportInt("EscapeDifficulty", EscapeDifficulty)
	ExportInt("FurnitureNPCActionKey", FurnitureNPCActionKey)
	ExportInt("HobbleSkirtSpeedDebuff", HobbleSkirtSpeedDebuff)
	ExportInt("KeyDifficulty", KeyDifficulty)
	ExportInt("numNpcs", numNpcs)
	ExportInt("RubberSoundMode", RubberSoundMode)
	ExportInt("MinigameMinSequenceLength", MinigameMinSequenceLength)
	ExportInt("MinigameMaxSequenceLength", MinigameMaxSequenceLength)

	;EXPORT BOOL
	ExportBool("bellyNodeManagement", bellyNodeManagement)
	ExportBool("BlindfoldTooltip", BlindfoldTooltip)
	ExportBool("bootsSlowdownToggle", bootsSlowdownToggle)
	ExportBool("breastNodeManagement", breastNodeManagement)
	ExportBool("DisableLockJam", DisableLockJam)
	ExportBool("GagTooltip", GagTooltip)
	ExportBool("GlobalDestroyKey", GlobalDestroyKey)
	ExportBool("LockMenuWhenTied", LockMenuWhenTied)
	ExportBool("LogMessages", LogMessages)
	ExportBool("mittensDropToggle", mittensDropToggle)
	ExportBool("MuffleTooltip", MuffleTooltip)
	ExportBool("NpcMessages", NpcMessages)
	ExportBool("PlayerMessages", PlayerMessages)
	ExportBool("preserveAggro", preserveAggro)
	ExportBool("useAnimFilter", useAnimFilter)
	ExportBool("UseBoundCombat", UseBoundCombat)
	ExportBool("UseBoundCombatPerks", UseBoundCombatPerks)
	ExportBool("UseItemManipulation", UseItemManipulation)
	ExportBool("ShowMinigameTutorial", ShowMinigameTutorial)
	ExportBool("ShowMinigameNotifications", ShowMinigameNotifications)

	;EXPORT FLOAT
	ExportFloat("BeltRateMult", BeltRateMult)
	ExportFloat("blindfoldStrength", blindfoldStrength)
	ExportFloat("EventInterval", EventInterval)
	ExportFloat("PlugRateMult", PlugRateMult)
	ExportFloat("VolumeEdged", VolumeEdged)
	ExportFloat("volumeMuffled", volumeMuffled)
	ExportFloat("volumeMuffleWhiteNoise", volumeMuffleWhiteNoise)
	ExportFloat("VolumeOrgasm", VolumeOrgasm)
	ExportFloat("VolumeVibrator", VolumeVibrator)
	ExportFloat("VolumeVibratorNPC", VolumeVibratorNPC)
	ExportFloat("MinigameMinKeyHoldTime", MinigameMinKeyHoldTime)
	ExportFloat("MinigameMaxKeyHoldTime", MinigameMaxKeyHoldTime)
	ExportFloat("MinigameCriticalFailChance", MinigameCriticalFailChance)
	ExportFloat("MinigameEscalationChance", MinigameEscalationChance)

	JsonUtil.Save(File, False)
EndFunction

function ImportSettings()
	Int version = 0
	If JsonUtil.GetIntValue(File, "Version", version) != GetVersion()
		If !ShowMessage("Saved config is for another version of DD, aborting.")
			Return
		Endif
	EndIf

	ImportDevicesUnderneath()
	ImportEvents()

	;IMPORT INT
	Int oldBlindfoldMode = BlindfoldMode
	blindfoldMode = ImportInt("blindfoldMode", blindfoldMode)
	If oldBlindfoldMode == 3 && BlindfoldMode != 3 ; Old mode was Dark Fog, remove it
		If Weather.GetSkyMode() == 0
			zadNativeFunctions.ExecuteConsoleCmd("ts")
		Endif
		zadNativeFunctions.ExecuteConsoleCmd("setfog 0 0") 
	EndIf
	libs.UpdateControls()
	SendModEvent("zadBlindfoldEffectUpdate")
	
	CooldownDifficulty = ImportInt("CooldownDifficulty", CooldownDifficulty)
	darkfogStrength = ImportInt("darkfogStrength", darkfogStrength)
	DevicesUnderneathSlot = ImportInt("DevicesUnderneathSlot", DevicesUnderneathSlot)
	EscapeDifficulty = ImportInt("EscapeDifficulty", EscapeDifficulty)
	FurnitureNPCActionKey = ImportInt("FurnitureNPCActionKey", FurnitureNPCActionKey)
	HobbleSkirtSpeedDebuff = ImportInt("HobbleSkirtSpeedDebuff", HobbleSkirtSpeedDebuff)
	KeyDifficulty = ImportInt("KeyDifficulty", KeyDifficulty)
	numNpcs = ImportInt("numNpcs", numNpcs)
	RubberSoundMode = ImportInt("RubberSoundMode", RubberSoundMode)
	MinigameMinSequenceLength = ImportInt("MinigameMinSequenceLength", MinigameMinSequenceLength)
	MinigameMaxSequenceLength = ImportInt("MinigameMaxSequenceLength", MinigameMaxSequenceLength)

	;IMPORT BOOL
	bellyNodeManagement = ImportBool("bellyNodeManagement", bellyNodeManagement)
	BlindfoldTooltip = ImportBool("BlindfoldTooltip", BlindfoldTooltip)
	bootsSlowdownToggle = ImportBool("bootsSlowdownToggle", bootsSlowdownToggle)
	breastNodeManagement = ImportBool("breastNodeManagement", breastNodeManagement)
	DisableLockJam = ImportBool("DisableLockJam", DisableLockJam)
	GagTooltip = ImportBool("GagTooltip", GagTooltip)
	GlobalDestroyKey = ImportBool("GlobalDestroyKey", GlobalDestroyKey)
	LockMenuWhenTied = ImportBool("lockmenuwhentied", LockMenuWhenTied)
	LogMessages = ImportBool("LogMessages", LogMessages)
	mittensDropToggle = ImportBool("mittensDropToggle", mittensDropToggle)
	MuffleTooltip = ImportBool("MuffleTooltip", MuffleTooltip)
	NpcMessages = ImportBool("NpcMessages", NpcMessages)
	PlayerMessages = ImportBool("PlayerMessages", PlayerMessages)
	preserveAggro = ImportBool("preserveAggro", preserveAggro)
	useAnimFilter = ImportBool("useAnimFilter", useAnimFilter)
	UseBoundCombat = ImportBool("UseBoundCombat", UseBoundCombat)
	UseBoundCombatPerks = ImportBool("UseBoundCombatPerks", UseBoundCombatPerks)
	UseItemManipulation = ImportBool("UseItemManipulation", UseItemManipulation)
	ShowMinigameTutorial = ImportBool("ShowMinigameTutorial", ShowMinigameTutorial)
	ShowMinigameNotifications = ImportBool("ShowMinigameNotifications", ShowMinigameNotifications)
	
	;IMPORT FLOAT
	BeltRateMult = ImportFloat("BeltRateMult", BeltRateMult)
	blindfoldStrength = ImportFloat("blindfoldStrength", blindfoldStrength)
	EventInterval = ImportFloat("EventInterval", EventInterval)
	PlugRateMult = ImportFloat("PlugRateMult", PlugRateMult)
	VolumeEdged = ImportFloat("VolumeEdged", VolumeEdged)
	volumeMuffled = ImportFloat("volumeMuffled", volumeMuffled)
	volumeMuffleWhiteNoise = ImportFloat("volumeMuffleWhiteNoise", volumeMuffleWhiteNoise)
	VolumeOrgasm = ImportFloat("VolumeOrgasm", VolumeOrgasm)
	VolumeVibrator = ImportFloat("VolumeVibrator", VolumeVibrator)
	VolumeVibratorNPC = ImportFloat("VolumeVibratorNPC", VolumeVibratorNPC)
	MinigameMinKeyHoldTime = ImportFloat("MinigameMinKeyHoldTime", MinigameMinKeyHoldTime)
	MinigameMaxKeyHoldTime = ImportFloat("MinigameMaxKeyHoldTime", MinigameMaxKeyHoldTime)
	MinigameCriticalFailChance = ImportFloat("MinigameCriticalFailChance", MinigameCriticalFailChance)
	MinigameEscalationChance = ImportFloat("MinigameEscalationChance", MinigameEscalationChance)

	ForcePageReset()
EndFunction
