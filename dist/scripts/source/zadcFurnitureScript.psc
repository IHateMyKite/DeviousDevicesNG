Scriptname zadcFurnitureScript extends ObjectReference  

; --------------------------------------------------------------
; zadcFurnitureScript - (c) by Kimy
; --------------------------------------------------------------

{ to-do: 
Autonomous escape by NPCs
Need to make sure in DDI that NPCs can't unlock/equip invalid devices. Best to forbid item manipulation overall?
}

zadclibs Property clib Auto
zadlibs Property libs Auto
zadcNGEscapeMinigame Property zadcNGEscapeMinigameQuest Auto

String Property DeviceName = "" Auto					; Device name for use in messageboxes etc.
Bool Property ForceStripActor = True Auto				; If enabled, the actor will be automatically stripped naked when put in the device. Their outfit will be restored upon leaving.
Bool Property ScriptedDevice = False Auto				; If enabled, the device cannot be interacted with via dialogue. Activating the device via a package will still work for NPCs. Useful for devices that need to be used in scenes.
Package[] Property BoundPose Auto						; Packages containing the actual poses
Package[] Property StrugglePose Auto					; Packages containing the struggle poses
Bool Property SendDeviceModEvents = True Auto			; If enabled, the device will send mod events when an actor is getting locked or unlocked by this device.
ObjectReference[] Property LinkedDevices Auto			; With this list, groups of linked furniture devices can be defined. The interpretation of the values is up to the mod setting them up. The list can e.g. be used to identify closeby devices to lock up followers etc.
Bool Property CanBePickedUp = False Auto				; If set to true, this device can be picked up by the player (a build kit will be placed in her inventory and the device is removed from the world)
MiscObject Property Blueprint Auto						; For pickable devices, this build kit will be created upon picking up the device.

; Sex scenes - Attention: This feature assumes that the subject locked in the devive is female. It will not do anything for male characters.
String[] Property SexAnimations Auto					; List of sex animations for this device. The strings contain the names of the animations, as they will have to get retrieved from the SL repository by name, since they're private.
Bool Property PartnerIsInFront = true Auto				; If true, the partner stands in front of the device, otherwise in the back. If there is more than one animation per device, the animation MUST use the SAME values for position. changed default to true becase the majority of devices are of the in-front variety - krzp
Int Property Distance = 45 Auto							; Distance from the device the partner is standing.
Bool Property AllowPasserbyAction = False Auto			; Allows the code to check for random actors closeby and use them for random interactions with the subject in the device.
Float Property PasserbyCooldown = 0.0 Auto				; If this number is greater than zero, this cooldown (in hours) will be applied to consecutive passerby events.

; DD Device handling
Bool Property HideAllDevices = False Auto				; If set to true, the code will hide -all- DD restraints while the actor is using the devices. For more fine control, use InvalidDevices.
Keyword[] Property InvalidDevices Auto					; List of keywords of DD restraint types that cannot be worn while using this furniture device. The code will hide these items in a quest-safe way.
Package[] Property BoundPoseArmbinder Auto				; Packages containing special poses for armbinders.
Package[] Property StrugglePoseArmbinder Auto			; Packages containing the special struggle poses for armbinders.
Package[] Property BoundPoseYoke Auto					; Packages containing special poses for yokes.
Package[] Property StrugglePoseYoke Auto				; Packages containing the special struggle poses for yokes.
Armor[] Property EquipDevices Auto						; List of DD devices or regular armor that will get equipped when an actor enters a device.
Faction Property zadc_Faction_FurnitureUser Auto        ; Faction to be set on the user when he enters the furniture. Will be remove when the actor leaves the device. Can be used to detect actor state in Papyrus Conditions

Key Property deviceKey  Auto               				; Key type to unlock this device
Bool Property DestroyKey = False Auto 					; If set to true, the key(s) will be destroyed when the device is unlocked or escaped from.
Bool Property DestroyOnRemove = False Auto 				; If set to true, they device will be destroyed when it is unlocked or escaped from.
Int Property NumberOfKeysNeeded = 1 Auto 				; Number of keys needed (=multiple locks)
Float Property LockAccessDifficulty = 0.0 Auto			; If set to greater than zero, the character cannot easily reach the locks when locked in this restraint. The higher the number, the harder she will find it to unlock herself, even when in possession of the key. A value of 100 will make it impossible for her to reach the locks. She will need help. Make sure that your mod actually provides a means to escape such retraints!
Float Property UnlockCooldown = 0.0	Auto				; How many hours have to pass between unlock attempts for hard to unlock restraints.
Float Property LockShieldTimerMin = 0.0 Auto			; If this number is greater than zero, the player has to wait for a minimum of this many hours before she can unlock the device with a key.
Float Property LockShieldTimerMax = 0.0 Auto			; If this number is greater than zero, the player has to wait for a maximum of this many hours before she can unlock the device with a key.
Bool Property PreventWaitandSleep = True Auto 			; If set to true, the device will prevent the player from using the wait/sleep dialogue when locked in a device.

; Escape system - please note that devices are inescapable by default. Change these values, if needed.
Float Property BaseEscapeChance = 0.0 Auto				; Base chance to escape a restraint via struggling. Magic bonus applies. 0 disables this feature.
Float Property LockPickEscapeChance = 0.0 Auto			; Base chance to escape a restraint via lockpicking Need proper lockpick, Lockpick bonus applies. 0 disables this feature.
Form[] Property AllowedLockPicks Auto 					; List of items other than lockpicks considered a valid pick tool for this device. The lockpick is allowed by default unless disabled.
Bool Property AllowLockPick = True Auto					; Indicates whether or not the standard lockpick is considered a valid lockpick for this device.
Float Property BreakDeviceEscapeChance = 0.0 Auto		; Base chance to escape a restraint via breakting it open. Weapon bonus applies. 0 disables this feature.
Bool Property AllowStandardTools = True Auto			; Indicates whether or not the items in the standard tools list (all small blades) are considered a valid breakting tool for this device.
Keyword[] Property AllowedTool Auto						; List of item keywords considered a breakting tool for this device. 
Float Property CatastrophicFailureChance = 0.0 Auto		; Chance that an escape attempt fails in a catastrophic manner, preventing any further attempts to escape this device using that method.
Float Property EscapeCooldown = 0.25	Auto			; How many hours have to pass between escape attempts.	
Bool Property AllowDifficultyModifier = False Auto		; Override to allow the difficulty modifier for quest/custom items (tagged with zad_BlockGeneric or zad_QuestItem). For generic items this is always allowed, regardless of this setting.
Bool Property DisableLockManipulation = False Auto		; Override to disallow the player manipulating the locks. Not needed for quest/custom items, as this feature is disabled for them anyway.
Int Property MercyEscapeAttempts = 0 Auto				; Set this number to greater than zero to automatically release the player after this number of failed attempts.

; Messages
Message Property zadc_DeviceMsgPlayerLocked	Auto		; Message to be displayed when the player is activating the device while locked in it.
Message Property zadc_DeviceMsgPlayerNotLocked	Auto	; Message to be displayed when the player is activating the device while not locked in it.
Message Property zadc_DeviceMsgNPCLocked Auto			; Message to be displayed when the player is activating a device with a NPC locked in it.
Message Property zadc_DeviceMsgNPCNotLocked Auto		; Message to be displayed when the player is activating a device to lock an NPC in.
Message Property zadc_DeviceMsgPlayerNotLockedCanPick Auto	; Message to be displayed when the player is activating a device to lock an NPC in, with an additional option for devices that can be picked up.
Message Property zadc_EscapeDeviceMSG Auto 				; Device escape dialogue. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message Property zadc_EscapeDeviceNPCMSG Auto 			; Device escape dialogue for player helping NPCs locked in a device. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message Property zadc_OnDeviceLockMSG Auto 				; Message is displayed upon getting locked into a device (dialogue only)
Message Property zadc_OnNoKeyMSG Auto 	 				; Message is displayed when the player has no key
Message Property zadc_OnNotEnoughKeysMSG	Auto 		; Message is displayed when the player has not enough keys
Message Property zadc_OnLeaveItNotLockedMSG Auto 		; Message is displayed when the player clicks the "Leave it Alone" button while not locked in the device
Message Property zadc_OnLeaveItLockedMSG Auto 	 		; Message is displayed when the player clicks the "Leave it Alone" button while being locked in the device.
Message Property zadc_EscapeStruggleMSG Auto 			; Message to be displayed when the player tries to struggle out of a restraint
Message Property zadc_EscapeStruggleNPCMSG Auto 		; Message to be displayed when the player tries to help an NPC struggle out of a restraint
Message Property zadc_EscapeStruggleFailureMSG Auto 	; Message to be displayed when the player fails to struggle out of a restraint
Message Property zadc_EscapeStruggleSuccessMSG Auto 	; Message to be displayed when the player succeeds to struggle out of a restraint
Message Property zadc_EscapeLockPickMSG Auto 			; Message to be displayed when the player tries to pick a restraint
Message Property zadc_EscapeLockPickFailureMSG Auto 	; Message to be displayed when the player fails to pick a restraint
Message Property zadc_EscapeLockPickSuccessMSG Auto 	; Message to be displayed when the player succeeds to pick a restraint
Message Property zadc_EscapeBreakMSG Auto 				; Message to be displayed when the player tries to break a restraint
Message Property zadc_EscapeBreakFailureMSG Auto 		; Message to be displayed when the player fails to break a restraint
Message Property zadc_EscapeBreakSuccessMSG Auto 		; Message to be displayed when the player succeeds to break open a restraint
Message Property zadc_OnLockDeviceMSG Auto				; Message to be displayed when the player locks on an item, so she can manipulate the locks if she choses. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message Property zadc_OnLockDeviceNoManipulateMSG Auto	; Message to be displayed when the player locks on an item that's protected against lock manipulation. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message Property zadc_OnLockDeviceNPCMSG Auto			; Message to be displayed when the player locks an NPC into a device, so she can manipulate the locks if she choses. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message Property zadc_SelfbondageMSG Auto 				; Message to be displayed when the player plays with a device.

