Scriptname zadPlayerScript extends ReferenceAlias
 
zadBQ00 Property questScript Auto
zadNPCQuestScript Property npcQuestScript Auto
zadCameraState Property cameraState Auto
 
zadLibs Property libs Auto
Formlist Property SitBlockKeywords Auto
Armor Property zad_DeviceHider Auto

zadGagVoices Property Voices Auto
int[] voiceslots

Function InitGagSpeak(bool firsttime)
    Utility.Wait(2.0)
    If firsttime
        libs.log("Registering Gag Voices.")
        voiceslots = new int[2]
        Voices.RegisterVoices()
    EndIf    
    Voices.RegisterVoiceEvent()
EndFunction

Event OnAnimationStart(string eventName, string argString, float argNum, form sender)
    libs.log("SL scene started: Checking for gagged voices")
    sslThreadController controller = libs.SexLab.HookController(argString)
    actor[] SceneActors = libs.SexLab.HookActors(argString)
    int i = 0
    int actor_count = SceneActors.length
    while i < actor_count
        if SceneActors[i].WornHasKeyword(libs.zad_DeviousGag)
			If SKSE.GetPluginVersion("SexLabUtil") >= 34340864 && SceneActors[i].GetActorBase().GetSex() == 1 ;p+ fix
				controller.SetVoice(SceneActors[i], libs.SexLab.GetVoiceByTags("Female,Gagged", "", True))
			ElseIf SKSE.GetPluginVersion("SexLabUtil") >= 34340864 && SceneActors[i].GetActorBase().GetSex() == 0 ;p+ fix
				controller.SetVoice(SceneActors[i], libs.SexLab.GetVoiceByTags("Male,Gagged", "", True))
			else ;regular SL way of switching voices
				controller.SetVoice(SceneActors[i], libs.SexLab.GetVoiceBySlot(voiceslots[SceneActors[i].GetActorBase().GetSex()]))
			endif
            libs.log(SceneActors[i].GetLeveledActorBase().GetName() + " is gagged. Voice changed.")
        else
            libs.log(SceneActors[i].GetLeveledActorBase().GetName() + " is not gagged.")
        endif
        i += 1
    endwhile
EndEvent

Event RegisterGagSound(string eventName, string argString, float argNum, form sender)
    If (argString=="FemaleGagged")
        voiceslots[1]=argNum as int
    ElseIf (argString=="MaleGagged")
        voiceslots[0]=argNum as int
    EndIf
EndEvent

Event OnRequestVibration(form akActor, int vibStrength, int duration, bool teaseOnly, bool silent, Bool AllowActorInScene)
	libs.VibrateEffectV2(akActor as Actor, vibStrength, duration, teaseOnly, silent, AllowActorInScene)
EndEvent

function RegisterEvents() 
    RegisterForModEvent("AnimationStart", "OnAnimationStart")
    RegisterForModEvent("GagSoundsRegistered", "RegisterGagSound")
	RegisterForModEvent("DDNG_RequestVibration", "OnRequestVibration")
EndFunction

Function RegisterKeys()
    UnregisterForAllKeys() ; In case keys were remapped, we don't want to stay registered for the old keys.

    ; Register key used for canceling animations. We use RegisterForKey because
    ; OnControlDown doesn't trigger if controls are disabled, which they are for anims.
    RegisterForKey(Input.GetMappedKey("Jump", 0))
    RegisterForKey(Input.GetMappedKey("Jump", 2))
EndFunction

Event OnKeyDown(int keyCode)
    ; Animation cancel
    if keyCode == Input.GetMappedKey("Jump", 0) || keyCode == Input.GetMappedKey("Jump", 2)
        If libs.PlayerIsInCancellableAnimation
            ; the correct pre-anim camera state is usually local to the function starting the animation, so it's hard to get.
            ; I'll just use this for now. It won't properly restore first person, but that's really a big deal.
            bool[] camState = new bool[2]
            libs.EndThirdPersonAnimation(libs.PlayerRef, camState)
            libs.PlayerIsInCancellableAnimation = false
        EndIf
    Else
        ; This can only happen if a registered key was remapped. If so, we should re-register.
        RegisterKeys()
    EndIf
