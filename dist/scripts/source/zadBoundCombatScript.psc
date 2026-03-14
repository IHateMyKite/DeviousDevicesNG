Scriptname zadBoundCombatScript Extends Quest Hidden

;
; A huge thanks to Cedec0 for both the animations, and the logic powering armbinder combat.
;

zadLibs Property libs Auto
zadConfig Property config Auto

; AI Objects
Package Property NPCBoundCombatPackage Auto
Package Property NPCBoundCombatPackageSandbox Auto
Spell Property ArmbinderDebuff Auto

FormList Property zad_List_BCPerks Auto

Function UpdateValues() 

EndFunction


Function CONFIG_ABC()

EndFunction


Function Maintenance_ABC()

EndFunction


;INTERNAL UTILITIES


bool Function HasCompatibleDevice(actor akActor)
	return (akActor.WornHasKeyword(libs.zad_DeviousHeavyBondage) || akActor.WornHasKeyword(libs.zad_DeviousPonyGear) || (akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt) && !akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)))
EndFunction


Int Function GetPrimaryAAState(actor akActor)
	If akActor.WornHasKeyword(libs.zad_DeviousPetSuit)	
		return 7	; Wearing pet suit
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousElbowTie)
		return 6	; Elbow tie (elbow only, no wrists)
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousCuffsFront)
		return 5	; Wearing frontcuffs
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousYokeBB)
		return 4	; Wearing BByoke
	Elseif akActor.WornHasKeyword(libs.zad_DeviousArmBinderElbow)
		return 3	; Wearing elbowbinder
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousYoke)
		return 2	; Wearing yoke
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousArmBinder)
		return 1	; Wearing armbinder
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousStraitJacket)
		return 1	; Wearing straightjacket
	Else
		return 0	; No primary AA modifiers
	Endif
EndFunction


Int Function GetSecondaryAAState(actor akActor)
	If akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt) && !akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
		return 1	; Wearing hobble skirt
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousPonyGear)
		return 2	; Pony device
	Else
		return 0	; No secondary AA modifiers
	Endif
EndFunction


Int Function SelectAnimationSet(actor akActor)
	return 0
EndFunction


;API FUNCTIONS
;These can be called by external sources to apply or remove animations
;EvaluateAA automatically chooses the correct animation set or reverts to default (including compatible AA mods, if applicable) based on equipped devices


Function EvaluateAA(actor akActor)
	libs.log("EvaluateAA(" + akActor + ")")
	
	if akActor == libs.playerRef
		libs.UpdateControls()
	endIf
	
	; Check if actor doesnt have drawn weapon, as calling animation event will otherwise break the character weapon state!
	if !libs.IsAnimating(akActor) && !akActor.isDead() && !akActor.IsWeaponDrawn() && !akActor.GetActorValue("Paralysis")
		Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
	EndIf
	
	If !HasCompatibleDevice(akActor)
		libs.log("EvaluateAA: Reverting to unbound AA")		
		ClearAA(akActor)
		RemoveBCPerks(akActor)
    if (akActor == libs.PlayerRef)
		  libs.DisableVA()
		EndIf
	Else
    if (akActor == libs.PlayerRef)
		  libs.EnableVA()
		EndIf
		ApplyBCPerks(akActor)	
	endif
EndFunction

Function ClearAA(actor akActor)
	if akActor != libs.PlayerRef && !akActor.isDead() && !akActor.GetActorValue("Paralysis")
		akActor.EvaluatePackage()
		if !libs.IsAnimating(akActor) 
			Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
		EndIf
	EndIf
EndFunction


Function ResetExternalAA(actor akActor)

EndFunction

Function ApplyBCPerks(Actor akActor)
	If Libs.Config.UseBoundCombatPerks == False
		return
	EndIf
	Int i = zad_List_BCPerks.GetSize()
	While i > 0
		i -= 1
		akActor.AddPerk(zad_List_BCPerks.GetAt(i) As Perk)
	EndWhile
EndFunction

Function RemoveBCPerks(Actor akActor)
	Int i = zad_List_BCPerks.GetSize()
	While i > 0
		i -= 1
		akActor.RemovePerk(zad_List_BCPerks.GetAt(i) As Perk)
	EndWhile
EndFunction

;NPC MANAGEMENT
;These are all the hacky measures we use to pretend that NPCs can use our devices... if they feel like it
; depreciated as of 4.1 - NPC feel like wearing our devices well enough, as soon as you code it right...

Function Apply_NPC_ABC(actor akActor)
	return
	libs.Log("Apply_NPC_ABC( " + akActor.GetLeveledActorBase().GetName() + ", UnarmedDamage: " + akActor.GetActorValue("UnarmedDamage") + " )")
	ActorUtil.AddPackageOverride(akActor, NPCBoundCombatPackageSandbox, 100)
	StorageUtil.FormListAdd(libs.zadNPCQuest, "BoundCombatActors", akActor, true)
	ActorUtil.AddPackageOverride(akActor, NPCBoundCombatPackage, 100)
	akActor.AddSpell(ArmbinderDebuff)
EndFunction


Function Remove_NPC_ABC(actor akActor)
	return
	libs.Log("Removing NPC Bound Combat Package")
	akActor.RemoveSpell(ArmbinderDebuff)
	ActorUtil.RemovePackageOverride(akActor, NPCBoundCombatPackage)
	StorageUtil.FormListRemove(libs.zadNPCQuest, "BoundCombatActors", akActor, true)
EndFunction


Function CleanupNPCs()
	return
	int i = StorageUtil.FormListCount(libs.zadNPCQuest, "BoundCombatActors")
	while (i > 0)
		i = i - 1
		Actor akActor = StorageUtil.FormListGet(libs.zadNPCQuest, "BoundCombatActors", i) as Actor
		if !akActor
			StorageUtil.FormListRemoveAt(libs.zadNPCQuest, "BoundCombatActors", i)
		ElseIf libs.IsValidActor(akActor) && !akActor.WornHasKeyword(libs.zad_DeviousHeavyBondage)
			Remove_NPC_ABC(akActor)
		EndIf
	EndWhile
EndFunction


;OLD FUNCTIONS, no longer used as of version 3.4.0
;Only EvaluateAA should be used directly, Apply_ABC and Remove_ABC no longer have independent functionality and should be considered depreciated


Function Apply_ABC(actor akActor)
	libs.log("Apply_ABC(akActor) is depreciated, please use EvaluateAA(akActor) instead!")
	EvaluateAA(akActor)
EndFunction


Function Remove_ABC(actor akActor)
	libs.log("Remove_ABC(akActor) is depreciated, please use EvaluateAA(akActor) instead!")
	EvaluateAA(akActor)
EndFunction


Function Apply_HBC(actor akActor)
	libs.log("Apply_HBC(akActor) is depreciated, please use EvaluateAA(akActor) instead!")
	EvaluateAA(akActor)
EndFunction


Function Remove_HBC(actor akActor)
	libs.log("Remove_HBC(akActor) is depreciated, please use EvaluateAA(akActor) instead!")
	EvaluateAA(akActor)
EndFunction
