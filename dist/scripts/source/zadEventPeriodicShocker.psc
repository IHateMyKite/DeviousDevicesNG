scriptName zadEventPeriodicShocker extends zadBaseLinkedEvent

bool Function HasKeywords(actor akActor)
	return libs.ActorHasKeyword(akActor, libs.zad_EffectShocking)
EndFunction

Function Execute(actor akActor)
	if akActor == libs.playerRef
		armor vPlug = StorageUtil.GetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(libs.zad_DeviousPlugVaginal) + "_Rendered") as Armor
		armor vPiercing = StorageUtil.GetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(libs.zad_DeviousPiercingsVaginal) + "_Rendered") as Armor
		if vPiercing && (vPiercing.HasKeyword(libs.zad_EffectShocking))
			libs.NotifyPlayer("Your piercings let out a painful jolt!")
			libs.Log("zadEventPeriodicShocker: vPiercing")
		ElseIf vPlug && (vPlug.HasKeyword(libs.zad_EffectShocking))
			libs.NotifyPlayer("The plug within you let out a painful jolt!")
			libs.Log("zadEventPeriodicShocker: vPlug")
		Else
			libs.NotifyPlayer("A painful jolt courses through you!")
			libs.Log("zadEventPeriodicShocker: generic")
		EndIf
	Else
		libs.NotifyNPC(akActor.GetLeveledActorBase().GetName() + " squirms uncomfortably as a painful jolt courses through her!")
	EndIf
	libs.ShockEffect.RemoteCast(akActor, akActor, akActor)
	libs.Aroused.UpdateActorExposure(akActor, (-1 * Utility.RandomInt(10,20)))
EndFunction
