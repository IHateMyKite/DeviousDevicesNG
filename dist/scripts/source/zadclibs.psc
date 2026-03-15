Scriptname zadclibs extends Quest  

; --------------------------------------------------------------
; zadCLibs - (c) by Kimy
; --------------------------------------------------------------

zadlibs Property libs Auto
slaUtilScr Property Aroused Auto
zadcAnims Property cAnims Auto
Quest Property zadc_nearbyfurniture Auto

Keyword Property zadc_FurnitureDevice Auto
Keyword Property zadc_FurnitureKit Auto
Key Property zadc_FurnitureKey Auto
Outfit Property zadc_outfit_naked Auto
Package Property zadc_pk_donothing Auto

ReferenceAlias Property UserRef  Auto  

FormList Property zadc_CellFurnitureList Auto

Armor Property zadc_NoWaitItem Auto
Armor Property zadc_PrisonerChainsInventory Auto
Armor Property zadc_PrisonerChainsRendered Auto
Faction Property zadcNGInContraptionFaction Auto

Actor Property SelectedUser Auto Hidden

Activator Property zadc_BondageChair Auto
Activator Property zadc_BondagePole Auto
Activator Property zadc_cross Auto
Activator Property zadc_gallowspole_overhead Auto
Activator Property zadc_gallowspole_strappado Auto
Activator Property zadc_gallowspole_suspend_hogtie Auto
Activator Property zadc_gallowspole_upside_down Auto
Activator Property zadc_gallowspole_woodenhorse Auto
Activator Property zadc_Pillory Auto
Activator Property zadc_Pillory2 Auto
Activator Property zadc_RestraintPost Auto
Activator Property zadc_ShackleWallIron Auto
Activator Property zadc_TorturePole01 Auto
Activator Property zadc_TorturePole02 Auto
Activator Property zadc_TorturePole03 Auto
Activator Property zadc_TorturePole04 Auto
Activator Property zadc_TorturePole05 Auto
Activator Property zadc_WoodenHorse Auto
Activator Property zadc_xcross Auto

MiscObject Property zadc_kit_bondagechair Auto
MiscObject Property zadc_kit_bondagepost Auto
MiscObject Property zadc_kit_cross Auto
MiscObject Property zadc_kit_gallowspolehogtie Auto
MiscObject Property zadc_kit_gallowspoleoverhead Auto
MiscObject Property zadc_kit_gallowspolestrappado Auto
MiscObject Property zadc_kit_gallowspoleupsidedown Auto
MiscObject Property zadc_kit_gallowspolewoodenhorse Auto
MiscObject Property zadc_kit_pillory Auto
MiscObject Property zadc_kit_pillory2 Auto
MiscObject Property zadc_kit_restraintpost Auto
MiscObject Property zadc_kit_torturepole Auto
MiscObject Property zadc_kit_torturepole2 Auto
MiscObject Property zadc_kit_torturepole3 Auto
MiscObject Property zadc_kit_torturepole4 Auto
MiscObject Property zadc_kit_torturepole5 Auto
MiscObject Property zadc_kit_wallshackle Auto
MiscObject Property zadc_kit_woodenhorse Auto
MiscObject Property zadc_kit_xcross Auto


; MAIN API

; Checks if the given reference is a DDC furniture device
Bool Function GetIsFurnitureDevice(ObjectReference FurnitureDevice)
	return FurnitureDevice && FurnitureDevice.HasKeyword(zadc_FurnitureDevice)
EndFunction