EndEvent

event OnInit()
    RegisterForSingleUpdate(5.0)
endEvent

bool _initiated = false
Event OnUpdate()
    if !_initiated
        RegisterEvents()
        InitGagSpeak(true)
        _initiated = true
    endif
EndEvent

Event OnPlayerLoadGame()
    actor akActor = libs.PlayerRef
    libs.SpellCastVibrateCooldown = 0.0
    libs.ExpLibs.Maintenance()
    CheckForSoftDepends()
    questScript.Maintenance()
    cameraState.Maintenance()
    libs.ResetDialogue()
    AddInventoryEventFilter(libs.SoulgemFilled)
    If akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt)
        Utility.SetINIBool("bDampenPlayerControls:Controls", false)
    Endif
    if akActor.WornHasKeyword(libs.zad_EffectForcedWalk)
        libs.MuteOverEncumberedMSG()
    endif
    Game.UpdateHairColor()
    RegisterEvents()
    RegisterKeys()
    InitGagSpeak(false)
EndEvent

Function CheckForSoftDepends()
	If Game.IsPluginInstalled("OSLAroused.esp")
		libs.config.GotOSLA = True 		;OSL Aroused is here
	Else
		libs.config.GotOSLA = False     ;not here
	EndIf

	If Game.IsPluginInstalled("SexLab Inflation Framework.esp")
		libs.config.GotSLIF = True  ;SexLab Inflation Framework is here
	Else
		libs.config.GotSLIF = False ;not here
	EndIf

	If Game.IsPluginInstalled("DD_Animation_Overhaul_by_Taki17.esp")
		libs.Error("DDNG: 'DD_Animation_Overhaul_by_Taki17' ESP is active. This ESP is from and old version and no longer required will cause issues. Remove the ESP from your mod manager.")
	EndIf
EndFunction
 
Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if akBaseItem == libs.SoulgemFilled
        ; Replace with base item.
        If akItemReference != None && akDestContainer == None  ; Dropped
            libs.Log("Rechargeable soulgem removed: In world. Doing nothing.")
        ElseIf akDestContainer != None && (akDestContainer as Actor) != libs.PlayerRef ; Gave item to NPC.
            libs.Log("Rechargeable soulgem removed: Gave to an NPC, or stored in a chest.")
        Else
            libs.Log("Rechargeable soulgem removed: Used up. Replacing with empty.")
            libs.playerRef.AddItem(libs.SoulgemEmpty, 1, true)
            if akItemReference
                akItemReference.Delete()
            EndIf
        EndIf
    EndIf
EndEvent

Event OnSit(ObjectReference akFurniture)
    actor akActor = libs.PlayerRef
    int numKeywords = SitBlockKeywords.GetSize()
    int i = 0
    while (i < numKeywords)
        if akFurniture.HasKeyword((SitBlockKeywords.GetAt(i) as Keyword))
            libs.log(akFurniture + " contains blocked keyword " + SitBlockKeywords.GetAt(i) + ". Not OnSitting.")
            return
        EndIf
        i += 1
    endwhile

    if akFurniture.GetBaseObject().GetName() == "This Should Not Be Visible"
        ; Player is mining. No message to display!
        return
    endif
 
    if akActor.WornHasKeyword(questScript.zad_DeviousDevice)
        libs.Log("OnSit()")
        SendModEvent("EventOnSit")
        if akActor.WornHasKeyword(libs.zad_DeviousPlug)
            if akActor.WornHasKeyword(libs.zad_HasPumps) && Utility.RandomInt() <= libs.Config.BaseBumpPumpChance * 2
                libs.NotifyPlayer("You mistakenly sit down on one of the pumps dangling from your groin.")
                libs.InflateRandomPlug(akActor, 1)
            else
                libs.UpdateExposure(akActor, 0.15)
                libs.NotifyPlayer("You awkwardly sit down, doing your best to avoid disturbing the plugs inside of you.")
            EndIf
        Else
            libs.NotifyPlayer("The Chastity Belt you are wearing makes sitting down rather awkward.")
        EndIf
    EndIf
