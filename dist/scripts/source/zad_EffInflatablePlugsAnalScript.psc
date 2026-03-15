Scriptname zad_EffInflatablePlugsAnalScript extends activemagiceffect  

zadLibs Property Libs Auto

Actor target
bool Terminate

; Global properties are declared here for convenience
Keyword Property loctypeplayerhome Auto
Keyword Property LocTypeJail Auto
Keyword Property LocTypeDungeon Auto
Keyword Property LocSetCave Auto
Keyword Property LocTypeDwelling Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeTown Auto
Keyword Property LocTypeHabitation Auto
Keyword Property LocTypeDraugrCrypt Auto
Keyword Property LocTypeDragonPriestLair Auto
Keyword Property LocTypeBanditCamp Auto
Keyword Property LocTypeFalmerHive Auto
Keyword Property LocTypeVampireLair Auto
Keyword Property LocTypeDwarvenAutomatons Auto
Keyword Property LocTypeMilitaryFort Auto
Keyword Property LocTypeMine Auto
Keyword Property LocTypeInn Auto
Keyword Property LocTypeHold Auto

Function DoRegister()
	if !Terminate && target
		RegisterForSingleUpdate(30.0)
	EndIf
EndFunction

Function DoStart()	
	if !Terminate && target
		RegisterForSingleUpdate(30.0)
	EndIf
EndFunction

Function DoUnregister()
	if !Terminate && target		
		UnregisterForUpdate()
	EndIf	
EndFunction

bool Function isInHomeorJail(Location loc)
	Return loc != none && (loc.haskeyword(loctypeplayerhome) || loc.haskeyword(loctypejail) ) 
endfunction

bool Function isInCity(Location loc)
	Return loc != none && (loc.haskeyword(loctypecity) || loc.haskeyword(loctypetown) || loc.haskeyword(loctypehabitation) || loc.haskeyword(loctypedwelling))
endfunction

bool Function isInHold(Location loc)  
	Return !Target.GetParentCell().IsInterior() && (loc == none || loc.haskeyword(loctypehold))
endfunction

Event OnUpdate()	
	if !Terminate
		Float day = (libs.GameDaysPassed.GetValue() - libs.LastInflationAdjustmentAnal) * 24.0
		If day > 5.0
			Float plugState = libs.zadInflatablePlugStateAnal.GetValue()
			If (plugState > 0)
				libs.zadInflatablePlugStateAnal.SetValue(plugState - 1)
				libs.notify("Your inflatable plugs lose some pressure...")
				libs.LastInflationAdjustmentAnal = libs.GameDaysPassed.GetValue()
				DoRegister()
				return
			EndIf
		EndIf
		if !Target.IsInCombat() && !libs.IsAnimating(Target) && !Target.IsOnMount() && !Target.IsSwimming()
			Location loc = Target.GetCurrentLocation()
			If !isInHomeorJail(loc) && (isInCity(loc) || isInHold(loc)) && !UI.IsMenuOpen("Dialogue Menu")
				; look for people that 'accidentally' inflate the plugs
				If Utility.RandomInt() < 25 && day > 1.0 ; can't happen more than once in a while
					libs.log("Inflatable Plugs: Testing for valid NPC.")
					Actor currenttest = Game.FindRandomActorFromRef(Target, 350.0)
					if currenttest && libs.ValidForInteraction(currenttest, genderreq = -1, creatureok = false, animalok = false, beastreaceok = true, elderok = true, guardok = true)
						libs.notify(currenttest.GetActorBase().GetName() + " gives your plug pump a squeeze, inflating it inside you!")
						libs.InflateRandomPlug(Target, 1)
					ElseIf Utility.RandomInt() < 10 ; when there is nobody there, she has a small chance to do it herself:
						libs.notify("You 'accidentally' give your plug pump a squeeze...")
						libs.InflateRandomPlug(Target, 1)
					EndIf
				EndIf
			EndIf
		EndIf
		libs.Aroused.UpdateActorExposure(Target, 2)
	Else ; Avoid race condition		
	EndIf	
	DoRegister()
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)	
	libs.Log("OnEffectStart(): Inflatable Plugs")
	; the effect will not be used for NPCs.
	If akTarget != libs.PlayerRef
		return
	EndIf
	Target = akTarget
	Terminate = False	
	libs.zadInflatablePlugStateAnal.SetValue(0)
	libs.LastInflationAdjustmentAnal = libs.GameDaysPassed.GetValue()
	DoStart()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	libs.Log("OnEffectFinish(): Inflatable Plugs")	
	If akTarget != libs.PlayerRef
		return
	EndIf
	Terminate = True
	DoUnregister()
EndEvent