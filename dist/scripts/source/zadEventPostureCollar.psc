scriptName zadEventPostureCollar extends zadBaseEvent

bool Function HasKeywords(actor akActor)
	if !libs.AllowGenericEvents(akActor, libs.zad_DeviousCollar)
		return false
	elseif !akActor.WornHasKeyword(libs.zad_DeviousCollar)
		return false
	else
		armor a = zadNativeFunctions.GetWornDevice(akActor, libs.zad_DeviousCollar)
		; no keyword specifically for posture collars.
		return a != None && StringUtil.Find(a.GetName(), "Posture") != -1
	endif
EndFunction

Function Execute(actor akActor)
	libs.Moan(akActor)
	libs.NotifyPlayer("The posture collar uncomfortably forces you into a more refined posture.")	
EndFunction