; Effects
Spell[] Property AppliedSpellEffects Auto				; These spell effects will be applied by the device. Can be any number of them, and you can use scripted effects to implement pretty much any desired behavior. The spells will be removed upon leaving the device.

; Self Bondage Game/Timer
Bool Property AllowTimerDialogue = True Auto			; If true, the player can set the timed release via a dialogue before locking herself or an NPC in.
Bool Property AllowRewardonEscape = True Auto			; If true, the player will receive a reward when she manages to escape a device before the time is up.
Bool Property ForceTimer = False Auto					; If true, the player will get automatically released when the timer is up, even when they got locked into the device by script.
Float Property SelfBondageReleaseTimer = 1.0 Auto		; How many hours have to pass before auto-unlock.
LeveledItem[] Property Reward Auto						; Lists of reward items. The reward will be randomly chosen, one from each provided list.

; Internal script variables
Float LastUnlockAttemptAt = 0.0							; When did the player last attempt to unlock this device.
Float DeviceEquippedAt = 0.0							; When was this device equipped?
Float LockShieldStartedAt = 0.0							; When was the lock shield timer set? Usually the same as DeviceEquippedAt, but lock shields can be reset.
Int EscapeBreakAttemptsMade = 0							; Tracker of how often the player tried to escape this device via breakting.
Int EscapeStruggleAttemptsMade = 0						; Tracker of how often the player tried to escape this device via struggling.
Int EscapeLockPickAttemptsMade = 0						; Tracker of how often the player tried to escape this device via lockpicking.
Float LastStruggleEscapeAttemptAt = 0.0					; When did the player last attempt to escape via struggling.
Float LastBreakEscapeAttemptAt = 0.0					; When did the player last attempt to escape via breakting.
Float LastLockPickEscapeAttemptAt = 0.0					; When did the player last attempt to escape via lockpicking.
Float LockShieldTimer = 0.0								; The actual uptime of the lockshield. Randomly determined when the item is equipped using the min and max values.
Float LastPasserbyEventAt = 0.0							; When did the player last experience a passerby event.
Float OriginalBaseEscapeChance = 0.0					; Save variable for the escape chances, for catastrophic failures might change the original values.
Float OriginalLockPickEscapeChance = 0.0				; Save variable for the escape chances, for catastrophic failures might change the original values.
Float OriginalBreakEscapeChance = 0.0					; Save variable for the escape chances, for catastrophic failures might change the original values.

; Internal variables, not exposed to CK, but made accessible to other scripts.
Actor Property user = None Auto Hidden					; Actor locked in the device
Bool Property isSelfBondage = false Auto Hidden			; Indicates if the device will auto-release the subject after some time.
Float Property ReleaseTimerStartedAt = 0.0 Auto Hidden	; When was this device equipped?

; Internal variables
bool isLockManipulated = false							; Indicates if the lock has been manipulated, allowing instant escape.
Bool Mutex = False										; Mutex for the Activator
Bool StruggleMutex = False								; Mutex for the struggle scene
Bool UnlockMutex = False								; Mutex for unlock. Used to prevent package add/remove race conditions
int lasthourdisplayed									; Variable to store the remaining hours until the timer opens the devices. Used to curb spamming of the "This device will unlock in x hours" message.
Package CurrentPose										; Stores the current bound pose
;Float OldScale	= 1.0									; Stores the original scale of the actor in case the code needs to scale her.
Float PosX												; Position of the subject before she got locked in the device. It will get used to place her back when released from the device.
Float PosY
Float PosZ
Float FPosX												; Position of the subject while she is locked in the device. It is used to undo slight position changes when playing a sex scene.
Float FPosY
Float FPosZ
Float FAngleX										
Float FAngleY
Float FAngleZ


Package Function PickRandomPose()
	CurrentPose = BoundPose[Utility.RandomInt(0, BoundPose.Length - 1)]
	Return CurrentPose
EndFunction

Package Function PickRandomStruggle()
	Return StrugglePose[Utility.RandomInt(0, StrugglePose.Length - 1)]
EndFunction

String Function PickRandomSexScene()
	If SexAnimations.Length == 0
		return ""
	EndIf
	Return SexAnimations[Utility.RandomInt(0, SexAnimations.Length - 1)]
EndFunction

Function ApplyEffects(Actor akActor)	
	Int i = AppliedSpellEffects.Length	
	While i > 0
		i -= 1
		akActor.AddSpell(AppliedSpellEffects[i], abVerbose = False)
	EndWhile
EndFunction

Function RemoveEffects(Actor akActor)
	Int i = AppliedSpellEffects.Length
	While i > 0
		i -= 1
		akActor.RemoveSpell(AppliedSpellEffects[i])
	EndWhile
EndFunction

Function SetLockShield()
	LockShieldStartedAt = libs.GameDaysPassed.GetValue()
	If (LockShieldTimerMin > 0.0) && (LockShieldTimerMin <= LockShieldTimerMax)
		LockShieldTimer = ((Utility.RandomFloat(LockShieldTimerMin, LockShieldTimerMax)) * CalculateCooldownModifier(False))
	Else
		LockShieldTimer = 0.0
	EndIf
EndFunction

Bool Function CheckLockShield()
	If LockShieldTimer == 0.0
		return True
	EndIf
	Float HoursNeeded = LockShieldTimer
	Float HoursPassed = (libs.GameDaysPassed.GetValue() - LockShieldStartedAt) * 24.0
	if HoursPassed > HoursNeeded
		return True
	Else		
		Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)		
		libs.notify("This lock is protected with a timed lock shield preventing you from inserting a key as long as it is active! You can try to unlock this device in about " + HoursToWait + " hours.", messageBox = true)
		return False
	EndIf
EndFunction

Function CheckSelfBondageRelease()	
	If !isSelfBondage
		return 
	EndIf
	Float HoursNeeded = SelfBondageReleaseTimer
	Float HoursPassed = (libs.GameDaysPassed.GetValue() - ReleaseTimerStartedAt) * 24.0
	if HoursPassed > HoursNeeded
		if user == libs.PlayerRef
			libs.notify("The timed lock clicks open and frees you from the device!", messageBox = true)
		EndIf
		UnlockActor()
		return	
	Else
		Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)		
		if user == libs.PlayerRef && HoursToWait != lasthourdisplayed
			libs.notify("This device will unlock in about " + HoursToWait + " hours.")			
			lasthourdisplayed = HoursToWait
		EndIf
		return
	EndIf
EndFunction

Function ApplyDevices(Actor akActor)	
	Int i = EquipDevices.Length	
	While i > 0
		i -= 1
		If EquipDevices[i].HasKeyword(libs.zad_InventoryDevice)
			libs.EquipDevice(akActor, EquipDevices[i], libs.GetRenderedDevice(EquipDevices[i]), libs.GetDeviceKeyword(EquipDevices[i]), SkipMutex = True, SkipEvents = False)
		Else
			akActor.EquipItem(EquipDevices[i], abSilent = True)
		EndIf
	EndWhile
EndFunction