; Returns the actor currently locked in a given device (or none if not a valid furniture device, or if it's not occupied)
Actor Function GetUser(ObjectReference FurnitureDevice)
	If !GetIsFurnitureDevice(FurnitureDevice)
		return None
	EndIf
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs && fs.User
		return fs.User
	EndIf
	return None
EndFunction

; Parameters are persitant in pex files. 2-stage function call to avoid breaking older mods.
; This is the old signature of the function, and is needed for backwards compatibility
Bool Function IsValidActor(Actor akActor)
    return IsValidActorV2(akActor, OverrideSceneCheck = false)
EndFunction

; Checks if an actor can be used for furniture placement
; Caution: Sometimes even otherwise valid actors cannot be used at a given moment, e.g. when they are animating or running a scene (which frequently happens during sandboxing)! 
; Your code wants to be able to handle that and provide fallbacks etc.
; This is the new signature of the function, and is needed for backwards compatibility
Bool Function IsValidActorV2(Actor akActor, bool OverrideSceneCheck = false)
	If !akActor || akActor.IsChild() || akActor.IsDisabled() || akActor.IsDead() || akActor.IsGhost()
		return False
	EndIf
	If !libs.SexLab.ActorLib.CanAnimate(akActor) || GetDevice(akActor) || IsAnimating(akActor) 	
		return False
	EndIf
	if akActor.GetCurrentScene() != none && OverrideSceneCheck == false
		return False
	EndIf
	return True
EndFunction

; Retrieves the furniture device the actor is currently using, if any.
ObjectReference Function GetDevice(Actor act)
	ObjectReference obj = StorageUtil.GetFormValue(act, "DDC_DeviceUsed") As ObjectReference	
	return obj
EndFunction

; Retrieves the device key
Key Function GetDeviceKey(ObjectReference FurnitureDevice)
	If !GetIsFurnitureDevice(FurnitureDevice)
		return None
	EndIf
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs 		
		return fs.DeviceKey
	EndIf
	return None
EndFunction

; Retrieves the furniture device closest to the player, if there is any in the active cell.
ObjectReference Function GetClosestFurnitureDevice()
	; need to force re/start the quest to fill the alias
	zadc_nearbyfurniture.Stop()
	zadc_nearbyfurniture.Start()

	ReferenceAlias device = zadc_nearbyfurniture.GetAlias(0) As ReferenceAlias	; That's the only alias in that quest
	If device
		Return device.GetReference()
	EndIf
	return None
EndFunction

; Retrieves the furniture device linked to the one given, if any.
ObjectReference Function GetLinkedDevice(ObjectReference FurnitureDevice, int Position)
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs && fs.LinkedDevices.Length >= Position
		return fs.LinkedDevices[Position]
	EndIf
	return None
EndFunction

; This function will return all furniture devices in the currently active cell.
; Cell scans are CPU expensive - use this when really needed!
FormList Function FindFurnitureDevicesInCell()
	zadc_CellFurnitureList.Revert()
	Cell kCell = Libs.PlayerRef.GetParentCell()
	ObjectReference o
	Int i = kCell.GetNumRefs(24) ; Activators
	While i > 0
		i -= 1
		o = kCell.GetNthRef(i, 24)
		If o.HasKeyword(zadc_FurnitureDevice)
			zadc_CellFurnitureList.AddForm(o)
		EndIf
	EndWhile
	Return zadc_CellFurnitureList
EndFunction

; Sets an override pose for the given device that will be used instead of a randomly chosen one
; The device will use the pose only if it's valid (= present in its list)!
; Mind you that you also can edit the pose list of each placed reference in the game world! This function is needed only when you want to set specific poses at runtime!
Function SetOverridePose(ObjectReference FurnitureDevice, Package pose)
	StorageUtil.SetFormValue(FurnitureDevice, "DDC_OverridePose", pose)
EndFunction

; Retrieves the override pose. Returns none if no override pose is set.
Package Function GetOverridePose(ObjectReference FurnitureDevice)	
	return StorageUtil.GetFormValue(FurnitureDevice, "DDC_OverridePose") As Package
EndFunction

; clears the override pose
Function ClearOverridePose(ObjectReference FurnitureDevice)
	StorageUtil.UnSetFormValue(FurnitureDevice, "DDC_OverridePose")
EndFunction

; Sets the timed release for a given device to x hours and activates the auto-release feature. This can also be used to renew the timer by passing ResetStartTime = True.
; Mind you that these settings may be overriden if the player is able to use the dialogue to place herself or an NPC in the device -after- this
; function was called, but she cannot after the subject was placed in the device. Use it accordingly.
Function SetTimedRelease(ObjectReference FurnitureDevice, Int Hours, Bool ResetStartTime = False)
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs 
		fs.isSelfBondage = True
		fs.SelfBondageReleaseTimer = Hours
		if ResetStartTime
			fs.ReleaseTimerStartedAt = libs.GameDaysPassed.GetValue()
		EndIf
	EndIf
EndFunction

; Parameters are persitant in pex files. 2-stage function call to avoid breaking older mods.
; This is the old signature of the function, and is needed for backwards compatibility
Bool Function LockActor(Actor akActor, ObjectReference FurnitureDevice, Package OverridePose = None)
	return LockActorV2(akActor, FurnitureDevice, OverridePose, AllowActorInScene = false)
EndFunction

; Locks an actor into a given device, using a specific pose, if given one, or a random one, if not.
; This function will fail if called for an invalid or busy actor. If you aren't sure, use IsValidActor() BEFORE calling this function!
; Return True if the actor got placed in the device, false otherwise.
; This is the new signature of the function, and is needed for backwards compatibility
Bool Function LockActorV2(Actor akActor, ObjectReference FurnitureDevice, Package OverridePose = None, Bool AllowActorInScene = false)
	If !IsValidActorV2(akActor, AllowActorInScene) || !GetIsFurnitureDevice(FurnitureDevice)
		return False
	Endif
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if !fs || fs.User		
		return False
	EndIf
	If OverridePose
		SetOverridePose(FurnitureDevice, OverridePose)
	EndIf
	fs.LockActor(akActor)
	If OverridePose
		ClearOverridePose(FurnitureDevice)
	EndIf
	Return True
EndFunction

; Unlock an actor. This bypasses all checks normally performed (e.g. keys or lock shields)
Function UnlockActor(Actor akActor)
	zadcFurnitureScript fs = GetDevice(akActor) as zadcFurnitureScript
	if fs && fs.User		
		fs.UnlockActor()		
	EndIf
EndFunction

; Does what it says, haha! In case the device actually HAS a sex scene, and most don't.
; AnimationName can be used to force a specific animation. It's up to the coder to make sure it's valid.
; This feature assumes the user of the device to be female.
Bool Function PlaySexScene(Actor User, Actor Partner, String AnimationName = "")
	If user.WornHasKeyword(libs.zad_DeviousBelt) || !GetIsFemale(User)
		;respect belts and make sure it's a girl
		return false
	EndIf
	zadcFurnitureScript fs = GetDevice(User) as zadcFurnitureScript
	if fs && fs.User && fs.SexAnimations.Length > 0
		if fs.SexScene(Partner, AnimationName)		
			return true
		Endif
	EndIf
	Return false
EndFunction

; Check if a device can be transported
Bool Function GetIsTransportable(ObjectReference FurnitureDevice)
	If !GetIsFurnitureDevice(FurnitureDevice)
		return False
	EndIf
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs && fs.CanBePickedUp
		return true
	EndIf
	return false
EndFunction

; Check if a device has a blueprint (building kit) defined
Bool Function GetHasBlueprint(ObjectReference FurnitureDevice)
	If !GetIsFurnitureDevice(FurnitureDevice)
		return False
	EndIf
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs && fs.Blueprint != None
		return true
	EndIf
	return false
EndFunction

; Returns the device blueprint, if any.
MiscObject Function GetBlueprint(ObjectReference FurnitureDevice)
	If !GetIsFurnitureDevice(FurnitureDevice)
		return None
	EndIf
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs && fs.Blueprint != None
		return fs.Blueprint
	EndIf
	return None
EndFunction

; Mark a device as transportable. Returns true if the function completed successfully.
Bool Function SetIsTransportable(ObjectReference FurnitureDevice)
	If !GetIsFurnitureDevice(FurnitureDevice)
		return False
	EndIf
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs 
		fs.CanBePickedUp = True
		return true
	EndIf
	return false
EndFunction

; Set a blueprint (building kit) for a device. Returns true if a blueprint was set.
Bool Function SetBlueprint(ObjectReference FurnitureDevice, MiscObject Blueprint)
	If !GetIsFurnitureDevice(FurnitureDevice) || !Blueprint.HasKeyword(zadc_FurnitureKit)
		return False
	EndIf
	zadcFurnitureScript fs = FurnitureDevice as zadcFurnitureScript
	if fs 
		fs.Blueprint = Blueprint
		return true
	EndIf
	return false
EndFunction

; builds an instance of the given furniture device in the world and returns the new instance.
ObjectReference Function BobTheBuilder(Activator FurnitureToBuild, ObjectReference WhereToBuild = None)
	If !WhereToBuild
		WhereToBuild = Libs.PlayerRef
	EndIf
	CloseMenus()
	ObjectReference newFurniture = WhereToBuild.PlaceAtMe(FurnitureToBuild, 1, True, False)
	AlignObject(newFurniture, WhereToBuild)
	Utility.Wait(0.5)
	MoveObjectByVector(WhereToBuild, newFurniture, 100.0)
	(newFurniture as zadcFurnitureScript).CanBePickedUp = True ; If you can place it, you should be able to pick it back up as well.
	libs.Log("Placed contraption " + newFurniture.GetBaseObject().GetName() + " in cell " + newFurniture.GetParentCell() + " at location (" + newFurniture.X + " " + newFurniture.Y + " " + newFurniture.Z + ").")
	return newFurniture
EndFunction

; INTERNAL FUNCTIONS - should normally not be called from outsides the framework.

Event OnInit()
    RegisterForSingleUpdate(10.0)
EndEvent

bool _initiated = false
Event OnUpdate()
    if !_initiated
        InitLibrary()
        _initiated = true
    endif
EndEvent

Function InitLibrary()
	RegisterForModEvent("zad_RegisteredMCMKeys", "OnRegisterMCMKeys")
	UnregisterForAllKeys()	
	RegisterForKey(libs.Config.FurnitureNPCActionKey)	
	cAnims.LoadAnimations()
	; RegisterForKey(0xD1) ; test key
	; debug.notification("DDC Init complete")
EndFunction

Event OnRegisterMCMKeys(string eventName, string strArg, float numArg, Form sender)
	; This is called by DDI MCM when the user changes the hotkey
	UnregisterForAllKeys()	
	RegisterForKey(libs.Config.FurnitureNPCActionKey)	
EndEvent

Function Reinitialize()
	self.Reset()
	Utility.Wait(0.5)
	self.Stop()
	Utility.Wait(0.5)
	self.Start()
EndFunction

Event OnKeyDown(Int KeyCode)		
	If UI.IsMenuOpen("Console") || UI.IsMenuOpen("Console Native UI Menu")
		Return
	EndIf

	FurnitureAction()

	;If (KeyCode == 0xD1) 
	;	Test()
	;Endif	
EndEvent

Bool Function GetIsFemale(Actor act)
	return (act.GetLeveledActorBase().GetSex() == 1)
EndFunction

Function Test()
	Actor usr = Game.GetCurrentCrosshairRef() As Actor
	PlaySexScene(usr, libs.PlayerRef)
	Return
	Reinitialize()
	Return
	Utility.Wait(1)
	FindFurnitureDevicesInCell()
	libs.notify("Found: " + zadc_CellFurnitureList.GetSize() + " devices!")	
	LockActor(libs.playerref, zadc_CellFurnitureList.GetAt(0) As ObjectReference)	
	;libs.notify("Device Name: " + GetClosestFurnitureDevice().GetBaseObject().GetName())
	return
	ObjectReference objr = Game.GetCurrentCrosshairRef()	
	Actor act = objr As Actor	
	If act == libs.PlayerRef
		; sanity check
		return
	EndIf	
	libs.equipDevice(act, libs.gagBall, libs.gagBallRendered, libs.zad_DeviousGag, skipmutex = true)
	libs.equipDevice(act, libs.zad_armBinderHisec_Inventory, libs.zad_armBinderHisec_Rendered, libs.zad_DeviousHeavyBondage, skipmutex = true)
	libs.equipDevice(act, libs.collarRestrictive, libs.collarRestrictiveRendered, libs.zad_DeviousCollar, skipmutex = true)
EndFunction

; checks if this person is available for a scene
bool Function IsAnimating(actor akActor)
	return akActor.IsOnMount() || (akActor.IsInFaction(libs.zadAnimatingFaction) || akActor.IsInFaction(libs.Sexlab.AnimatingFaction))
EndFunction

; Parameters are persitant in pex files. 2-stage function call to avoid breaking older mods.
; This is the old signature of the function, and is needed for backwards compatibility
Function FurnitureAction()
	return FurnitureActionV2(AllowActorInScene = false)
EndFunction

; Player interactions - locking and releasing NPCs
; This is the new signature of the function, and is needed for backwards compatibility
Function FurnitureActionV2(Bool AllowActorInScene = false)
	ObjectReference objr = Game.GetCurrentCrosshairRef()
	Actor act = objr As Actor	
	If act == libs.PlayerRef
		; sanity check
		return
	EndIf	
	If objr.HasKeyword(zadc_FurnitureDevice) && SelectedUser
		If !GetUser(objr)
			debug.notification("Locking " + SelectedUser.GetActorBase().GetName() + " into device.")				
			objr.Activate(SelectedUser)		
			return
		Else
			debug.notification("This device is occupied.")				
		EndIf
	EndIf
	;If objr.HasKeyword(zadc_FurnitureDevice) && !SelectedUser
		; no actor selected, so we can manipulate the device instead!
		
	;EndIf
	If act
		; Is the target locked in a device?
		objr = GetDevice(act)
		If objr
			; yes, display the unlock NPC dialogue
			debug.notification("Freeing " + act.GetActorBase().GetName())
			; sending the player as operator, so the furniture script can tell freeing the user apart from an escape attempt!
			objr.Activate(libs.PlayerRef)
			return
		EndIf
		If !SelectedUser				
			; Make him or her the new target
			if !IsValidActorV2(act,AllowActorInScene)
				debug.notification(act.GetLeveledActorBase().GetName() + " is invalid or busy.")				
				return
			EndIf
			SelectedUser = act
			debug.notification("Selected " + act.GetActorBase().GetName() + " for furniture placement.")
			ActorUtil.AddPackageOverride(SelectedUser, zadc_pk_donothing, 95)	
			SelectedUser.EvaluatePackage()
			If !SelectedUser.WornHasKeyword(libs.zad_DeviousHeavyBondage) && !SelectedUser.WornHasKeyword(libs.zad_DeviousLegCuffs) && !SelectedUser.WornHasKeyword(libs.zad_DeviousArmCuffs) && GetIsFemale(SelectedUser)
				; we slap some chains on them to show them who's boss.
				libs.equipDevice(SelectedUser, zadc_PrisonerChainsInventory, zadc_PrisonerChainsRendered, libs.zad_DeviousHeavyBondage, skipmutex = true)
			EndIf			
			return			
		Else
			; There is an existing target
			If SelectedUser == act 
				; if the player clicked on the same target twice, they want to remove the package and do nothing else.
				debug.notification("Unselected " + act.GetActorBase().GetName() + " for furniture placement.")
				If SelectedUser.IsEquipped(zadc_PrisonerChainsRendered)
					libs.removeDevice(SelectedUser, zadc_PrisonerChainsInventory, zadc_PrisonerChainsRendered, libs.zad_DeviousHeavyBondage, destroydevice = true, skipmutex = true)
					Utility.Wait(1)
				EndIf
				ActorUtil.RemovePackageOverride(SelectedUser, zadc_pk_donothing)
				SelectedUser.EvaluatePackage()
				SelectedUser = None
				return
			Else
				; clicked on a different actor: Check if they are valid, remove package from previous target when they are, and make them the new target.
				if !IsValidActorV2(act, AllowActorInScene)
					debug.notification(act.GetLeveledActorBase().GetName() + " is invalid or busy.")				
					return
				EndIf
				; we remove the old target's bindings later, to avoid chances of the new one getting busy in the meantime.
				Actor OldTarget = SelectedUser
				SelectedUser = act
				debug.notification("Selected " + act.GetActorBase().GetName() + " for furniture placement.")
				ActorUtil.AddPackageOverride(SelectedUser, zadc_pk_donothing, 95)	
				SelectedUser.EvaluatePackage()
				If !SelectedUser.WornHasKeyword(libs.zad_DeviousHeavyBondage) && !SelectedUser.WornHasKeyword(libs.zad_DeviousLegCuffs) && !SelectedUser.WornHasKeyword(libs.zad_DeviousArmCuffs) && GetIsFemale(SelectedUser)
					; we slap some chains on them to show them who's boss.
					libs.equipDevice(SelectedUser, zadc_PrisonerChainsInventory, zadc_PrisonerChainsRendered, libs.zad_DeviousHeavyBondage, skipmutex = true)
				EndIf				
				If OldTarget.IsEquipped(zadc_PrisonerChainsRendered)
					libs.removeDevice(OldTarget, zadc_PrisonerChainsInventory, zadc_PrisonerChainsRendered, libs.zad_DeviousHeavyBondage, destroydevice = true, skipmutex = true)
				EndIf
				ActorUtil.RemovePackageOverride(OldTarget, zadc_pk_donothing)
				OldTarget.EvaluatePackage()
				Return
			EndIf						
		EndIf		
	EndIf			
EndFunction

Function CloseMenus()
	Game.DisablePlayerControls()
	Game.EnablePlayerControls()
EndFunction

Function AlignObject(ObjectReference ObjectToAlign, ObjectReference ObjectToAlignWith)
	ObjectToAlign.MoveTo(ObjectToAlignWith)
	ObjectToAlign.SetAngle(0, ObjectToAlignWith.GetAngleY(), ObjectToAlignWith.GetAngleZ())		
EndFunction

Function MoveObjectByVector(ObjectReference ObjectToMove, ObjectReference ObjectToMoveFrom, Float Distance = 100.0)	
	; I borrowed this function from darkconsole's DM2. It's neat!
	Float Angle = ObjectToMoveFrom.GetAngleZ()
	Float X
	Float Y
	If Angle < 90
		Angle = 90 - Angle
	Else
		Angle = 450 - Angle
	EndIf
	X = Math.Sin(Angle) * Distance
	Y = Math.Cos(Angle) * Distance
	ObjectToMove.MoveTo(ObjectToMoveFrom, X, Y, 0.0, False)
EndFunction

; Strips an actor naked and stores their stuff for later retrieval.
Function StripOutfit(Actor akActor)		
	if akActor != libs.PlayerRef
		ActorBase actB = akActor.GetLeveledActorBase()	
		StorageUtil.SetFormValue(akActor, "DDC_Outfit1", actB.GetOutfit(0))
		StorageUtil.SetFormValue(akActor, "DDC_Outfit2", actB.GetOutfit(1))
		actB.SetOutfit(zadc_outfit_naked, 0)
		actB.SetOutfit(zadc_outfit_naked, 1)	
	EndIf
	If(StorageUtil.FormListCount(akActor, "DCC_Gear") > 0)		
		Return
	EndIf	
	Form[] Gear = libs.SexLab.StripActor(akActor, doanimate = False, leadin = False)
	Int i = 0
	While (i < Gear.Length)
		StorageUtil.FormListAdd(akActor, "DCC_Gear", Gear[i], True)
		i += 1
	EndWhile	
EndFunction

; Redresses an actor
Function RestoreOutfit(Actor akActor)		
	if akActor != libs.PlayerRef
		ActorBase actB = akActor.GetLeveledActorBase()	
		Outfit Outfit1 = StorageUtil.GetFormValue(akActor, "DDC_Outfit1") as Outfit
		Outfit Outfit2 = StorageUtil.GetFormValue(akActor, "DDC_Outfit2") as Outfit
		If Outfit1	
			actB.SetOutfit(Outfit1, 0)		
		EndIf
		If Outfit2
			actB.SetOutfit(Outfit2, 1)
		EndIf
		Int Count = Outfit1.GetNumParts()
		While Count > 0
			akActor.EquipItem(Outfit1.GetNthPart(Count - 1))
			Count -= 1
		EndWhile
	EndIf	
	If(StorageUtil.FormListCount(akActor, "DCC_Gear") == 0)	
		Return
	EndIf
	libs.SexLab.UnstripActor(akActor, StorageUtil.FormListToArray(akActor, "DCC_Gear"), False)
	StorageUtil.FormListClear(akActor, "DCC_Gear")	
EndFunction

Function ClearDevice(Actor act)
	StorageUtil.UnSetFormValue(act, "DDC_DeviceUsed")
EndFunction

Function StoreDevice(Actor act, ObjectReference obj)
	StorageUtil.SetFormValue(act, "DDC_DeviceUsed", obj)
EndFunction

; This function handles restraints compatibility with all DD devices. It's quest safe, because we're hiding only the visible DD item, which won't trigger the events. Which means we can happily use it even for quest devices.
; It can either hide everything (Force = true) or just select devices based on the Keyword list passed.
; If you develop mods that sometimes desire to temporarily remove DD items and are now tempted to use this code - think twice before borrowing it. The item states are technically broken when the rendered item is missing.
; This will work ONLY in tightly controlled situations when the player will not to be able to access the inventory, such as in scenes or animations. Otherwise really bad things might happen. 
; If the player clicks a DD device, the framework will think the item states are broken and attempt to fix it. Not good!
; Also, the modder will NEED to make sure that the items get reapplied.
 
Function StoreBondage(Actor akActor, Keyword[] InvalidDevices, Bool Force = False)		
	if !akActor.WornHasKeyword(libs.zad_Lockable)
		; nothing to do
		return
	EndIf
	Form Item
	Bool NeedsAAReset = False
	int i = 31
	while i >= 0		
		Item = akActor.GetWornForm(Armor.GetMaskForSlot(i + 30))
		if Item && Item.HasKeyword(libs.zad_Lockable)		
			; it's a DD device, so let's see if it's invalid
			If Force
				akActor.UnequipItem(Item, false, true)
				StorageUtil.FormListAdd(akActor, "DDC_StoredBondage", Item, True)					
				If Item.HasKeyword(libs.zad_DeviousHeavyBondage) || Item.HasKeyword(libs.zad_DeviousHobbleSkirt) || Item.HasKeyword(libs.zad_DeviousPonyGear)
					; Items with AA need AA resets when they are removed.
					NeedsAAReset = True
				EndIf
				If Item.HasKeyword(libs.zad_DeviousGag)
					; if the actor is wearing a gag, she gets temporarily relieved from having her mouth forced open. Well, in return she gets locked in a furniture device, so not sure if that's better! :D 
					libs.RemoveGagEffect(akActor)
				EndIf
			Else
				int z = InvalidDevices.Length
				while z > 0
					z -= 1
					If Item.HasKeyword(InvalidDevices[z])
						; it's invalid, so let's hide it
						akActor.UnequipItem(Item, false, true)
						StorageUtil.FormListAdd(akActor, "DDC_StoredBondage", Item, True)					
						If Item.HasKeyword(libs.zad_DeviousHeavyBondage) || Item.HasKeyword(libs.zad_DeviousHobbleSkirt) || Item.HasKeyword(libs.zad_DeviousPonyGear)
							; Items with AA need AA resets when they are removed.
							NeedsAAReset = True
						EndIf
					EndIf					
				EndWhile
			EndIf
		EndIf
		i -= 1
	endWhile
	; The DD system sets AA based on worn keywords, so we can just make it reevaluate what's still worn and it will work! \o/
	If NeedsAAReset
		; hm, leaving the AA on doesn't seem to mess up their animation graph. I will just disable this to save some CPU time. Can always uncomment it if it doesn't work...
		;libs.BoundCombat.EvaluateAA(akActor)		
	EndIf		
EndFunction

Function RestoreBondage(Actor akActor)	
	Bool NeedsAAReset = False
	int i = StorageUtil.FormListCount(akActor, "DDC_StoredBondage")
	while i > 0
		i -= 1
		Armor item = StorageUtil.FormListGet(akActor, "DDC_StoredBondage", i) as Armor
		if item
			akActor.EquipItem(item, true, true)
			If Item.HasKeyword(libs.zad_DeviousHeavyBondage) || Item.HasKeyword(libs.zad_DeviousHobbleSkirt) || Item.HasKeyword(libs.zad_DeviousPonyGear)
				; Items with AA need AA resets when they are re-equipped.
				NeedsAAReset = True
			EndIf
		endif
	endwhile
	StorageUtil.FormListClear(akActor, "DDC_StoredBondage")
	If NeedsAAReset
		libs.BoundCombat.EvaluateAA(akActor)
	EndIf
EndFunction

Function SetNiOverrideOverride(Actor aktarget)
	String NINODE_ROOT = "NPC" 
	String NIOO_KEY = "DDC" 
	; need to override NiOverride... Yes, we're really overriding an override. Fun!
	Int isFemale = aktarget.GetLeveledActorBase().GetSex()
	If NiOverride.HasNodeTransformPosition(aktarget, False, isFemale, NINODE_ROOT, "internal")
		Float[] pos = NiOverride.GetNodeTransformPosition(aktarget, false, isFemale, NINODE_ROOT, "internal")
		pos[0] = -pos[0]
		pos[1] = -pos[1]
		pos[2] = -pos[2]
		NiOverride.AddNodeTransformPosition(aktarget, False, isFemale, NINODE_ROOT, NIOO_KEY, pos)
		NiOverride.UpdateNodeTransform(aktarget, False, isFemale, NINODE_ROOT)		
	EndIf
EndFunction

Function ResetNiOverrideOverride(Actor aktarget)
	String NINODE_ROOT = "NPC" 
	String NIOO_KEY = "DDC" 
	Int isFemale = akTarget.GetLeveledActorBase().GetSex()
	If NiOverride.HasNodeTransformPosition(akTarget, False, isFemale, NINODE_ROOT, NIOO_KEY)
		NiOverride.RemoveNodeTransformPosition(akTarget, False, isFemale, NINODE_ROOT, NIOO_KEY)
		NiOverride.UpdateNodeTransform(akTarget, False, isFemale, NINODE_ROOT)
	EndIf
EndFunction

