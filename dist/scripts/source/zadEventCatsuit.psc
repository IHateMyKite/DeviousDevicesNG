Scriptname zadEventCatsuit extends zadBaseLinkedEvent  
;created by naaitsab. Modified by AtomicGrimDark referencing Greyspammer's Trapped In Rubber

bool Function HasKeywords(actor akActor)
	if !libs.AllowGenericEvents(akActor, libs.zad_DeviousSuit)
		return false
	elseif !akActor.WornHasKeyword(libs.zad_DeviousSuit)
		return false
	else
		armor a = zadNativeFunctions.GetWornDevice(akActor, libs.zad_DeviousSuit)
		; no keyword specifically for catsuits.
		return a != None && StringUtil.Find(a.GetName(), "cat") != -1
	endif
EndFunction

Function Execute(actor akActor)
	if libs.PlayerRef.IsInInterior() == 1
		PlayerIsOutside()
	else
		PlayerIsInside()
	endif
EndFunction

Function PlayerIsOutside()
	Weather currentweather = Weather.GetCurrentWeather()
	int weathertype = currentweather.GetClassification() ;-1: No classification 0: Pleasant 1: Cloudy 2: Rainy 3: Snow
	float currenthour = GetCurrentTimeOfDay()
	float currentsundamage = currentweather.GetSunDamage()
	
	;let's use vampire sun damage to determine if it really is a factor
	;the time of day is silly for it however, let's determine that 9-15 the sun is high enough
	if weathertype == 0 && currenthour >= 9 && currenthour <= 15 && currentsundamage == 1
		libs.NotifyPlayer("The sun on your suit makes you sweat even more.")
	elseif weathertype == 0 && currenthour >= 9 && currenthour <= 15 && currentsundamage < 1
		libs.NotifyPlayer("The warmth of the day makes you sweat more.")
	elseif weathertype == 1 && currenthour >= 9 && currenthour <= 15
		libs.NotifyPlayer("A trickle of sweat runs down your spine and pools between your legs.")
	elseif (weathertype == 0 || weathertype == 1) && currenthour < 9 && currenthour > 15
		libs.NotifyPlayer("You feel the slightest breeze against your suit as if you were naked.")
	elseif weathertype == 2 && currenthour >= 9 && currenthour <= 15
		libs.NotifyPlayer("The rain just glides off your suit onto the ground.")
	elseif weathertype == 2 && currenthour < 9 && currenthour > 15
		libs.NotifyPlayer("The rain feels cool as it runs along and off your suit.")
	elseif weathertype == 3 && currenthour >= 9 && currenthour <= 15
		libs.NotifyPlayer("The snow melts agains your suit, you feel chilly.")
	elseif weathertype == 3 && currenthour < 9 && currenthour > 15
		libs.NotifyPlayer("The suit feels exceedingly cold.")
	else
		PlayerIsInside()
	endif

EndFunction

Function PlayerIsInside()
	int selection = Utility.RandomInt(1,5)
	if selection == 1
		libs.NotifyPlayer("Like a second skin, your suit hugs every part of your body.")
	elseif selection == 2
		libs.NotifyPlayer("The suit causes you to sweat uncontrollably.")
	elseif selection == 3
		libs.NotifyPlayer("The suit settles and slides, caressing your skin.")
	elseif selection == 4
		libs.NotifyPlayer("Your muscles strain slightly against the suit. Every breath makes itself felt.")
	elseif selection == 5
		libs.NotifyPlayer("The suit is getting a bit slippery on the inside.")
	endif
EndFunction

float Function GetCurrentTimeOfDay()
	float Time = libs.GameDaysPassed.GetValue()
	Time -= Time as Int ; Remove "previous in-game days passed" bit
	Time *= 24 ; Convert from fraction of a day to number of hours
	Return Time
EndFunction
