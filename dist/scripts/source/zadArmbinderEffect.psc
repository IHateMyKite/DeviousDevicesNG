ScriptName zadArmbinderEffect extends ActiveMagicEffect

; Libraries
zadLibs Property Libs Auto

Perk Property zad_bc_wristXPPerk_1 Auto
Perk Property zad_bc_wristXPPerk_2 Auto
Perk Property zad_bc_wristXPPerk_3 Auto
Perk Property zad_bc_wristXPPerk_4 Auto
Perk Property zad_bc_wristXPPerk_5 Auto

Float DeviceEquippedAt 
Int MsgCounter

Actor Me

Event OnUpdate()
	RegisterForSingleUpdate(45)
	If (MsgCounter == 0) && (((libs.GameDaysPassed.GetValue() - DeviceEquippedAt) * 24) > 2.0)
		libs.Notify("You start to get used to being tied.")
		Me.AddPerk(zad_bc_wristXPPerk_1)		
		MsgCounter += 1
	ElseIf (MsgCounter == 1) && (((libs.GameDaysPassed.GetValue() - DeviceEquippedAt) * 24) > 5.0)
		libs.Notify("Your wrist restraints don't hurt so much anymore.")		
		Me.AddPerk(zad_bc_wristXPPerk_2)
		MsgCounter += 1
	ElseIf MsgCounter == 2 && (((libs.GameDaysPassed.GetValue() - DeviceEquippedAt) * 24) > 12.0)
		libs.Notify("You don't notice your wrist restraints anymore.")		
		Me.AddPerk(zad_bc_wristXPPerk_3)
		MsgCounter += 1
	ElseIf MsgCounter == 3 && (((libs.GameDaysPassed.GetValue() - DeviceEquippedAt) * 24) > 24.0)
		libs.Notify("Your wrist restraints start to feel really comfortable!")
		Me.AddPerk(zad_bc_wristXPPerk_4)
		MsgCounter += 1
	ElseIf MsgCounter == 4 && (((libs.GameDaysPassed.GetValue() - DeviceEquippedAt) * 24) > 48.0)
		libs.Notify("Wearing wrist restraints feels completely natural now!")		
		Me.AddPerk(zad_bc_wristXPPerk_5)
		MsgCounter += 1
	EndIf
EndEvent

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)				
	float naplength = afDesiredSleepEndTime - afSleepStartTime	
	DeviceEquippedAt += naplength	
EndEvent
	
Event OnEffectStart(Actor akTarget, Actor akCaster)
	libs.Log("OnEffectStart(): Heavy Bondage: " + akTarget.GetLeveledActorBase().GetName())
	If Libs.Config.UseBoundCombatPerks == False
		return
	EndIf
	If akTarget != libs.PlayerRef
		return
	EndIf
	Me = akTarget	
	MsgCounter = 0	
	DeviceEquippedAt = libs.GameDaysPassed.GetValue()	
	RegisterForSingleUpdate(45)
	RegisterForSleep()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    libs.Log("OnEffectFinish(): Heavy Bondage: " + akTarget.GetLeveledActorBase().GetName())
    If akTarget == libs.PlayerRef
        akTarget.RemovePerk(zad_bc_wristXPPerk_1)
        akTarget.RemovePerk(zad_bc_wristXPPerk_2)
        akTarget.RemovePerk(zad_bc_wristXPPerk_3)
        akTarget.RemovePerk(zad_bc_wristXPPerk_4)
        akTarget.RemovePerk(zad_bc_wristXPPerk_5)          
    EndIf
EndEvent
