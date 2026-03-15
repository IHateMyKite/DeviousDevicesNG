ScriptName zadx_HobbleSkirtEffectScript extends ActiveMagicEffect

; Libraries
zadLibs Property Libs Auto

bool MuJointFixneedsreset

String Property NINODE_ROOT = "NPC" AutoReadOnly Hidden
String Property NIOO_KEY = "DDPET" AutoReadOnly Hidden

Actor who
Keyword Property zad_DeviousHobbleSkirtRelaxed Auto	;extreme or relaxed speed debuff
GlobalVariable REQExhaustion	;Requiem setting responsible for its exhaustion slowdown, disabled while the dress is worn
float REQSavedVal				;Saved value of the setting, returned once the dress is unequipped

bool Function GetRequiem()
	If Game.GetModByName("Requiem.esp") != 255
		REQExhaustion = (Game.GetFormFromFile(0x0336AD6A, "Requiem.esp") as GlobalVariable)
		libs.Log("GetRequiem(): Hobble Skirt == true. Switching to Requiem compatibility mode.")
		return True
	Else
		return False
	Endif
EndFunction

Function ApplySM(actor akTarget)
	akTarget.DamageActorValue("CarryWeight", 0.02)
	akTarget.RestoreActorValue("CarryWeight", 0.02)
EndFunction

Event OnEffectStart(Actor akTarget, Actor akCaster)
	libs.Log("OnEffectStart(): Hobble Skirt")	
	MuJointFixneedsreset = False
	If akTarget.WornHasKeyword(libs.zad_DeviousPetSuit) 
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
		; need to disable mujointfix's joint fix to fix player joint
		If SKSE.GetPluginVersion("MuJointFix") != -1
			MuJointFixUtil.ToggleFixes(akTarget, 1, false)
			MuJointFixneedsreset = True
		EndIf
	EndIf
	
    If !akTarget.WornHasKeyword(zad_DeviousHobbleSkirtRelaxed)
	; relaxed skirts do not use special animations, but the extreme ones do.
		libs.BoundCombat.Apply_HBC(akTarget)
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	libs.Log("OnEffectFinish(): Hobble Skirt")
	
	If GetRequiem() == True && akTarget == Libs.PlayerRef
		REQExhaustion.SetValue(REQSavedVal)
	Else
		akTarget.UnRegisterForUpdate()
	Endif

	If MuJointFixneedsreset == True
		MuJointFixUtil.ToggleFixes(akTarget, 1, true)
	EndIf

	Int isFemale = akTarget.GetLeveledActorBase().GetSex()
	If NiOverride.HasNodeTransformPosition(akTarget, False, isFemale, NINODE_ROOT, NIOO_KEY)
		NiOverride.RemoveNodeTransformPosition(akTarget, False, isFemale, NINODE_ROOT, NIOO_KEY)
		NiOverride.UpdateNodeTransform(akTarget, False, isFemale, NINODE_ROOT)
	EndIf
		
	If !akTarget.WornHasKeyword(zad_DeviousHobbleSkirtRelaxed)
		libs.BoundCombat.EvaluateAA(akTarget)		
	EndIf
EndEvent

Event OnUpdate()
	If who.WornHasKeyword(libs.zad_DeviousPetSuit) 
		Int isFemale = who.GetLeveledActorBase().GetSex()
		If !NiOverride.HasNodeTransformPosition(who, False, isFemale, NINODE_ROOT, "internal") && NiOverride.HasNodeTransformPosition(who, False, isFemale, NINODE_ROOT, NIOO_KEY) 		
			If NiOverride.HasNodeTransformPosition(who, False, isFemale, NINODE_ROOT, NIOO_KEY)
				NiOverride.RemoveNodeTransformPosition(who, False, isFemale, NINODE_ROOT, NIOO_KEY)
				NiOverride.UpdateNodeTransform(who, False, isFemale, NINODE_ROOT)
			EndIf		
		ElseIf NiOverride.HasNodeTransformPosition(who, False, isFemale, NINODE_ROOT, "internal") && !NiOverride.HasNodeTransformPosition(who, False, isFemale, NINODE_ROOT, NIOO_KEY) 
			; need to override NiOverride... Yes, we're really overriding an override. Fun!		
			If NiOverride.HasNodeTransformPosition(who, False, isFemale, NINODE_ROOT, "internal")
				Float[] pos = NiOverride.GetNodeTransformPosition(who, false, isFemale, NINODE_ROOT, "internal")
				pos[0] = -pos[0]
				pos[1] = -pos[1]
				pos[2] = -pos[2]
				NiOverride.AddNodeTransformPosition(who, False, isFemale, NINODE_ROOT, NIOO_KEY, pos)
				NiOverride.UpdateNodeTransform(who, False, isFemale, NINODE_ROOT)			
			EndIf		
		EndIf
	EndIf
	who.RegisterForSingleUpdate(5.0)
EndEvent