Function RemoveDevices(Actor akActor)
	Int i = EquipDevices.Length	
	While i > 0
		i -= 1
		If EquipDevices[i].HasKeyword(libs.zad_InventoryDevice)
			libs.RemoveDevice(akActor, EquipDevices[i], libs.GetRenderedDevice(EquipDevices[i]), libs.GetDeviceKeyword(EquipDevices[i]), SkipMutex = True, SkipEvents = False, DestroyDevice = True)
		Else
			akActor.UnEquipItem(EquipDevices[i], abSilent = True)
			akActor.RemoveItem(EquipDevices[i], abSilent = True)
		EndIf
	EndWhile
EndFunction

; Lockstatus is TRUE when the actor gets placed in the device, FALSE when she's unlocked.
Function SendDeviceEvent(Bool LockStatus)
	Int Handle = ModEvent.Create("DDC_DeviceEvent")
	If (Handle)		
		ModEvent.PushForm(Handle, User)
		ModEvent.PushForm(Handle, self)
		ModEvent.PushBool(Handle, LockStatus)
		ModEvent.Send(Handle)
	Endif	
EndFunction

Function LockActor(actor act)		
	if !libs.SexLab.ActorLib.CanAnimate(act)
		return
	EndIf
	If act == libs.PlayerRef		
		Game.SetPlayerAIDriven()			
	EndIf
	user = act
	user.SetDoingFavor(False)							
	If CurrentPose
		ActorUtil.RemovePackageOverride(user, CurrentPose)
	EndIf	
	if user != libs.PlayerRef
		If User.IsEquipped(clib.zadc_PrisonerChainsRendered)
			libs.removeDevice(User, clib.zadc_PrisonerChainsInventory, clib.zadc_PrisonerChainsRendered, libs.zad_DeviousHeavyBondage, destroydevice = true, skipmutex = true)
		EndIf
		If User == clib.SelectedUser
			clib.SelectedUser = None
		EndIf
		user.SetDontMove(True)
		user.SetRestrained(True)
		user.SetHeadTracking(False)
		Utility.Wait(0.5)
	EndIf
	;OldScale = 1.0
	;Float uScale = user.GetScale()	
	;If uScale != 1.0 && uScale > 0.9
	;	OldScale = uScale
	;	user.SetScale(1.0)
	;EndIf	
	user.moveto(self)	
	PosX = user.GetPositionX()
	PosY = user.GetPositionY()
	PosZ = user.GetPositionZ()	
	clib.StoreBondage(user, InvalidDevices, HideAllDevices)	
	clib.SetNiOverrideOverride(user)
	ActorUtil.RemovePackageOverride(user, clib.zadc_pk_donothing)	
	Package Pose = clib.GetOverridePose(self)
	If Pose
		; let's see if it's a valid one
		Bool isValidPose = False
		Int k = BoundPose.Length - 1
		While k >= 0
			If Pose == BoundPose[k]
				isValidPose = True
			EndIf
			k -= 1
		EndWhile
		If isValidPose
			ActorUtil.AddPackageOverride(user, Pose, 99)	
		Else
			ActorUtil.AddPackageOverride(user, PickRandomPose(), 99)	
		EndIf
	Else
		ActorUtil.AddPackageOverride(user, PickRandomPose(), 99)	
	EndIf
	User.EvaluatePackage()			
	self.disable()			
	If act == libs.PlayerRef
		Game.DisablePlayerControls(abMovement = true, abFighting = true, abSneaking = true, abMenu = true,	abActivate = false, abCamSwitch = false, abLooking = false, abJournalTabs = true)		
		; if it's the player, we need to make sure she can try to escape
		UnregisterForAllControls()	
		RegisterForControl("Activate")
		If PreventWaitandSleep
			act.EquipItem(clib.zadc_NoWaitItem, True, True)
		EndIf
		Game.ForceThirdPerson()
		Game.SetCameraTarget(libs.PlayerRef)
	EndIf			
	clib.StoreDevice(user, self)
	SetLockShield()	
	DeviceEquippedAt = libs.GameDaysPassed.GetValue()
	ReleaseTimerStartedAt = DeviceEquippedAt
	If ForceTimer
		isSelfBondage = True
	EndIf
	ApplyEffects(user)
	ApplyDevices(user)	
	RegisterForSingleUpdate(30)	
	LastBreakEscapeAttemptAt = 0.0
	LastStruggleEscapeAttemptAt = 0.0
	LastLockPickEscapeAttemptAt = 0.0
	LastUnlockAttemptAt = 0.0	
	EscapeBreakAttemptsMade = 0
	EscapeStruggleAttemptsMade = 0
	EscapeLockpickAttemptsMade = 0	
	lasthourdisplayed = 0
	LastPasserbyEventAt = 0.0
	OriginalBaseEscapeChance = BaseEscapeChance
	OriginalLockPickEscapeChance = LockPickEscapeChance
	OriginalBreakEscapeChance = BreakDeviceEscapeChance
	If SendDeviceModEvents
		SendDeviceEvent(True)
	EndIf
	AntiCL(user)
	if zadc_Faction_FurnitureUser
		user.AddToFaction(zadc_Faction_FurnitureUser)
	endif
EndFunction

Function UnlockActor()
	if !user ; Nobody to unlock.
		Return
	endif
	UnlockMutex = True
	self.enable()
	UnregisterForUpdate()
        UnregisterForAllControls()
        user.StopTranslation()
	ActorUtil.RemovePackageOverride(user, CurrentStruggle)
	ActorUtil.RemovePackageOverride(user, CurrentPose)		
	Debug.SendAnimationEvent(User, "IdleForceDefaultState")				
	If user == Game.GetPlayer()			
		Game.SetPlayerAIDriven(False)
		Game.EnablePlayerControls()	
		user.RemoveItem(clib.zadc_NoWaitItem, user.GetItemCount(clib.zadc_NoWaitItem), abSilent = True)
		if zadcNGEscapeMinigameQuest.IsRunning()
			zadcNGEscapeMinigameQuest.Stop()
		EndIf
		if zadc_Faction_FurnitureUser
			user.RemoveFromFaction(zadc_Faction_FurnitureUser)
		endif
	Else
		user.SetDontMove(False)	
		user.SetHeadTracking(True)
		user.SetRestrained(False)			
	EndIf			
	Utility.Wait(0.2)
	user.moveto(user)		
	user.SetPosition(PosX, PosY, PosZ)
	RemoveEffects(user)
	clib.ResetNiOverrideOverride(user)
	RemoveDevices(user)
	;If ForceStripActor			
	;	clib.RestoreOutfit(user)
	;EndIf
	clib.RestoreBondage(user)
	User.EvaluatePackage()
	If SendDeviceModEvents
		SendDeviceEvent(False)
	EndIf
	clib.ClearDevice(user)
	;If OldScale != 1.0		
	;	user.SetScale(OldScale)
	;	OldScale = 1.0
	;EndIf
	user = none		
	isSelfBondage = False
	isLockManipulated = False
	If DestroyOnRemove
		self.Disable()
		self.Delete()
	else
		BaseEscapeChance = OriginalBaseEscapeChance
		LockPickEscapeChance = OriginalLockPickEscapeChance
		BreakDeviceEscapeChance = OriginalBreakEscapeChance
	EndIf	
	UnlockMutex = False
EndFunction

Event OnControlDown(string control)
	If UI.IsMenuOpen("Console") || UI.IsMenuOpen("Console Native UI Menu")
		Return
	EndIf	
	If control == "Activate"
		self.Activate(libs.PlayerRef)
	Endif	
EndEvent

Bool Function CanMakeUnlockAttempt()
	; check if the character can make an unlock attempt.
	Float HoursNeeded = (UnlockCooldown * CalculateCooldownModifier(False))
	Float HoursPassed = (libs.GameDaysPassed.GetValue() - LastUnlockAttemptAt) * 24.0
	if HoursPassed > HoursNeeded
		LastUnlockAttemptAt = libs.GameDaysPassed.GetValue()
		return True
	Else
		Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
		libs.notify("You are still tired from the last attempt, and cannot again try to unlock this device already! You can try again in about " + HoursToWait + " hours.", messageBox = true)
	EndIf
	return False
EndFunction

