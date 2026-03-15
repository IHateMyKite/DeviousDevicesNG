Scriptname zadx_GagInflatableScript extends zadGagScript  

Faction Property zadx_InflatableGagFaction Auto ;rank 0 = not equiped, 1 = deflated, normal gag 2 = semi-inflated, dialgagrandom mode, 3 = fully inflated, dialgaghard mode

Message Property zadx_gagCallForHelpInflatedMsg Auto ;shown when device has an inflated state

Key Property deviceValveKey Auto ;key to manipulate the valve
Bool Property DestroyValveKey = False Auto ;key distroyed on deflate

int inflationFactionRank

Function OnEquippedPre(actor akActor, bool silent=false)
	libs.Log("Inflatable Gag: Setting faction rank.")
	akActor.SetFactionRank(zadx_InflatableGagFaction, 1)
	Parent.OnEquippedPre(akActor, silent)
EndFunction

Function OnRemoveDevice(actor akActor)
	libs.Log("Inflatable Gag: Resetting faction rank.")
	akActor.RemoveFromFaction(zadx_InflatableGagFaction)
EndFunction


Function DeviceMenuExt(int msgChoice)
	actor gagwearer = DeviceWearer
	inflationFactionRank = gagwearer.GetFactionRank(zadx_InflatableGagFaction)

	Parent.DeviceMenuExt(msgChoice)
	if msgChoice == 3 ; Cry for help
		if inflationFactionRank == 1
			libs.Moan(gagwearer)
			callForHelpMsg.Show()
		ElseIf inflationFactionRank > 1 ;inflated state
			libs.Moan(gagwearer)
			zadx_gagCallForHelpInflatedMsg.show()
		endif
	ElseIf msgChoice == 4 ; Inflate gag
		InflateGag(gagwearer)
	ElseIf msgChoice == 5 ; Deflate gag
		if deviceValveKey
			if libs.PlayerRef.GetItemCount(deviceValveKey) == 0
				libs.NotifyPlayer("You lack the key to manipulate the valve.")
			else
				DeflateGag(gagwearer)
				If (DestroyValveKey || libs.Config.GlobalDestroyKey) && deviceValveKey.HasKeyword(libs.zad_NonUniqueKey)
					libs.PlayerRef.RemoveItem(deviceValveKey, 1, False)
				endif
			endif

			Return
		endif

		DeflateGag(gagwearer)
	EndIf
EndFunction

Function InflateGag(actor akActor)
	if inflationFactionRank <= -1
		libs.Error("InflateGag called on actor that is not wearing an inflatable gag.")
		return
	elseif inflationFactionRank == 1
		SendModEvent("GagInflateStateChange", akActor.GetLeveledActorBase().GetName(), 2.0)
		akActor.SetFactionRank(zadx_InflatableGagFaction, 2)
		libs.NotifyPlayer("You press on the valve plunger inflating the gag in the process." + inflationFactionRank)
		return
	elseif inflationFactionRank == 2
		SendModEvent("GagInflateStateChange", akActor.GetLeveledActorBase().GetName(), 3.0)
		akActor.SetFactionRank(zadx_InflatableGagFaction, 3)
		libs.NotifyPlayer("You press on the valve plunger inflating the gag to it's maximum." + inflationFactionRank)
		return
	elseif inflationFactionRank > 2
		libs.NotifyPlayer("The gag won't inflate any further." + inflationFactionRank)
		return
	else
		libs.Error("InflateGag unknown faction rank.")
		return
	EndIf

EndFunction

Function DeflateGag(actor akActor)
	if inflationFactionRank <= -1
		libs.Error("DeflateGag called on actor that is not wearing an inflatable gag.")
		return
	elseif inflationFactionRank == 3
		SendModEvent("GagInflateStateChange", akActor.GetLeveledActorBase().GetName(), 2.0)
		akActor.SetFactionRank(zadx_InflatableGagFaction, 2)
		libs.NotifyPlayer("The valve releases some of the gag's pressure. Reducing it's size." + inflationFactionRank)
		return
	elseif inflationFactionRank == 2
		SendModEvent("GagInflateStateChange", akActor.GetLeveledActorBase().GetName(), 1.0)
		akActor.SetFactionRank(zadx_InflatableGagFaction, 1)
		libs.NotifyPlayer("The valve releases the gag of it's pressure. Reverting to it's deflated state." + inflationFactionRank)
		return
	elseif inflationFactionRank == 1
		libs.NotifyPlayer("The gag won't deflate any further." + inflationFactionRank)
		return
	else
		libs.Error("DeflateGag unknown faction rank.")
		return
	EndIf
	SendModEvent("GagInflateStateChange", akActor.GetLeveledActorBase().GetName(), 0.0)
	akActor.SetFactionRank(zadx_InflatableGagFaction, 0)
EndFunction