EndEvent
 
Event OnSpellCast(Form akSpell)
    if (akSpell as Spell) != none
        libs.SpellCastVibrate(libs.PlayerRef, akSpell)
    EndIf
EndEvent
 
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    ;libs.log("Location Changed: " + akNewLoc)
    if libs.config.numNpcs != 0
        libs.RepopulateNpcs()
    EndIf
EndEvent
 
bool Function isDeviousDevice(Form device)
    if device.HasKeyword(libs.zad_InventoryDevice) || device.HasKeyword(libs.zad_Lockable) || device.HasKeyword(libs.zad_DeviousPlug)
        return true
    endif
    return false
EndFunction

bool Function isStrapOn(Form device)
    if device.HasKeyword(SexLabNoStrip) && device.HasKeyword(ArmorJewelry) 
        return true
    endif
    return false
EndFunction
 
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    actor akActor = libs.PlayerRef
    if akBaseObject as Armor
        armor akArmor = (akBaseObject as Armor)
        if Math.LogicalAnd(akArmor.GetSlotMask(), 0x00000004) && !akArmor.HasKeyword(libs.zad_DeviousHarness)
            if libs.PlayerRef.WornHasKeyword(libs.zad_DeviousBra) &&  libs.PlayerRef.HasMagicEffectWithKeyword(libs.zad_EffectCompressBreasts)
                libs.ShowBreasts(libs.PlayerRef)
            EndIf
            if libs.PlayerRef.WornHasKeyword(libs.zad_DeviousCorset) && libs.PlayerRef.HasMagicEffectWithKeyword(libs.zad_EffectCompressBelly)
                libs.ShowBelly(libs.PlayerRef)
            EndIf
        EndIf
    EndIf
    ;Allow script-equipped items through as long as they're not weapons, spells or torches
    if !Utility.IsInMenuMode() && !((akBaseObject as Weapon) || (akBaseObject as Spell) || (akBaseObject as Light))
        Return
    EndIf
    ;If akActor.WornHasKeyword(libs.zad_DeviousHeavyBondage) && ((akBaseObject as Weapon) || (akBaseObject as Spell) || (akBaseObject as Light) || ((akBaseObject as Armor) && (!isDeviousDevice(akBaseObject) && !isStrapOn(akBaseObject))))
    ;    If UI.IsMenuOpen("InventoryMenu")
    ;        libs.notify("You can't equip this with your hands tied!")
    ;    Endif        
    ;    libs.playerRef.UnequipItem(akBaseObject)
    ;    while libs.hasAnyWeaponEquipped(libs.playerRef)
    ;        libs.stripweapons(libs.playerRef)
    ;    EndWhile
    ;Endif
EndEvent
 
 
Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    actor akActor = libs.PlayerRef
    if akBaseObject as Armor
        armor akArmor = (akBaseObject as Armor)
        if Math.LogicalAnd(akArmor.GetSlotMask(), 0x00000004)
            if !akArmor.HasKeyword(libs.zad_DeviousBra) && libs.PlayerRef.WornHasKeyword(libs.zad_DeviousBra) && libs.PlayerRef.HasMagicEffectWithKeyword(libs.zad_EffectCompressBreasts)
                libs.HideBreasts(libs.PlayerRef)
            EndIf
            if !akArmor.HasKeyword(libs.zad_DeviousCorset) && libs.PlayerRef.WornHasKeyword(libs.zad_DeviousCorset) && libs.PlayerRef.HasMagicEffectWithKeyword(libs.zad_EffectCompressBelly)
                libs.HideBelly(libs.PlayerRef)
            EndIf
        EndIf
    EndIf    
EndEvent

Keyword Property ArmorJewelry  Auto

Keyword Property SexLabNoStrip  Auto