Bool Function CheckLockAccess()		
	If LockAccessDifficulty > 0.0
		If !CanMakeUnlockAttempt()
			Return False
		EndIf
		Float ModValue = (LockAccessDifficulty * CalculateDifficultyModifier(False))
		If (LockAccessDifficulty < 100.0) && (ModValue >= 100.0)
			; If the modder didn't mean to make it completely impossible to reach the locks, it shouldn't be after applying the modifier either!
			ModValue = 95.0
		EndIf
		If Utility.RandomFloat(0.0, 99.9) < ModValue
			If DeviceKey != None 
				If LockAccessDifficulty < 50.0
					libs.notify("You try to insert the key into the " + DeviceName + "'s lock, but find the locks a bit outsides of your reach. After a few failed attempts to slide the key into the lock, you have no choice but to give up for now. You should still eventually be able to unlock yourself. Just try again a bit later!", messageBox = True)
				ElseIf LockAccessDifficulty < 100.0
					libs.notify("This device was designed to make it hard for the person wearing it in to unlock herself. You struggle hard trying to insert the key into the " + DeviceName + "'s lock anyway, but find the locks well outsides of your reach. Tired from your struggles, you have no choice but to give up for now. Maybe try again later!", messageBox = True)
				Else
					libs.notify("This device was designed to put the locks safely out of reach of the person wearing it. There is no way you will ever be able to unlock yourself, even when in possession of the proper key. You will need to seek help!", messageBox = True)
				EndIf
			Else
				libs.notify("You try to escape the device, but you are unable to reach the locking mechanism!", messageBox = True)
			EndIf
			Return False
		EndIf
	EndIf
	Return True
EndFunction

Function DeviceMenuLock()	
	Int i
	If CanBePickedUp
		i = zadc_DeviceMsgPlayerNotLockedCanPick.Show()
	Else
		i = zadc_DeviceMsgPlayerNotLocked.Show()
	EndIf
	if i == 0
		isLockManipulated = False		
		isSelfBondage = False		
		If !DisableLockManipulation && libs.Config.UseItemManipulation
			Int Choice = zadc_OnLockDeviceMSG.Show()
			If Choice == 1
				;self bondage game	
				isSelfBondage = True
				If AllowTimerDialogue
					Int Choice2 = zadc_SelfbondageMSG.Show()
					If Choice2 == 0
						SelfBondageReleaseTimer = 1.0
					Elseif Choice2 == 1
						SelfBondageReleaseTimer = 2.0	
					Elseif Choice2 == 2
						SelfBondageReleaseTimer = 5.0	
					Elseif Choice2 == 3
						SelfBondageReleaseTimer = 12.0	
					Elseif Choice2 == 4
						SelfBondageReleaseTimer = 24.0	
					Elseif Choice2 == 1
						clib.UserRef.Clear()
						return
					EndIf
				EndIf
			elseIf Choice == 2
				; manipulate the locks
				isLockManipulated = True											
			Else
				; display lock message, but otherwise no need to do anything, just let the function run
				zadc_OnDeviceLockMSG.Show()			
			EndIf
		Else
			Int Choice = zadc_OnLockDeviceNoManipulateMSG.Show()
			If Choice == 1
				;self bondage game	
				isSelfBondage = True
				If AllowTimerDialogue
					Int Choice2 = zadc_SelfbondageMSG.Show()
					If Choice2 == 0
						SelfBondageReleaseTimer = 1.0
					Elseif Choice2 == 1
						SelfBondageReleaseTimer = 2.0	
					Elseif Choice2 == 2
						SelfBondageReleaseTimer = 5.0	
					Elseif Choice2 == 3
						SelfBondageReleaseTimer = 12.0	
					Elseif Choice2 == 4
						SelfBondageReleaseTimer = 24.0	
					Elseif Choice2 == 1
						clib.UserRef.Clear()
						return
					EndIf
				EndIf
			Else
				zadc_OnDeviceLockMSG.Show()	
			EndIf			
		EndIf
	elseif i == 1
		; Examine device
		DisplayDifficultyMsg()			
		return
	EndIf
	If !CanBePickedUp
		If i == 2
			; do nothing, just abort
			zadc_OnLeaveItNotLockedMSG.Show()			
			return
		EndIf
	Else 
		If i == 2
			; this is the pick up option for the CanPick version of the dialogue
			self.Disable()
			self.Delete()
			libs.PlayerRef.AddItem(Blueprint, 1, False)
			return
		Else
			; do nothing, just abort
			zadc_OnLeaveItNotLockedMSG.Show()			
			return
		EndIf
	EndIf
	LockActor(libs.playerRef)
EndFunction

Function DeviceMenuLockNPC(Actor subject)	
	clib.UserRef.ForceRefTo(subject)	
	Int i 
	i = zadc_DeviceMsgNPCNotLocked.Show()
	if i == 0
		isLockManipulated = False		
		isSelfBondage = False		
		If !DisableLockManipulation && libs.Config.UseItemManipulation
			Int Choice = zadc_OnLockDeviceNPCMSG.Show()
			If Choice == 1
				;self bondage game	
				isSelfBondage = True
				If AllowTimerDialogue
					Int Choice2 = zadc_SelfbondageMSG.Show()
					If Choice2 == 0
						SelfBondageReleaseTimer = 1.0
					Elseif Choice2 == 1
						SelfBondageReleaseTimer = 2.0	
					Elseif Choice2 == 2
						SelfBondageReleaseTimer = 5.0	
					Elseif Choice2 == 3
						SelfBondageReleaseTimer = 12.0	
					Elseif Choice2 == 4
						SelfBondageReleaseTimer = 24.0	
					Elseif Choice2 == 1
						clib.UserRef.Clear()
						return
					EndIf
				EndIf
			elseIf Choice == 2
				; manipulate the locks
				isLockManipulated = True											
			Else
				; display lock message, but otherwise no need to do anything, just let the function run
				zadc_OnDeviceLockMSG.Show()			
			EndIf
		Else
			zadc_OnDeviceLockMSG.Show()			
		EndIf
	elseif i == 1
		; Examine device
		DisplayDifficultyMsg()			
		return
	elseif i == 2
		; do nothing, just abort
		zadc_OnLeaveItNotLockedMSG.Show()			
		return
	EndIf	
	clib.UserRef.Clear()
	LockActor(subject)
EndFunction

Function DeviceMenuUnlock()	
	Int i = zadc_DeviceMsgPlayerLocked.Show()
	If i == 0
		; unlock
		UnlockAttempt()
	Elseif i == 1
		; Escape
		EscapeAttempt()
	Elseif i == 2
		; Examine
		DisplayDifficultyMsg()
	EndIf
EndFunction

Function DeviceMenuNPC()
	clib.UserRef.ForceRefTo(user)
	Int i = zadc_DeviceMsgNPCLocked.Show()
	clib.UserRef.Clear()
	If i == 0
		; unlock
		UnlockAttemptNPC()
	Elseif i == 1
		; Escape
		EscapeAttemptNPC()
	Elseif i == 2
		; Examine
		DisplayDifficultyMsg()
	ElseIf i == 3
		; Sex
		SexWithNPCAction()
	EndIf
EndFunction

Bool Function UnlockAttemptNPC()
	If isLockManipulated
		libs.Notify("As you have manipulated the " + deviceName + ", you are able release " + user.GetLeveledActorBase().GetName() + " from the device with ease!", messageBox = True)
		UnlockActor()	
		Return True
	EndIf
	If !CheckLockShield() ; is the timer expired?
		Return False
	EndIf		
	If DeviceKey
		If libs.PlayerRef.GetItemCount(DeviceKey) <= 0
			zadc_OnNoKeyMSG.Show()			
			Return False
		ElseIf libs.PlayerRef.GetItemCount(DeviceKey) < NumberOfKeysNeeded			
			zadc_OnNotEnoughKeysMSG.Show()			
			Return False
		EndIf				
		If DestroyKey
			libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)
		elseif libs.Config.GlobalDestroyKey && DeviceKey.HasKeyword(libs.zad_NonUniqueKey)
			libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)	
		EndIf	
	EndIf	
	UnlockActor()
	return True
EndFunction

Bool Function UnlockAttempt()
	; this function is used for the player only.
	If isLockManipulated
		libs.Notify("As you have manipulated the " + deviceName + ", you are able to slip out of the device with ease!", messageBox = True)
		UnlockActor()	
		Return True
	EndIf		
	If !CheckLockShield() ; is the timer expired?
		Return False
	EndIf
	If DeviceKey
		If libs.PlayerRef.GetItemCount(DeviceKey) <= 0
			zadc_OnNoKeyMSG.Show()			
			Return False
		ElseIf libs.PlayerRef.GetItemCount(DeviceKey) < NumberOfKeysNeeded			
			zadc_OnNotEnoughKeysMSG.Show()			
			Return False
		EndIf
		If !CheckLockAccess()
			Return False
		EndIf		
		; We show the struggle scene now.
		StruggleScene(libs.PlayerRef)		
		If DestroyKey
			libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)
		elseif libs.Config.GlobalDestroyKey && DeviceKey.HasKeyword(libs.zad_NonUniqueKey)
			libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)	
		EndIf	
	Else 
		If !CheckLockAccess()
			Return False
		EndIf
	EndIf	
	UnlockActor()
	return True
EndFunction

Event OnActivate(ObjectReference akActionRef)	
	; set a mutex in case the device gets activated multiple times in short order
	If mutex
		return
	EndIf
	mutex = true	
	Actor act = akActionRef As Actor
	If !user 
		; lock somebody in the device when it's not occupied. 
		If act == libs.PlayerRef
			If !ScriptedDevice
				DeviceMenuLock()
			Else
				libs.Notify("This device cannot be interacted with.")
			EndIf
		Else
			; ok, so here we need to find out if that NPC got ordered in the device by the player or just wanted to play because some package was mean enough to send her there.
			If act == clib.SelectedUser
				If !ScriptedDevice
					DeviceMenuLockNPC(act)
				Else
					libs.Notify("This device cannot be interacted with.")				
				EndIf
			Else
				; wasn't ordered by the player, so just lock that person in, no questions asked!
				LockActor(act)
			EndIf
		EndIf
	Elseif user
		; device is occupied
		If user != act
			; someone else is releasing the occupant.
			; It is conveivable that the user gets unlocked by NPCs. We could handle this here and check for keys etc. Right now we allow NPC to just unlock the user.
			if act == libs.PlayerRef
				If !ScriptedDevice
					DeviceMenuNPC()
				Else
					libs.Notify("This device cannot be interacted with.")				
				EndIf	
			Else
				UnlockActor()
			EndIf
		Else
			; attempt by the person locked in the device to open it
			if act == libs.PlayerRef
				; that's the PC unlocking herself
				If !ScriptedDevice
					DeviceMenuUnlock()
				Else
					libs.Notify("This device cannot be interacted with.")				
				EndIf	
			EndIf			
		EndIf
	EndIf 		
	mutex = false
EndEvent

Bool Function PasserbyAction()
	; right now, just sex scenes are supported, but could also hook in random spanking here.	
	If !AllowPasserbyAction || !User.Is3DLoaded() || User.GetParentCell() != Libs.PlayerRef.GetParentCell() || clib.IsAnimating(user)
		return false
	EndIf	
	If ((libs.GameDaysPassed.GetValue() - LastPasserbyEventAt) * 24) < PasserbyCooldown
		return false
	EndIf	
	if SexAnimations.Length == 0 || !clib.GetIsFemale(User)
		; this device has no valid scenes, or the user isn't female
		return false
	EndIf
	If user.WornHasKeyword(libs.zad_DeviousBelt)
		;respect belts
		return false
	EndIf
	Actor currenttest = Game.FindRandomActorFromRef(user, 1000.0)
	if currenttest && libs.ValidForInteraction(currenttest, genderreq = -1, creatureok = false, animalok = false, beastreaceok = true, elderok = false, guardok = true)
		If currenttest == Libs.PlayerRef
            libs.notify(currenttest.GetLeveledActorBase().GetName() + " is going to take advantage of you...")
        Else
            libs.notify(currenttest.GetLeveledActorBase().GetName() + " is going to take advantage of " + User.GetLeveledActorBase().GetName() + ".")
        EndIf
		SexScene(currenttest)
		return true
	EndIf
	return false
EndFunction

Bool Function SexWithNPCAction()
	if SexAnimations.Length == 0 || !clib.GetIsFemale(User)
		libs.notify("You cannot have sex with " + user.GetLeveledActorBase().GetName() + " while they are locked in this contraption!", messageBox = true)
		return false
	EndIf
	If user.WornHasKeyword(libs.zad_DeviousBelt)
		libs.notify("The chastity belt " + user.GetLeveledActorBase().GetName() + " is wearing is preventing you from having sex with them!", messageBox = true)
		return false
	EndIf
	SexScene(libs.PlayerRef)
	Return True
EndFunction

Int StruggleTick = 0
Event OnUpdate()
	if user && !UnlockMutex ;prevent race condition when this function gets called whilst in or starting the UnlockActor function
		StruggleTick += 1
		if StruggleTick > 1
			StruggleTick = 0
		EndIf	
		RegisterForSingleUpdate(Utility.RandomInt(20,40))
		; Don't run random struggle while passerby action is running.
		If !PasserbyAction() && StruggleTick == 0
			; Don't run random struggle if user is already doing struggle minigame (player only).
			If user != libs.PlayerRef || !zadcNGEscapeMinigameQuest.IsRunning() || zadcNGEscapeMinigameQuest.IsSuspended()
				StruggleScene(user)
			EndIf
		EndIf

		; Since the struggle scene is long, there's a chance user got unlocked since the previous "if user" check. Re-check.
		if user && !clib.IsAnimating(user)
			; to make up for not checking here, we do when a scene ends.
			CheckSelfBondageRelease()		
		EndIf
	EndIf
EndEvent

Event OnDDCSLEnd(int tid, bool hasPlayer)		
	sslThreadController SLcontroller = libs.SexLab.GetController(tid)
	Actor[] actors = SLcontroller.Positions
	int numactors = actors.Length
	int i = 0	
	Bool Userfound = false	
	; let's check if one participant is the player
	While i < numactors		
		If actors[i] == User
			Userfound = true
		Endif		
		i += 1
	EndWhile
	; don't process scenes not involving the user
	if !Userfound
		return
	endif
	LastPasserbyEventAt = libs.GameDaysPassed.GetValue()
	UnRegisterForModEvent("AnimationEnd")
	User.SetDoingFavor(False)
    If User == libs.PlayerRef
        Game.SetPlayerAIDriven()
        Game.DisablePlayerControls(abMovement = true, abFighting = true, abSneaking = true, abMenu = true,    abActivate = false, abCamSwitch = false, abLooking = false, abJournalTabs = true)
        Game.ForceThirdPerson()
        Game.SetCameraTarget(libs.PlayerRef)
    Else
        User.SetDontMove(True)
        User.SetRestrained(True)
        User.SetHeadTracking(False)
    EndIf
	User.SetPosition(FPosX, FPosY, FPosZ)
	User.SetAngle(FAngleX, FAngleY, FAngleZ)
    ActorUtil.AddPackageOverride(user, PickRandomPose(), 99)	
	User.EvaluatePackage()
	AntiCL(user)
	CheckSelfBondageRelease()
	UnregisterForModEvent("HookAnimationEnd_DDCEnd")
EndEvent

Function MoveToBehind(ObjectReference akObjB, ObjectReference akObjA, Float afDistance = 45.0)
	akObjA.MoveTo(akObjB, -afDistance * Math.Sin(akObjB.GetAngleZ()), -afDistance * Math.Cos(akObjB.GetAngleZ()), 0.0, abMatchRotation = true) 
	If akObjA == libs.PlayerRef
		akObjA.SetAngle(akObjB.GetAngleX(), akObjB.GetAngleY(), akObjB.GetAngleZ())
		akObjA.SetAngle(akObjA.GetAngleX(), akObjA.GetAngleY(), akObjA.GetAngleZ() + 180.0) 
		Utility.wait(0.1)
	elseif user == libs.PlayerRef
		;akObjA.SetAngle(akObjA.GetAngleX(), akObjA.GetAngleY(), akObject.GetAngleZ()) 
		libs.PlayerRef.SetAngle(libs.PlayerRef.GetAngleX(), libs.PlayerRef.GetAngleY(), libs.PlayerRef.GetAngleZ() + 180.0) ; rotate the player 180 degrees so the anim starts at the correct rotation
		Utility.wait(0.1)
	endif
EndFunction

Function MoveToFront(ObjectReference akObjB, ObjectReference akObjA, Float afDistance = 120.0)
		akObjA.MoveTo(akObjB, afDistance * Math.Sin(akObjB.GetAngleZ()), afDistance * Math.Cos(akObjB.GetAngleZ()), 0.0, abMatchRotation = true)
		If akObjA == libs.PlayerRef
			akObjA.SetAngle(akObjB.GetAngleX(), akObjB.GetAngleY(), akObjB.GetAngleZ())
			akObjA.SetAngle(akObjA.GetAngleX(), akObjA.GetAngleY(), akObjA.GetAngleZ() + 180.0) 
		elseif user == libs.PlayerRef
			libs.PlayerRef.SetAngle(libs.PlayerRef.GetAngleX(), libs.PlayerRef.GetAngleY(), libs.PlayerRef.GetAngleZ() + 180.0) 
			Utility.wait(0.1)
		Endif
EndFunction

Function FaceObject(ObjectReference akObject, ObjectReference akReference, Float afOffset = 0.0)
	Float angle = akObject.GetHeadingAngle(akReference)
	akObject.SetAngle(akObject.GetAngleX(), akObject.GetAngleY(), akObject.GetAngleZ() + angle + afOffset)
EndFunction

Function PlaceRelative(ObjectReference akObject, ObjectReference akReference, Float afDistance, Float afAngle = 0.0)
	Float angle = akReference.GetAngleZ() + afAngle
	akObject.MoveTo(akReference, afDistance * Math.Sin(angle), afDistance * Math.Cos(angle), 0, abMatchRotation = False)
EndFunction

; If an AnimationName is passed, the scene will use this.
Bool Function SexScene(Actor Partner, String AnimationName = "")
	; sanity check
	If !User.Is3DLoaded() || User.GetParentCell() != Libs.PlayerRef.GetParentCell() || !clib.GetIsFemale(User)
		return false
	EndIf
	RegisterForModEvent("AnimationEnd", "OnSexEnd")	
	; Remove the struggle anim, if playing
	ActorUtil.RemovePackageOverride(User, CurrentStruggle)

	FPosX = User.GetPositionX()
	FPosY = User.GetPositionY()
	FPosZ = User.GetPositionZ()
	FAngleX = User.GetAngleX()
	FAngleY = User.GetAngleY()
	FAngleZ = User.GetAngleZ()
	
	; due to SL P+ 1.8.2.3 not processing centeron correctly, 
	; this block is left here commented for legacy compatibility 
	; for anyone still using it - every other version works correctly without it - krzp
	
	;	If PartnerIsInFront
	;		MoveToFront(self, Partner, Distance)
	;	Else
	;		MoveToBehind(self, Partner, Distance)
	;	EndIf	
	
	sslBaseAnimation[] Sanims	
	Sanims = New sslBaseAnimation[1]
	String ani
	If AnimationName != ""
		ani = AnimationName
	Else
		ani = PickRandomSexScene()
	EndIf	
	if ani != ""
		Sanims[0] = libs.SexLab.GetAnimationObject(ani)	
		if Sanims[0] == None
			If AnimationName != ""
				; it was a custom animation, fall back to random
				Sanims[0] = libs.SexLab.GetAnimationObject(PickRandomSexScene())	
			EndIf
			if Sanims[0] == None
				libs.notify("DDC Warning: Sex Animation not found!")
				return false
			EndIf
		EndIf
		Actor[] SceneSexActors
		SceneSexActors = new actor[2]
		SceneSexActors[0] = User		
		SceneSexActors[1] = Partner	
		RegisterForModEvent("HookAnimationEnd_DDCEnd", "OnDDCSLEnd")    
		ActorUtil.RemovePackageOverride(User, CurrentPose)	; otherwise the anims go awry - krzp	
		If SKSE.GetPluginVersion("SexLabUtil") >= 34340864
			Debug.SendAnimationEvent(User, "IdleForceDefaultState")	; sneaky v2 p+ compatibility to make sure animations start from a default idle, otherwise the first stage on the actor in a contraption didn't play in my tests
		endif
		libs.SexLab.StartSex(Positions = SceneSexActors, anims = Sanims, centeron = User, allowbed = false, hook = "DDCEnd")
		return true
	EndIf
	return false
EndFunction


; ESCAPE SYSTEM

Function EscapeAttempt()
	Int EscapeOption = zadc_EscapeDeviceMSG.show()
	If EscapeOption == 0 ; Struggle
		EscapeAttemptMinigame()
		;EscapeAttemptStruggle()
	Elseif EscapeOption == 1 ; Pick Lock
		EscapeAttemptLockPick()
	Elseif EscapeOption == 2 ; Break Device
		EscapeAttemptBreak()		
	Elseif EscapeOption == 3 ; Nothing
		zadc_OnLeaveItLockedMSG.Show()		
	EndIf			
EndFunction

Function EscapeAttemptNPC()		
	clib.UserRef.ForceRefTo(user)
	Int EscapeOption = zadc_EscapeDeviceNPCMSG.show()	
	clib.UserRef.Clear()
	If EscapeOption == 0 ; Struggle
		EscapeAttemptStruggle()
	Elseif EscapeOption == 1 ; Pick Lock
		EscapeAttemptLockPick()
	Elseif EscapeOption == 2 ; Break Device
		EscapeAttemptBreak()		
	Elseif EscapeOption == 3 ; Nothing
		zadc_OnLeaveItLockedMSG.Show()		
	EndIf			
EndFunction

Package CurrentStruggle
Function StruggleScene(actor akActor)	
	; set a mutex in case the scene gets called while it's still running
	If strugglemutex || UnlockMutex || !akActor.Is3DLoaded() || akActor.GetParentCell() != Libs.PlayerRef.GetParentCell() || clib.IsAnimating(akActor)
		return
	EndIf
	strugglemutex = true	
	CurrentStruggle	= PickRandomStruggle()		
	If !CurrentStruggle
		; sanity check
		return
	EndIf
	;If CurrentPose
	;	ActorUtil.RemovePackageOverride(akActor, CurrentPose)
	;EndIf	
	ActorUtil.AddPackageOverride(akActor, CurrentStruggle, 100)	
	akActor.EvaluatePackage()	
	Utility.Wait(2)
	libs.Pant(akActor)		
	Utility.Wait(2)
	libs.SexlabMoan(akActor)
	Utility.Wait(2)
	libs.Pant(akActor)		
	Utility.Wait(2)
	libs.SexlabMoan(akActor)
	Utility.Wait(2)
	ActorUtil.RemovePackageOverride(akActor, CurrentStruggle)
	If akActor == user && !UnlockMutex ; I.e. user did not get unlocked during struggle, and is not currently being unlocked
		ActorUtil.AddPackageOverride(akActor, CurrentPose, 99)
	EndIf
	akActor.EvaluatePackage()
	libs.SexlabMoan(akActor)
	strugglemutex = false
EndFunction

Float Function CalculateCooldownModifier(Bool operator = true)
	If !AllowDifficultyModifier
		libs.log("Difficulty modifier not applied - disallowed by modder!")
		return 1.0
	EndIf
	Float val = 1.0
	Int mcmValue = libs.config.CooldownDifficulty	
	Int mcmLength = libs.config.EsccapeDifficultyList.Length
	Int median = ((mcmLength - 1) / 2) As Int ; This assumes the array to be uneven, otherwise there is no median value.
	Float maxModifier = 0.9 ; set this as desired - it's the maximum possible +/- modifier. It should not be larger than 1 (=100%)
	Float StepLength = maxModifier / median
	Int Steps = mcmValue - median	
	If operator
		val = 1 + (Steps * StepLength)
	Else
		val = 1 - (Steps * StepLength)
	EndIf
	libs.log("Difficulty modifier applied: " + val + " [setting: " + mcmValue + "]")
	return val
EndFunction

Float Function CalculateDifficultyModifier(Bool operator = true)
	If !AllowDifficultyModifier
		libs.log("Difficulty modifier not applied - disallowed by modder!")
		return 1.0
	EndIf
	Float val = 1.0
	Int mcmValue = libs.config.EscapeDifficulty	
	Int mcmLength = libs.config.EsccapeDifficultyList.Length
	Int median = ((mcmLength - 1) / 2) As Int ; This assumes the array to be uneven, otherwise there is no median value.
	Float maxModifier = 0.75 ; set this as desired - it's the maximum possible +/- modifier. It should not be larger than 1 (=100%)
	Float StepLength = maxModifier / median
	Int Steps = mcmValue - median	
	If operator
		val = 1 + (Steps * StepLength)
	Else
		val = 1 - (Steps * StepLength)
	EndIf
	libs.log("Difficulty modifier applied: " + val + " [setting: " + mcmValue + "]")
	return val
EndFunction

Function DisplayDifficultyMsg()
	Int StruggleEscapeChance = Math.Floor(BaseEscapeChance)
	String result = "You carefully examine the " + DeviceName + ". "
	If StruggleEscapeChance > 75
		result += "This restraint is fairly weak and will not offer much resistance against struggling."
	ElseIf StruggleEscapeChance >= 50
		result += "This is not a very secure restraint. Struggling out should be easy."
	ElseIf StruggleEscapeChance >= 25
		result += "This restraint is somewhat secure, but not overly much so. Struggling out will be moderately difficult."
	ElseIf StruggleEscapeChance >= 15
		result += "This restraint is designed to be secure, but with enough patience could probably be struggled out from."
	ElseIf StruggleEscapeChance >= 10
		result += "This restraint is fairly secure and will be hard to struggle out from, but not impossible."
	ElseIf StruggleEscapeChance >= 5
		result += "This restraint is secure and will be extremely difficult to struggle out from."
	ElseIf StruggleEscapeChance > 0
		result += "This restraint is very secure and will withstand most escape attempts. Struggling out of this device will be almost impossible."
	Else
		result += "This is a high security restraint. Struggling out from this device will be completely impossible!"
	Endif
	result += " "
	If LockPickEscapeChance > 75
		result += "Its lock is weak and will not offer much resistance to pick attempts."
	ElseIf LockPickEscapeChance >= 50
		result += "Its lock is not very secure. Picking it should be easy."
	ElseIf LockPickEscapeChance >= 25
		result += "Its lock is somewhat secure, but not overly much so. Picking it will be moderately difficult."
	ElseIf LockPickEscapeChance >= 15
		result += "Its lock is designed to be secure, but might not withstand serious picking attempts."
	ElseIf LockPickEscapeChance >= 10
		result += "Its lock is fairly secure and will be hard to pick, but not impossible."
	ElseIf LockPickEscapeChance >= 5
		result += "Its lock is secure and will be extremely difficult to pick."
	ElseIf LockPickEscapeChance > 0
		result += "Its lock is very secure and will withstand most attempts to pick it."
	Else
		result += "It has a tamper proof lock. Unlocking it without the proper key will be absolutely impossible!"
	Endif
	result += " "
	If BreakDeviceEscapeChance > 75
		result += "Its material is weak and will not offer much resistance to breakting."
	ElseIf BreakDeviceEscapeChance >= 50
		result += "Its material is not very tough. Breakting it should be easy."
	ElseIf BreakDeviceEscapeChance >= 25
		result += "Its material is somewhat tough, but not overly much so. Breakting it will be moderately difficult."
	ElseIf BreakDeviceEscapeChance >= 15
		result += "Its material is tough, but could probably be break with the right tool and enough effort."
	ElseIf BreakDeviceEscapeChance >= 10
		result += "Its material is fairly tough and will be hard to break, but not impossible."
	ElseIf BreakDeviceEscapeChance >= 5
		result += "Its material is hard and will be extremely difficult to break."
	ElseIf BreakDeviceEscapeChance > 0
		result += "Its material is very hard and will withstand most attempts to break it."
	Else
		result += "Its made of material impossible to break with any tool!"
	Endif
	libs.notify(result, messageBox = true)
EndFunction

Bool Function CanMakeStruggleEscapeAttempt()
	; right now we allow escape attempts regardless of which DD devices are worn
	Float HoursNeeded = (EscapeCooldown * CalculateCooldownModifier(False))
	Float HoursPassed = (libs.GameDaysPassed.GetValue() - LastStruggleEscapeAttemptAt) * 24.0
	if HoursPassed > HoursNeeded
		LastStruggleEscapeAttemptAt = libs.GameDaysPassed.GetValue()
		return True
	Else
		Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
		If user == libs.playerRef && (HoursNeeded - HoursPassed) >= 1.0
			libs.notify("You cannot try to struggle out of this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
		elseIf user == libs.playerRef && (HoursNeeded - HoursPassed) < 1.0
			libs.notify("You cannot try to struggle out of this device so soon after the last attempt! You can try again very shortly!", messageBox = true)
		Else
			libs.notify("You cannot help " + user.GetLeveledActorBase().GetName() + " struggle out of their device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
		EndIf
	EndIf
	return False
EndFunction

Bool Function CanMakeBreakEscapeAttempt()	
	; right now we allow escape attempts regardless of which DD devices are worn
	Float HoursNeeded = (EscapeCooldown * CalculateCooldownModifier(False))
	Float HoursPassed = (libs.GameDaysPassed.GetValue() - LastBreakEscapeAttemptAt) * 24.0
	if HoursPassed > HoursNeeded
		LastBreakEscapeAttemptAt = libs.GameDaysPassed.GetValue()
		return True
	Else
		Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
		If user == libs.playerRef && (HoursNeeded - HoursPassed) >= 1.0
			libs.notify("You cannot try to break open this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
		elseIf user == libs.playerRef && (HoursNeeded - HoursPassed) < 1.0
			libs.notify("You cannot try to break open this device so soon after the last attempt! You can try again very shortly!", messageBox = true)
		Else
			libs.notify("You cannot help " + user.GetLeveledActorBase().GetName() + " to try breaking open this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
		EndIf
	EndIf
	return False
EndFunction

Bool Function CanMakeLockPickEscapeAttempt()	
	; right now we allow escape attempts regardless of which DD devices are worn
	Float HoursNeeded = (EscapeCooldown * CalculateCooldownModifier(False))
	Float HoursPassed = (libs.GameDaysPassed.GetValue() - LastLockPickEscapeAttemptAt) * 24.0
	if HoursPassed > HoursNeeded
		LastLockPickEscapeAttemptAt = libs.GameDaysPassed.GetValue()
		return True
	Else
		Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
		If user == libs.playerRef && (HoursNeeded - HoursPassed) >= 1.0
			libs.notify("You cannot try to pick this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
		elseIf user == libs.playerRef && (HoursNeeded - HoursPassed) < 1.0
			libs.notify("You cannot try to pick this device so soon after the last attempt! You can try again very shortly!", messageBox = true)
		Else
			libs.notify("You cannot help " + user.GetLeveledActorBase().GetName() + " try to pick this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
		EndIf
	EndIf
	return False
EndFunction

Bool Function Escape(Float Chance)
	StruggleScene(user)	
	If Chance == 0.0
		; no need to process, but returning here will prevent catastrophic failures when there is zero chance of success. We're not THAT mean!
		return False
	Endif
	libs.log("Player is trying/helping to escape " + DeviceName + ". Escape chance after modifiers: " + Chance +"%")
	If Utility.RandomFloat(0.0, 99.9) < (Chance * CalculateDifficultyModifier(True))
		libs.log("User has escaped " + DeviceName)
		; increase success counter
		libs.zadDeviceEscapeSuccessCount.SetValueInt(libs.zadDeviceEscapeSuccessCount.GetValueInt() + 1)				
		;libs.SendDeviceEscapeEvent(DeviceInventory, zad_DeviousDevice, true)
		return True
	Else
		libs.log("Player has failed to escape " + DeviceName)
		;libs.SendDeviceEscapeEvent(DeviceInventory, zad_DeviousDevice, false)
		if MercyEscapeAttempts > 0
			int totalattemptsmade = EscapeLockPickAttemptsMade + EscapeBreakAttemptsMade + EscapeStruggleAttemptsMade
			If totalattemptsmade >= MercyEscapeAttempts
				libs.log("Mercy escape triggered for " + DeviceName)
				return true
			EndIf
		EndIf
	EndIf
	return False
EndFunction

Function SelfBondageReward()
	if !isSelfBondage || !AllowRewardonEscape || user != libs.playerRef
		; only when it was a self bondage game with the player locked in the device. NPCs get nuthin!
		return
	EndIf
	Int i = Reward.Length
	if i > 0
		libs.notify("That was fun! Your successful effort to escape the device before the time is up will be rewarded!", messageBox = true)
	Else
		libs.notify("That was fun! You even successfully escaped the device before the time was up!", messageBox = true)
	EndIf	
	While i > 0
		i -= 1
		user.AddItem(Reward[i], 1, False)
	EndWhile
	Utility.Wait(1)
EndFunction

Function EscapeAttemptMinigame()
	if !zadcNGEscapeMinigameQuest.IsRunning()
		zadcNGEscapeMinigameQuest.Start()
	ElseIf zadcNGEscapeMinigameQuest.IsSuspended()
		zadcNGEscapeMinigameQuest.ResumeMinigame()
	EndIf
EndFunction

Function EscapeAttemptStruggle()
	If !CanMakeStruggleEscapeAttempt()
		return
	EndIf
	if user == libs.PlayerRef
		zadc_EscapeStruggleMSG.Show()		
	Else
		clib.UserRef.ForceRefTo(user)
		zadc_EscapeStruggleNPCMSG.Show()		
		clib.UserRef.Clear()		
	EndIf
	If Escape(CalclulateStruggleSuccess())	
		zadc_EscapeStruggleSuccessMSG.Show()
		SelfBondageReward()
		UnlockActor()
	Else
		; catastrophic failure will prevent further escape attempts
		if Utility.RandomFloat(0.0, 99.9) < CatastrophicFailureChance && User == libs.PlayerRef
			BaseEscapeChance = 0.0
			libs.notify("You fail to escape from your " + DeviceName + " and your feeble attempts tighten the device so much that you won't ever be able to struggle out from it.", messageBox = true)
		Else
			; regular failure
			EscapeStruggleAttemptsMade += 1
			zadc_EscapeStruggleFailureMSG.Show()			
		Endif
	EndIf
EndFunction

Float Function CalclulateStruggleSuccess()
	Float result = BaseEscapeChance
	; Apply modifiers, but only if the device is not impossible to escape from to begin with.
	If BaseEscapeChance > 0.0
		; add 1% for every previous attempt
		result += EscapeStruggleAttemptsMade		
		; apply strength bonus
		If Libs.PlayerRef.GetAV("Stamina") > 25 
			result += 1.0
		Endif
		If Libs.PlayerRef.GetAV("Stamina") > 50
			result += 2.0
		Endif
		If Libs.PlayerRef.GetAV("Stamina") > 75 
			result += 3.0
		Endif		
		; apply bonus for total successful escapes - shares that value with wearable restraints
		Int EscapesMade = libs.zadDeviceEscapeSuccessCount.GetValueInt()
		If EscapesMade > 10
			result += 1.0
		Endif
		If EscapesMade > 25
			result += 1.0
		Endif
		If EscapesMade > 50
			result += 1.0
		Endif
		If EscapesMade > 100
			result += 1.0
		Endif
	Endif
	If result < 0.0
		return 0.0
	ElseIf result > 100.0
		return 100.0
	Endif
	return result
EndFunction

Function EscapeAttemptBreak()
	If !CanMakeBreakEscapeAttempt()
		return
	EndIf

	; Suspend the minigame while lockpick escape runs. It'll resume next time player picks "struggle".
	if zadcNGEscapeMinigameQuest.IsRunning() && !zadcNGEscapeMinigameQuest.IsSuspended()
		zadcNGEscapeMinigameQuest.SuspendMinigame()
	EndIf

	zadc_EscapeBreakMSG.Show()		
	If Escape(CalclulateBreakSuccess())		
		zadc_EscapeBreakSuccessMSG.Show()	
		SelfBondageReward()		
		UnlockActor()
	Else
		; catastrophic failure will prevent further escape attempts
		if Utility.RandomFloat(0.0, 99.9) < CatastrophicFailureChance && User == libs.PlayerRef
			BreakDeviceEscapeChance = 0.0
			libs.notify("You fail to escape from your " + DeviceName + " and your feeble attempts tighten the device so much that you won't ever be able to break it open.", messageBox = true)
		Else
			; regular failure
			EscapeBreakAttemptsMade += 1		
			zadc_EscapeBreakFailureMSG.Show()			
		Endif
	EndIf
EndFunction

Float Function CalclulateBreakSuccess()
	Float result = BreakDeviceEscapeChance
	; Apply modifiers, but only if the device is not impossible to escape from to begin with.
	If BreakDeviceEscapeChance > 0.0
		; add 1% for every previous attempt
		result += EscapeBreakAttemptsMade		
		If Libs.PlayerRef.GetAV("OneHanded") > 25 || Libs.PlayerRef.GetAV("TwoHanded") > 25
			result += 1.0
		Endif
		If Libs.PlayerRef.GetAV("OneHanded") > 50 || Libs.PlayerRef.GetAV("TwoHanded") > 50
			result += 2.0
		Endif
		If Libs.PlayerRef.GetAV("OneHanded") > 75 || Libs.PlayerRef.GetAV("TwoHanded") > 75
			result += 3.0
		Endif
		; apply bonus for total successful escapes
		Int EscapesMade = libs.zadDeviceEscapeSuccessCount.GetValueInt()
		If EscapesMade > 10
			result += 1.0
		Endif
		If EscapesMade > 25
			result += 1.0
		Endif
		If EscapesMade > 50
			result += 1.0
		Endif
		If EscapesMade > 100
			result += 1.0
		Endif
	Endif
	If result < 0.0
		return 0.0
	ElseIf result > 100.0
		return 100.0
	Endif
	return result
EndFunction

Function EscapeAttemptLockPick()
	If !HasValidLockPick()
		libs.notify("You do not possess a pick you could use on the " + DeviceName + ".", messageBox = true)
		return
	EndIf	
	If !CanMakeLockPickEscapeAttempt()
		return
	EndIf
	zadc_EscapeLockPickMSG.Show()
	; first make a check against lock difficulty as you can't pick what you can't reach! The cooldown timer has already reset at this point.
	If Utility.RandomFloat(0.0, 99.9) < LockAccessDifficulty && User == libs.PlayerRef
		libs.notify("You fail to reach your " + DeviceName + "'s locks and can't attempt to pick the lock.", messageBox = true)		
		return
	EndIf

	; Suspend the minigame while lockpick escape runs. It'll resume next time player picks "struggle".
	if zadcNGEscapeMinigameQuest.IsRunning() && !zadcNGEscapeMinigameQuest.IsSuspended()
		zadcNGEscapeMinigameQuest.SuspendMinigame()
	EndIf

	If Escape(CalclulateLockPickSuccess())
		zadc_EscapeLockPickSuccessMSG.Show()
		SelfBondageReward()
		UnlockActor()
	Else
		; catastrophic failure will prevent further escape attempts
		if Utility.RandomFloat(0.0, 99.9) < CatastrophicFailureChance && User == libs.PlayerRef
			LockPickEscapeChance = 0.0
			libs.notify("You fail to escape from your " + DeviceName + " and your feeble attempts trigger a safety shield inside the lock, preventing further pick attempts.", messageBox = true)
		Else
			; regular failure
			EscapeLockPickAttemptsMade += 1
			; destroy the lockpick
			DestroyLockPick()			
			zadc_EscapeLockPickFailureMSG.Show()
		Endif
	EndIf
EndFunction

Bool Function HasValidLockPick()
	Bool HasValidItem = false
	If AllowLockPick && libs.PlayerRef.GetItemCount(libs.Lockpick) > 0
		return true
	EndIf
	Int i = AllowedLockPicks.Length
	While i > 0 && !HasValidItem
		i -= 1
		Form frm = AllowedLockPicks[i]
		If libs.playerRef.GetItemCount(frm) > 0
			HasValidItem = True
		EndIf
	EndWhile
	return HasValidItem
EndFunction

Bool Function DestroyLockPick()
	Bool LockPickDestroyed = false
	If AllowLockPick && libs.PlayerRef.GetItemCount(libs.Lockpick) > 0
		libs.playerRef.RemoveItem(libs.Lockpick)
		return True
	EndIf
	Int i = AllowedLockPicks.Length
	While i > 0 && !LockPickDestroyed
		i -= 1
		Form frm = AllowedLockPicks[i]
		If libs.playerRef.GetItemCount(frm) > 0 && !(frm As Keyword)
			libs.playerRef.RemoveItem(frm)
			LockPickDestroyed = True
		EndIf
	EndWhile
	return LockPickDestroyed
EndFunction

Float Function CalclulateLockPickSuccess()
	Float result = LockPickEscapeChance
	; Apply modifiers, but only if the device is not impossible to escape from to begin with.
	If LockPickEscapeChance > 0.0
		; add 1% for every previous attempt
		result += EscapeLockPickAttemptsMade		
		If Libs.PlayerRef.GetAV("Lockpicking") > 25
			result += 1.0
		Endif
		If Libs.PlayerRef.GetAV("Lockpicking") > 50
			result += 2.0
		Endif
		If Libs.PlayerRef.GetAV("Lockpicking") > 75
			result += 3.0
		Endif
		; apply bonus for total successful escapes
		Int EscapesMade = libs.zadDeviceEscapeSuccessCount.GetValueInt()
		If EscapesMade > 10
			result += 1.0
		Endif
		If EscapesMade > 25
			result += 1.0
		Endif
		If EscapesMade > 50
			result += 1.0
		Endif
		If EscapesMade > 100
			result += 1.0
		Endif
	Endif
	If result < 0.0
		return 0.0
	ElseIf result > 100.0
		return 100.0
	Endif
	return result
EndFunction

Function AntiCL(actor akActor)
	;; anti-collision hack. this will put the actor above the device in a state where they have no collision for a long time, longer than anyone will likely ever be in the same room with a device. same trick sexlab uses during scenes. kudos to darkconsole - krzp
	akActor.SetAngle(0.0,0.0,self.GetAngleZ())
	akActor.TranslateTo(           \
		self.GetPositionX(),       \
		self.GetPositionY(),       \
		self.GetPositionZ(),       \
		self.GetAngleX(),          \
		self.GetAngleY(),          \
		(self.GetAngleZ() + 0.01), \
		10000,0.000001             \
	)
EndFunction
