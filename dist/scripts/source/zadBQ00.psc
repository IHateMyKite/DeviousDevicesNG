;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname zadBQ00 Extends zadBaseDeviceQuest Hidden

import zadNativeFunctions
;BEGIN ALIAS PROPERTY ArmBinderRescuer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ArmBinderRescuer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
SetObjectiveCompleted(100)
CompleteQuest()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
SetObjectiveDisplayed(80)
RelieveSelf()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
setObjectiveDisplayed(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed(10)
Rehook()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

; Libraries
SexLabFramework property SexLab auto
slaUtilScr Property Aroused Auto
zadBeltedAnims Property zadAnims  Auto  
zadNPCQuestScript Property npcs Auto
zadSLBoundAnims Property zadSLAnims Auto

zadArmbinderQuestScript Property abq Auto
zadYokeQuestScript Property ybq Auto

zadDeviousMagic Property zadMagic Auto
zadAssets Property assets Auto
zadBenchmark Property benchmark Auto

; Messages
Message Property zad_eventSleepStopContent auto
Message Property zad_eventSleepStopDesire auto
Message Property zad_eventSleepStopHorny auto
Message Property zad_eventSleepStopDesperate auto

; Persistant Variables
float Property modVersion Auto
bool Property processMountedEvent Auto
bool Property processDripEvent Auto
bool Property processChafeMessageEvent Auto
bool Property processHornyEvent Auto
bool Property processTightBraEvent Auto ; Name not applicable with current bra mesh, lol
bool Property processPostureCollarMessageEvent Auto
bool Property processBumpPumpEvent Auto
bool Property processBlindfoldEvent Auto
bool Property processHarnessEvent Auto
bool Property processPlugsEvent Auto

bool Property Tainted Auto ; Not going to offer support for tainted installations.
string[] Property Registry Auto

;Animation Arrays
;used to store sex animation per each category
String[] Property PetSuitBlowjob Auto Hidden
String[] Property PetSuitVaginal Auto Hidden
String[] Property PetSuitAnal Auto Hidden

String[] Property BoundMasturbation  Auto Hidden

import sslUtility

function Shutdown(bool silent=false)
    ; this is not finished yet.
    UnregisterForAllModEvents()
    if !silent
        debug.messagebox("Devious Devices has completed shutting down. It is now safe-ish to uninstall.")
    EndIf
EndFunction

Event OnInit()
    RegisterForSingleUpdate(10.0)
EndEvent

bool _initiated = false
Event OnUpdate()
    if !_initiated
        RegisterForModEvent("__DeviousDevicesInit", "OnInitialize")
        ;libs.BoundCombat.CONFIG_ABC()
        checkBlindfoldDarkFog()
        _initiated = true
    endif
EndEvent

Event OnInitialize(string eventName, string strArg, float numArg, Form sender)
	UnregisterForModEvent("__DeviousDevicesInit")
	Maintenance()
EndEvent


Function checkBlindfoldDarkFog()
	if (libs.PlayerRef.WornHasKeyword(libs.zad_DeviousBlindfold) && libs.config.BlindfoldMode == 3) ;dark fog
		if Weather.GetSkyMode() != 0
		  zadNativeFunctions.ExecuteConsoleCmd("ts")
		  Utility.Wait(0.1)
		endif
		zadNativeFunctions.ExecuteConsoleCmd("setfog " + libs.config.darkfogStrength + " " + libs.config.darkfogStrength)
	Else
		; needs to be reset because that command is apparently persistant across save games. If this ever causes compatibility issues, we need to revamp this, but it's unlikely.
		if Weather.GetSkyMode() == 0
			zadNativeFunctions.ExecuteConsoleCmd("ts")
		endif
		zadNativeFunctions.ExecuteConsoleCmd("setfog 0 0")
	EndIf
EndFunction

Function Maintenance()
	libs.log("Maintenance routine called")
    CheckNativePlugins()
	; benchmark.SetupBenchmarks()
	float curVersion = libs.GetVersion()
	checkBlindfoldDarkFog()
	if zad_DeviousDevice == None
		Debug.MessageBox("Devious Devices has not been correctly upgraded from its previous version. Please Clean Save, as per the instructions in the support thread.")
		Libs.Error("zad_DeviousDevice == none in Maintenance()")
	Endif
	bool regDevices = false 
	if modVersion != curVersion
		modVersion = curVersion
		debug.notification("Devious Devices, version " + libs.GetVersionString() + " initialized.")
		libs.Log("Initializing.")
		regDevices = true
	EndIf
	Parent.Maintenance()
	; I doubt this will actually fix the MCM issue people are reporting, though who knows. Doesn't make sense that the animation failing 
	; to register with Sexlab would cause zadConfig to not initialize properly. All the same, better to avoid that race condition
	zadAnims.LoadAnimations()
	zadSLAnims.LoadAnimations()
	libs.EnableEventProcessing()
	; Finish initialization
	Rehook()
	; Make sure nothing got stuck on a previous play-through.
	bool showCompass = true
	if libs.playerRef.WornHasKeyword(libs.zad_DeviousBlindfold)
		showCompass = false
	EndIf
	libs.ToggleCompass(showCompass)
	libs.SetAnimating(libs.PlayerRef, false)
	libs.StopVibrating(libs.PlayerRef)
	zadMagic.IsRunning = False
	libs.DeviceMutex = false
	libs.repopulateMutex = false
	libs.lastRepopulateTime = 0.0
	libs.zadNPCQuest.Maintenance()
	libs.RepopulateNpcs()	
	VersionChecks()
	; Start up periodic events system
	libs.EventSlots.Initialize()
	libs.EventSlots.Maintenance()
	; Check to see if bound anims are available.
	if !libs.DevicesUnderneath.IsRunning() && libs.config.DevicesUnderneathEnabled
		libs.DevicesUnderneath.Start()
		int timeout = 0
		while !libs.DevicesUnderneath.IsRunning() && timeout < 25
			timeout += 1
			Utility.Wait(0.2)
		EndWhile
		libs.DevicesUnderneath.Maintenance()
	EndIf
	; Bound Combat Maintenance and Cleanup 
	libs.BoundCombat.Maintenance_ABC()
	;libs.BoundCombat.CleanupNPCs()
	if libs.BoundCombat.HasCompatibleDevice(libs.playerRef)
		libs.BoundCombat.EvaluateAA(libs.PlayerRef)
	EndIf
	; Generic Devices
	If regDevices
		libs.RegisterDevices() ; Might take a while, do it last
	EndIf
  libs.EnableVRSupport = (Game.GetModByName("vrikForceAction.esp") != 255)
  if libs.EnableVRSupport
    libs.vrikActionsAPI = Quest.GetQuest("_vrikAction_qust_mcm")
  EndIf
EndFunction


Function CheckCompatibility(string name, float required, float current)
	string status = ""
	if current == 0
		status = "UNINITIALIZED"
	ElseIf current < required
		libs.Error("Incompatible version of "+name+" detected! Version "+required+" or newer is required, current is "+current+".")
		status="FAIL"
	Else
		status = "OK"
	EndIf
	libs.Log(name+" version [" + current + "]: "+status)
EndFunction


Function VersionChecks()
	libs.Log("==========Begin Compatibility Checks==========")
	libs.Log("Please note that Errors related to missing files should be ignored.")
	libs.Log("[ Dependency Checks ]")

	CheckCompatibility("DDi", modVersion, modVersion)
	if !assets
		libs.Error("Assets is undefined: You're probably running an out of date version of it. Please update Devious Devices - Assets to the latest version.")
	EndIf
	CheckCompatibility("Assets", 2.90, assets.GetVersion())	
	CheckCompatibility("Aroused", 20140124.0, Aroused.GetVersion())
	CheckCompatibility("Sexlab", 15900, SexlabUtil.GetVersion())
	libs.Log("[ Third Party Mod Compatibility Checks ]")
	; ...
	libs.Log("[ Sanity Checks ]")
	string status = "OK"
	if Tainted
		status="FAIL"
	EndIf
	libs.Log("Verifying that installation is untainted by an unsupported upgrade: "+status)
	status="OK"	
	libs.Log("==========End Compatibility Checks==========")
EndFunction

;Check native plugins
Function CheckNativePlugins()
    if !zadNativeFunctions.PluginInstalled("mfgfix.dll")
        Debug.MessageBox("-Devious Devices-\n Can't find mfgfix.dll. Please install the Mfg Fix, otherwise the expressions will not work correctly!")
    endif
    if !zadNativeFunctions.PluginInstalled("skee64.dll") && !zadNativeFunctions.PluginInstalled("skeevr.dll")
        Debug.MessageBox("-Devious Devices-\n Can't find skee64.dll. Please install the Racemenu, otherwise the mod will not work correctly!")
    endif
EndFunction

function Rehook()
	libs.Log("Rehooking Mod Events")
	; Skse mod events	
	RegisterForModEvent("HookAnimationStart", "OnAnimationStart")
	RegisterForModEvent("HookAnimationEnd", "OnAnimationEnd")
	RegisterForModEvent("HookLeadInEnd", "OnLeadInEnd")
	RegisterForModEvent("HookOrgasmStart", "OnOrgasmStart")
	RegisterForModEvent("HookAnimationChange", "OnAnimationChange")
	; No-Dependency ModEvents for people who want to casually use DDI without linking to it.
	RegisterForModEvent("DDI_EquipDevice", "OnDDIEquipDevice")
	RegisterForModEvent("DDI_RemoveDevice", "OnDDIRemoveDevice")
	RegisterForModEvent("DDI_CreateRestraintsKey", "OnDDICreateRestraintsKey")
	RegisterForModEvent("DDI_CreateChastityKey", "OnDDICreateChastityKey")
	RegisterForModEvent("DDI_CreatePiercingKey", "OnDDICreatePiercingKey")
	; Papyrus mod events
	UnregisterForSleep()
	RegisterForSleep()
EndFunction

;DEPRECATED, INLINED IN THE ONLY PLACE IT'S EVER USED
;bool Function IsValidAnimation(sslBaseAnimation anim, bool permitOral, bool permitVaginal, bool permitAnal, bool permitBoobjob, bool HasBoundActors)
;	if anim.HasTag("DeviousDevice")
;		return true
;	elseif HasBoundActors
;		; we're not a DD animation, but there are bound actors => invalid. DD doesn't support bound animation from SexLab registry, only its own. If we ARE a DD anin, it had to be triggered by the framework and should be matching the bindings, so no need to check that.
;		; This code cannot confirm validity of SL registered bound animations, but I have zero intention to ever support this, so that's fine.
;		return False	
;	elseif (permitBoobjob || !anim.HasTag("Boobjob")) &&(permitVaginal || (!anim.HasTag("Vaginal") && !anim.HasTag("Fisting") && !anim.HasTag("Masturbation"))) && (permitAnal || !anim.HasTag("Anal")) && (permitOral || !anim.HasTag("Oral"))
;		return true
;	endif
;	return false
;EndFunction

string Function GetAnimationNames(sslBaseAnimation[] anims)
    string ret = ""
    int i = anims.Length
    while i > 0
        i -= 1
        ret += anims[i].Name
        if i > 0
            ret += ", "
        EndIf
    EndWhile
    return ret
EndFunction


sslBaseAnimation Function GetBoundAnim(Actor[] actorArray, Bool permitOral, Bool permitVaginal, Bool permitAnal, Bool permitBoobs)
	; sanity check if both actors are male, because we have no animations for that
	If (actorArray[0].GetLeveledActorBase().GetSex() == 0) && (actorArray[1].GetLeveledActorBase().GetSex() == 0)
		Return None
	EndIf
	; since newer SexLab editions can switch around actors in slots for correct placements, check for bound actors based on bound status
	Actor BoundActor = None
	Actor Partner = None
	If libs.NeedsBoundAnim(actorArray[0])
		BoundActor = actorArray[0]
		Partner = actorArray[1]
	ElseIf libs.NeedsBoundAnim(actorArray[1])
		BoundActor = actorArray[1]
		Partner = actorArray[0]
	EndIf
	; by the power of SKSE and PapyrusUtil - which are already present in the requirements, we are able to get as close to dynamic string arrays as possible in here
	; by registering animations to categorical arrays, we can easily select a random animation from the proper array without the need of explicitly calling it
	If HasPetSuit(BoundActor)
		if !Partner.WornHasKeyword(libs.zad_DeviousHeavyBondage)
			If Partner.GetLeveledActorBase().GetSex() == 0
				If permitVaginal && permitOral && permitAnal
					String[] AnimArray0 = PapyrusUtil.MergeStringArray( PetsuitVaginal, PetSuitBlowjob )
					String[] AnimArray = PapyrusUtil.MergeStringArray( AnimArray0, PetsuitAnal )
					Return SexLab.GetAnimationObject( AnimArray[Utility.RandomInt( 0, AnimArray.Length - 1 )] )
				ElseIf permitVaginal && permitOral
					String[] AnimArray = PapyrusUtil.MergeStringArray( PetSuitBlowjob, PetsuitVaginal )
					Return SexLab.GetAnimationObject( AnimArray[Utility.RandomInt( 0, AnimArray.Length - 1 )] )	
				ElseIf permitVaginal && permitAnal
					String[] AnimArray = PapyrusUtil.MergeStringArray( PetsuitVaginal, PetsuitAnal )
					Return SexLab.GetAnimationObject( AnimArray[Utility.RandomInt( 0, AnimArray.Length - 1 )] )
				ElseIf permitOral && permitAnal
					String[] AnimArray = PapyrusUtil.MergeStringArray( PetSuitBlowjob, PetsuitAnal )
					Return SexLab.GetAnimationObject( AnimArray[Utility.RandomInt( 0, AnimArray.Length - 1 )] )
				ElseIf permitVaginal
					Return SexLab.GetAnimationObject( PetSuitVaginal[Utility.RandomInt( 0, PetsuitVaginal.Length - 1 )] )
				ElseIf permitOral
					Return SexLab.GetAnimationObject( PetSuitBlowjob[Utility.RandomInt( 0, PetSuitBlowjob.Length - 1 )] )
				ElseIf permitAnal	
					Return SexLab.GetAnimationObject( PetSuitAnal[Utility.RandomInt( 0, PetsuitAnal.Length - 1 )] )
				EndIf
			;not a male
			Else
				If permitVaginal && permitAnal	
					String[] AnimArray = PapyrusUtil.MergeStringArray( PetsuitVaginal, PetsuitAnal )
					Return SexLab.GetAnimationObject( AnimArray[Utility.RandomInt( 0, AnimArray.Length - 1 )] )
				ElseIf permitVaginal
					Return SexLab.GetAnimationObject( PetSuitVaginal[Utility.RandomInt( 0, PetsuitVaginal.Length - 1 )] )
				ElseIf permitAnal	
					Return SexLab.GetAnimationObject( PetSuitAnal[Utility.RandomInt( 0, PetsuitAnal.Length - 1 )] )
				EndIf
			EndIf
		EndIf
	EndIf
	Return None
EndFunction

;DEPRECATED, not needed anymore
;String Function GetCreatureType(sslBaseAnimation previousAnim)
;	; support some humanoid creatures properly by getting the tag used for the previous animation, so we can append it to the tag string.
;	If previousAnim.HasTag("Falmer") 
;		Return "Falmer"
;	EndIf
;	If previousAnim.HasTag("Skeleton") 
;		Return "Skeleton"
;	EndIf
;	If previousAnim.HasTag("Troll") 
;		Return "Troll"
;	EndIf
;	If previousAnim.HasTag("Spriggan") 
;		Return "Spriggan"
;	EndIf
;	If previousAnim.HasTag("Draugr") 
;		Return "Draugr"
;	EndIf
;EndFunction

; library version of the animation filter. This function is used to pick a valid sexlab animation to start a new animation with (avoiding filtering in the first place). For DD mods, this is the desired method to start a sexlab animation. There is a wrapper function in zadLibs modders can use, as this script isn't commonly linked to by content mods.
sslBaseAnimation[] function SelectValidDDAnimations(Actor[] Actors, int actorCount, bool forceaggressive = False, string includetag = "", string suppresstag = "")
	libs.Log("Selecting DD-aware animations.")
	sslBaseAnimation[] Sanims
	Bool permitOral = True
	Bool permitVaginal = True
	Bool permitAnal = True
	Bool permitBoobs = True
	Bool HasBoundActors = False
	Bool aggr = False
	If forceaggressive
		libs.Log("Using only aggressive animations.")
		aggr = True
		includetag = "Aggressive," + includetag
	EndIf

	Int i = Actors.Length
	While i > 0
		i -= 1
		PermitAnal = PermitAnal && !IsBlockedAnal(Actors[i])
		PermitVaginal = PermitVaginal && !IsBlockedVaginal(Actors[i])
		PermitBoobs = PermitBoobs && !IsBlockedBreast(Actors[i])
		PermitOral = PermitOral && !IsBlockedOral(Actors[i])
		HasBoundActors = HasBoundActors || libs.NeedsBoundAnim(Actors[i])
	EndWhile
	If StringUtil.Find(suppresstag, "Vaginal") != -1
		permitVaginal = False
	EndIf
	If StringUtil.Find(suppresstag, "Anal") != -1
		permitAnal = False
	EndIf
	If StringUtil.Find(suppresstag, "Oral") != -1
		permitOral = False
	EndIf

	;we have bound anims only for 2 actors, restraints will be unequipped in case of more actors in a scene
	;Animations need to be processed separately, since they are not registered in SexLab
	If actorCount == 2 && HasBoundActors
		;handle pet suits for 2 actor scenes, presently this is the only restraint type that needs animations called directly
		If ( Actors[0].WornHasKeyword(libs.zad_DeviousPetSuit) || Actors[1].WornHasKeyword(libs.zad_DeviousPetSuit) )
			libs.Log("Actor(s) wearing pet suit found. Trying to set up bound animation.")
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = GetBoundAnim(Actors, permitOral, permitVaginal, permitAnal, permitBoobs)
			If Sanims[0] == None
				libs.log("Error: SelectValidDDAnimations couldn't find valid bound animations.")
				Return Sanims
			Else
				Return Sanims
			Endif
		Endif
	Endif

	String suppressString = getSuppressString(permitOral, permitVaginal, permitAnal, permitBoobs, !HasBoundActors, suppresstag)	
	;we need to process private animations and masturbation as a special case and also not exclude opposite gender masturbation
	If actorCount == 1 		
		libs.Log("Selecting masturbation animation.")
		If HasArmbinderNonStrict(Actors[0]) ; she is wearing an armbinder
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDArmbinderSolo")
			return Sanims
		Endif
		If HasYoke(Actors[0]) ; she is wearing a yoke
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDYokeSolo")
			return Sanims
		Endif
		If HasElbowbinder(Actors[0]) ; she is wearing an elbowbinder
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDElbowbinderSolo")
			return Sanims
		Endif
		If HasBBYoke(Actors[0]) ; she is wearing a breast yoke
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDBBYokeSolo")
			return Sanims
		Endif
		If HasFrontCuffs(Actors[0]) ; she is wearing wrist cuffs
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDFrontCuffsSolo")
			return Sanims
		Endif
		If HasElbowShackles(Actors[0]); she is wearing elbow shackles
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDElbowTieSolo")
			return Sanims
		Endif
		If !permitVaginal ;she is belted
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDBeltedSolo")
			return Sanims
		Endif
		; if she is not wearing chastity, we need to filter the wrong gender
		includetag= "Solo," + includetag
		If actors[0].GetLeveledActorBase().GetSex() == 1
			suppressString = "M," + suppressString
		Elseif actors[0].GetLeveledActorBase().GetSex() == 0
			suppressString = "F," + suppressString
		EndIf
	EndIf

	;handle creature tags
	Int[] Genders = libs.SexLab.GenderCount(Actors)
	;check if there are creatures in the array
	If (Genders[2] + Genders[3]) < 1
		;no creatures
		Sanims = SexLab.GetAnimationsByTags(actorCount, includetag, suppressString, True)
	Else
		;yes creatures
		Sanims = Sexlab.GetCreatureAnimationsByActorsTags(actorCount, Actors, includetag, suppressString, True)
	EndIf
	libs.log("Selecting SexLab animations with number of actors: " + actorCount)
	libs.log("Selecting SexLab animations with tag string: " + includetag)
	libs.log("Selecting SexLab animations with suppress string: " + suppressString)
	Return Sanims
EndFunction

;filter version of the animation selector
sslBaseAnimation[] function SelectValidAnimations(sslThreadController Controller, Int actorCount, sslBaseAnimation previousAnim, Bool permitOral, Bool permitVaginal, Bool permitAnal, Bool permitBoobs, Bool noBindings)
	sslBaseAnimation[] Sanims
	;we have bound anims only for 2 actors, restraints will be unequipped in case of more actors in a scene
	;Animations need to be processed separately, since they are not registered in SexLab
	If actorCount == 2 && !noBindings
		;handle pet suits for 2 actor scenes, presently this is the only restraint type that needs animations called directly
		If ( Controller.Positions[0].WornHasKeyword(libs.zad_DeviousPetSuit) || Controller.Positions[1].WornHasKeyword(libs.zad_DeviousPetSuit) )
			libs.Log("Actor(s) wearing pet suit found. Trying to set up bound animation.")
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = GetBoundAnim(Controller.Positions, permitOral, permitVaginal, permitAnal, permitBoobs)
			If Sanims[0] == None
				libs.log("Error: SelectValidAnimations couldn't find valid bound animations.")
				Return Sanims
			Else
				Return Sanims
			Endif
		Endif
	Endif

	String tagString = ""
	;if preserve scene aggressiveness is enabled in the config menu, the tag will be carried
	If (previousAnim != none && previousAnim.HasTag("Aggressive") && libs.config.PreserveAggro)
		libs.Log("Using aggressive animations.")
		tagString += ",Aggressive"
	Endif
	String suppressString = getSuppressString(permitOral, permitVaginal, permitAnal, permitBoobs, noBindings)

	;we need to process private animations and masturbation as a special case and also not exclude opposite gender masturbation
	If actorCount == 1
		libs.Log("Selecting masturbation animation.")
		If HasArmbinderNonStrict(Controller.Positions[0]) ; she is wearing an armbinder
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDArmbinderSolo")
			return Sanims
		Endif
		If HasYoke(Controller.Positions[0]); she is wearing a yoke
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDYokeSolo")
			return Sanims
		Endif
		If HasElbowbinder(Controller.Positions[0]); she is wearing an elbowbinder
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDElbowbinderSolo")
			return Sanims
		Endif
		If HasBBYoke(Controller.Positions[0]); she is wearing a breast yoke
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDBBYokeSolo")
			return Sanims
		Endif
		If HasFrontCuffs(Controller.Positions[0]); she is wearing wrist cuffs
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDFrontCuffsSolo")
			return Sanims
		Endif
		If HasElbowShackles(Controller.Positions[0]); she is wearing elbow shackles
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDElbowTieSolo")
			return Sanims
		Endif
		If !permitVaginal ;she is belted
			Sanims = New sslBaseAnimation[1]
			Sanims[0] = SexLab.GetAnimationObject("DDBeltedSolo")
			return Sanims
		Endif
		;if she is not wearing chastity, we need to filter the wrong gender
		tagString = "Solo," + tagString
		If Controller.Positions[0].GetLeveledActorBase().GetSex() == 1
			suppressString = "M," + suppressString
		Elseif Controller.Positions[0].GetLeveledActorBase().GetSex() == 0
			suppressString = "F," + suppressString
		EndIf
	EndIf
	;first, try just filtering the problematic animations out of the original SexLab filtered list
	Sanims = SexLab.RemoveTagged(Controller.Animations, suppressString)	
	If Sanims.Length > 0
		libs.log("Suppressed SexLab animations with tags: " + suppressString)
	Else
		;just try to find any SexLab animation that fits our conditions
		;handle creature tags
		Int[] Genders = libs.SexLab.GenderCount(Controller.Positions)
		;check if there are creatures in the array
		If (Genders[2] + Genders[3]) < 1
			;no creatures
			Sanims = SexLab.GetAnimationsByTags(actorCount, tagString, suppressString, True)
		Else
			;yes creatures
			Sanims = Sexlab.GetCreatureAnimationsByActorsTags(actorCount, Controller.Positions, tagString, suppressString, True)
		EndIf
		libs.log("Selecting SexLab animations with number of actors: " + ActorCount)
		libs.log("Selecting SexLab animations with tag string: " + tagString)
		libs.log("Selecting SexLab animations with suppress string: " + suppressString)
	EndIf
	Return Sanims
EndFunction

String Function getSuppressString(bool permitOral, bool permitVaginal, bool permitAnal, bool permitBoobs, bool NoBindings, string suppresstag = "")	
	String supr = suppresstag
	If !permitVaginal    
		supr = "Vaginal," + supr
	EndIf
	If !permitAnal
		supr = "Anal," + supr
	EndIf
	If !permitBoobs
		supr = "Boobjob," + supr
	Endif
	If !permitOral
		supr = "Oral,Blowjob," + supr
	EndIf
	If !NoBindings
		supr = "Handjob," + supr
	EndIf
	Return supr
EndFunction

;DEPRECATED, INLINED AT THE PLACES WHERE IT'S USED
;String Function getTagString(bool aggressive, string includetag = "")
;	string tags = includetag 
;	If includetag != "" && StringUtil.GetNthChar(includetag, (StringUtil.GetLength(includetag) - 1)) != ","
;		tags += ","
;	EndIf	
;	if aggressive
;		includetag += ",Aggressive"
;	endif
;	if tags != ""
;		int leng = StringUtil.getlength(tags)
;		leng -= 1
;		tags = StringUtil.SubString(tags,0,leng)
;	endif
;	return tags	
;EndFunction

int function CountRestrictedActors(actor[] actors, keyword permit, keyword restricted1, keyword restricted2=none, keyword restricted3=none)
	int ret = 0
	int i = actors.length
	while i > 0
		i -= 1
		if (permit == None || !actors[i].WornHasKeyword(permit)) && (actors[i].WornHasKeyword(restricted1) || (restricted2 && actors[i].WornHasKeyword(restricted2)) || (restricted3 && actors[i].WornHasKeyword(restricted3)))
			ret += 1
		Endif
	EndWhile
	return ret
EndFunction


int function CountBeltedActors(actor[] actors)
	return CountRestrictedActors(actors, libs.zad_PermitVaginal, zad_DeviousDevice)
EndFunction


Function TogglePanelGag(actor[] actors, bool insert)
	int i = actors.length
	while i > 0
		i -= 1
		if actors[i].WornHasKeyword(libs.zad_DeviousGagPanel)
			if insert
				libs.PlugPanelGag(actors[i])
			Else
				libs.UnPlugPanelGag(actors[i])
			EndIf
		EndIf
	EndWhile
EndFunction


Function StoreHeavyBondage(actor[] originalActors)
	libs.Log("StoreHeavyBondage()")
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedBondage = libs.GetRenderedDeviceInstance(originalActors[i], 0x00010000, libs.zad_DeviousHeavyBondage)
		if storedBondage != None
			libs.Log("Stored Bondage: " + storedBondage)
			StorageUtil.SetFormValue(originalActors[i], "zadStoredBondage", storedBondage)
			originalActors[i].UnequipItem(storedBondage, false, true)
		EndIf
	EndWhile
EndFunction


Function RetrieveHeavyBondage(actor[] originalActors)
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedBondage = StorageUtil.GetFormValue(originalActors[i], "zadStoredBondage")
		if storedBondage != None
			StorageUtil.UnSetFormValue(originalActors[i], "zadStoredBondage")
			originalActors[i].EquipItem(storedBondage, true, true)
		EndIf
	EndWhile
EndFunction

Function StoreBelts(actor[] originalActors)
	libs.Log("StoreBelts()")
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedBelt = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousBelt)
		if storedBelt != None
			libs.Log("Stored Bondage: " + storedBelt)
			StorageUtil.SetFormValue(originalActors[i], "zadstoredBelt", storedBelt)
			originalActors[i].UnequipItem(storedBelt, false, true)
		EndIf
	EndWhile
EndFunction


Function RetrieveBelts(actor[] originalActors)
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedBelt = StorageUtil.GetFormValue(originalActors[i], "zadstoredBelt")
		if storedBelt != None
			StorageUtil.UnSetFormValue(originalActors[i], "zadstoredBelt")
			originalActors[i].EquipItem(storedBelt, true, true)
		EndIf
	EndWhile
EndFunction

Function StoreGags(actor[] originalActors)
	libs.Log("StoreGags()")
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedGag = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousGag)
		if storedGag != None
			libs.Log("Stored Bondage: " + storedGag)
			StorageUtil.SetFormValue(originalActors[i], "zadstoredGag", storedGag)
			originalActors[i].UnequipItem(storedGag, false, true)
		EndIf
	EndWhile
EndFunction

Function StoreUnblockedPlugs(actor[] originalActors)
	libs.Log("StorePlugs()")
	int i = originalActors.Length
	while i > 0
		i -= 1
		if !originalActors[i].WornHasKeyword(libs.zad_DeviousBelt)
			Form storedPlugA = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousPlugAnal)
			Form storedPlugV = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousPlugVaginal)
			if storedPlugA != None 
				libs.Log("Stored Bondage: " + storedPlugA)
				StorageUtil.SetFormValue(originalActors[i], "zadstoredPlugA", storedPlugA)
				originalActors[i].UnequipItem(storedPlugA, false, true)
			EndIf
			if storedPlugV != None
				libs.Log("Stored Bondage: " + storedPlugV)
				StorageUtil.SetFormValue(originalActors[i], "zadstoredPlugV", storedPlugv)
				originalActors[i].UnequipItem(storedPlugV, false, true)
			EndIf
		EndIf
	EndWhile
EndFunction

Function StorePlugs(actor[] originalActors)
	libs.Log("StorePlugs()")
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedPlugA = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousPlugAnal)
		Form storedPlugV = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousPlugVaginal)
		if storedPlugA != None
			libs.Log("Stored Bondage: " + storedPlugA)
			StorageUtil.SetFormValue(originalActors[i], "zadstoredPlugA", storedPlugA)
			originalActors[i].UnequipItem(storedPlugA, false, true)
		EndIf
		if storedPlugV != None
			libs.Log("Stored Bondage: " + storedPlugV)
			StorageUtil.SetFormValue(originalActors[i], "zadstoredPlugV", storedPlugv)
			originalActors[i].UnequipItem(storedPlugV, false, true)
		EndIf
	EndWhile
EndFunction

Function RetrievePlugs(actor[] originalActors)
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedPlugA = StorageUtil.GetFormValue(originalActors[i], "zadstoredPlugA")
		Form storedPlugV = StorageUtil.GetFormValue(originalActors[i], "zadstoredPlugV")
		if storedPlugA != None
			StorageUtil.UnSetFormValue(originalActors[i], "zadstoredPlugA")
			originalActors[i].EquipItem(storedPlugA, true, true)
		EndIf
		if storedPlugV != None
			StorageUtil.UnSetFormValue(originalActors[i], "zadstoredPlugV")
			originalActors[i].EquipItem(storedPlugV, true, true)
		EndIf
	EndWhile
EndFunction

Function RetrieveGags(actor[] originalActors)
	int i = originalActors.Length
	while i > 0
		i -= 1
		Form storedGag = StorageUtil.GetFormValue(originalActors[i], "zadstoredGag")
		if storedGag != None
			StorageUtil.UnSetFormValue(originalActors[i], "zadstoredGag")
			originalActors[i].EquipItem(storedGag, true, true)
		EndIf
	EndWhile
EndFunction

; Returns true if anal sex on this actor is blocked.
; 
Bool Function IsBlockedAnal(Actor akActor)
	If akActor.WornHasKeyword(libs.zad_DeviousBelt)
		Armor belt = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousBelt)
		if !belt.HasKeyword(libs.zad_PermitAnal)
			return true
		EndIf
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousSuit)
		Armor suit = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousSuit)
		if !suit.HasKeyword(libs.zad_PermitAnal)
			return true
		EndIf
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousPlugAnal)
		Armor plug = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousPlugAnal)
		if !plug.HasKeyword(libs.zad_PermitAnal)
			return true
		EndIf
	EndIf	
	Return False
EndFunction

; Returns true if vaginal sex on/by this actor is blocked.
; 
Bool Function IsBlockedVaginal(Actor akActor)
	If akActor.WornHasKeyword(libs.zad_DeviousBelt)
		Armor belt = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousBelt)
		if !belt.HasKeyword(libs.zad_PermitVaginal)
			return true
		EndIf
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousSuit)
		Armor suit = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousSuit)
		if !suit.HasKeyword(libs.zad_PermitVaginal)
			return true
		EndIf
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousPlugVaginal)
		Armor plug = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousPlugVaginal)
		if !plug.HasKeyword(libs.zad_PermitVaginal)
			return true
		EndIf
	EndIf	
	Return False
EndFunction

; Returns true if "breast sex" on this actor is blocked.
; 
Bool Function IsBlockedBreast(Actor akActor)
	Return akActor.WornHasKeyword(libs.zad_DeviousBra) || akActor.WornHasKeyword(libs.zad_DeviousSuit)
EndFunction

; Returns true if oral sex by this actor is blocked.
; 
Bool Function IsBlockedOral(Actor akActor)
	; Two kinds of gags _allow_ "oral": "panel" and "ring". Ring is equipped with PermitOral, panel with DeviousGagPanel.
	Return akActor.WornHasKeyword(libs.zad_DeviousGag) && !akActor.WornHasKeyword(libs.zad_DeviousGagPanel) && !akActor.WornHasKeyword(libs.zad_PermitOral)
EndFunction

;DEPRECATED, not needed anymore
;Bool Function AnimHasNoProblematicDevices(sslThreadController Controller)
;	; this will tell the filter if we're dealing with a scene involving devices we have only very few bound animations for.
;	actor[] originalActors = Controller.Positions
;	Bool result = True
;	int i = originalActors.Length
;	While i > 0
;		i -= 1
;		result = result && !HasElbowbinder(originalActors[i]) && !HasBBYoke(originalActors[i]) && !HasPetSuit(originalActors[i]) && !HasFrontCuffs(originalActors[i]) && !HasElbowShackles(originalActors[i])
;	EndWhile
;	return result
;EndFunction

Bool Mutex = False
Bool SkipFilter = False
; This function can be used to start a scene using valid DD animations. It will try various fallbacks to start a scene, and will also make sure that the filter is bypassed, to increase performance.
Bool Function StartValidDDAnimation(Actor[] SexActors, bool forceaggressive = false, string includetag = "", string suppresstag = "", Actor victim = None, Bool allowbed = False, string hook = "", bool nofallbacks = false)
	libs.log("StartValidDDAnimation called.")
	; This function isn't threadsafe, so we need a mutex
	If Mutex
		libs.log("StartValidDDAnimation aborted: Mutex set.")
		Return False
	EndIf
	; remove all plugs if they are not blocked by a belt:
	StoreUnblockedPlugs(SexActors)
	;unplug panel gags
	TogglePanelGag(SexActors, False)
	SkipFilter = False
	Mutex = True
	sslBaseAnimation[] SAnims
	SAnims = SelectValidDDAnimations(SexActors, SexActors.Length, forceaggressive = forceaggressive, includetag = includetag, suppresstag = suppresstag)
	If Sanims.Length <= 0 && nofallbacks
		; no animations found, and the caller didn't want fallbacks. We can abort here.
		libs.log("SelectValidDDAnimations failed to find any animations. Fallbacks disabled, aborting.")
		Mutex = False
		Return False
	EndIf
	If Sanims.Length <= 0
		; Hide chastity
		libs.log("SelectValidDDAnimations failed to find any animations. Removing belts.")
		StoreBelts(SexActors)
		SAnims = SelectValidDDAnimations(SexActors, SexActors.Length, forceaggressive = forceaggressive, includetag = includetag, suppresstag = suppresstag)
	EndIf
	If Sanims.Length <= 0
		; Hide plugs (chastity is already gone at this point)
		libs.log("SelectValidDDAnimations failed to find any animations. Removing plugs.")
		StorePlugs(SexActors)
		SAnims = SelectValidDDAnimations(SexActors, SexActors.Length, forceaggressive = forceaggressive, includetag = includetag, suppresstag = suppresstag)
	EndIf
	If Sanims.Length <= 0
		; Hide gags
		libs.log("SelectValidDDAnimations failed to find any animations. Removing gags.")
		StoreGags(SexActors)
		SAnims = SelectValidDDAnimations(SexActors, SexActors.Length, forceaggressive = forceaggressive, includetag = includetag, suppresstag = suppresstag)
	EndIf
	If Sanims.Length <= 0
		;Trying last fallback: Hide bindings
		libs.log("SelectValidDDAnimations failed to find any animations. Removing bindings.")
		StoreHeavyBondage(SexActors)
		SAnims = SelectValidDDAnimations(SexActors, SexActors.Length, forceaggressive = forceaggressive, includetag = includetag, suppresstag = suppresstag)
	EndIf
	If Sanims.Length <= 0
		libs.log("StartValidDDAnimation failed. No animations found after fallbacks, aborting.")
		RetrieveHeavyBondage(SexActors)
		RetrieveGags(SexActors)
		RetrievePlugs(SexActors)
		RetrieveBelts(SexActors)
		Mutex = False
		Return False
	EndIf
	;Utility.Wait(1)	; try to keep SexLab from hiccuping.
	SkipFilter = True
	SexLab.StartSex(Positions = SexActors, anims = Sanims, victim = victim, allowbed = allowbed, hook = hook) 		
	Mutex = False
	Return True
EndFunction

Function Logic(int threadID, bool HasPlayer)	
	If SkipFilter
		libs.Log("Animation requested filter bypass, returning.")
		SkipFilter = False
		Return
	EndIf

	Int i = 0
	sslThreadController Controller = Sexlab.ThreadSlots.GetController(threadID)
	Actor[] originalActors = Controller.Positions
	sslBaseAnimation previousAnim = Controller.Animation
	;bound animations disabled in config menu
	;restraints will always be hidden if they are in the way of the selected animation
	If !libs.config.useAnimFilter
		Bool oral = previousAnim.HasTag("Oral")
		Bool vaginal = previousAnim.HasTag("Vaginal") || previousAnim.HasTag("Pussy")
		Bool anal = previousAnim.HasTag("Anal")
		libs.Log("oral = " + oral + " - vaginal = " + vaginal + " anal = " + anal)
		
		While i < originalActors.Length
			;always hide heavy bondage items
			If originalActors[i].WornHasKeyword(libs.zad_DeviousHeavyBondage)
				Armor heavybondage = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousHeavyBondage)
				libs.Log("Found heavy bondage " + heavybondage + " on " + originalActors[i])
				StorageUtil.SetFormValue(originalActors[i], "zadStoredBondage", heavybondage)
				originalActors[i].UnequipItem(heavybondage, False, True)
			EndIf
			;hide gags for oral animations
			If oral
				Armor gag = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousGag)
				If gag && !gag.HasKeyword(libs.zad_PermitOral)
					libs.Log("Found gag " + gag + " on " + originalActors[i])
					If gag.HasKeyword(libs.zad_DeviousGagPanel)
						libs.Log("Unplugging " + gag + " on " + originalActors[i])
						libs.UnPlugPanelGag(originalActors[i])
					Else
						StorageUtil.SetFormValue(originalActors[i], "zadstoredGag", gag)
						libs.Log("Unequipping " + gag + " on " + originalActors[i])
						originalActors[i].UnequipItem(gag, False, True)
					EndIf
				EndIf
			Endif
			;hide chastity belts for vaginal or anal animations
			If vaginal || anal
				Armor belt = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousBelt)
				libs.Log("Found belt " + belt + " on " + originalActors[i])
				If belt && (vaginal || (anal && !belt.HasKeyword(libs.zad_PermitAnal)))
					libs.Log("Unequipping " + belt + " on " + originalActors[i])
					StorageUtil.SetFormValue(originalActors[i], "zadstoredBelt", belt)
					originalActors[i].UnequipItem(belt, False, True)
				EndIf
			EndIf
			;hide plugs for vaginal animations
			If vaginal
				Armor vplug = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousPlugVaginal)
				libs.Log("Found vplug " + vplug + " on " + originalActors[i])
				If vplug
					libs.Log("Unequipping " + vplug + " on " + originalActors[i])
					StorageUtil.SetFormValue(originalActors[i], "zadstoredPlugV", vplug)
					originalActors[i].UnequipItem(vplug, False, True)
				EndIf
			EndIf
			;hide plugs for anal animations
			If anal
				Armor aplug = libs.GetWornRenderedDeviceByKeyword(originalActors[i], libs.zad_DeviousPlugAnal)
				libs.Log("Found aplug" + aplug + " on " + originalActors[i])
				If aplug
					libs.Log("Unequipping " + aplug + " on " + originalActors[i])
					StorageUtil.SetFormValue(originalActors[i], "zadstoredPlugA", aplug)
					originalActors[i].UnequipItem(aplug, False, True)
				EndIf
			EndIf
			i += 1
		EndWhile
		Return
	;bound animation filter enabled
	;fitting animations will be selected based on available holes
	;PAR will take care of arm offsets for bound animations
	;creatures and threesomes are not filtered out by default anymore
	;filtering will not be done for DDc sex scenes
	;restraints will be progressively hidden if no animations are found
	Else
		If previousAnim.HasTag("Oral")
			TogglePanelGag(originalActors, False)
		EndIf
		If previousAnim.HasTag("NoSwap") || previousAnim.HasTag("DeviousDevice") || previousAnim.HasTag("Estrus")
			libs.Log("Animation should not be replaced, returning.")
			Return
		EndIf
		;hide plugs for the duration of the sex scene
		StoreUnblockedPlugs(originalActors)
		
		Bool permitOral = True
		Bool permitVaginal = True
		Bool permitAnal = True
		Bool permitBoobs = True
		Bool noBindings = True
		Bool noPetsuit = True
		i = originalActors.Length
		While i > 0
			i -= 1
			PermitAnal = PermitAnal && !IsBlockedAnal(originalActors[i])
			PermitVaginal = PermitVaginal && !IsBlockedVaginal(originalActors[i])
			PermitBoobs = PermitBoobs && !IsBlockedBreast(originalActors[i])
			PermitOral = PermitOral && !IsBlockedOral(originalActors[i])
			noBindings = noBindings && !libs.NeedsBoundAnim(originalActors[i])
			noPetSuit = noPetSuit && !HasPetSuit(originalActors[i])
		EndWhile
		
		libs.Log("permitAnal = " + permitAnal)
		libs.Log("permitVaginal = " + permitVaginal)
		libs.Log("permitBoobs = " + permitBoobs)
		libs.Log("permitOral = " + permitOral)
		libs.Log("noBindings = " + noBindings)
			
		;If no actor was restrained in any way we can detect, then don't change the animation.
		If PermitAnal && PermitVaginal && PermitOral && PermitBoobs && noBindings && noPetSuit
			libs.Log("No sex-act-restricted actors present in this sex scene, returning.")
			Return
		EndIf
		
		;If the animation does not conflict with any worn restraints, then don't change the animation.
		;inlined the now-deprecated IsValidAnimation function in a reduced form
		If ( (permitBoobs || !previousAnim.HasTag("Boobjob")) && (permitVaginal || !(previousAnim.HasTag("Vaginal")||previousAnim.HasTag("Pussy"))) && (permitAnal || !previousAnim.HasTag("Anal")) && (permitOral || !previousAnim.HasTag("Oral")) && (noBindings || (noPetSuit && !previousAnim.HasTag("Handjob"))))
			libs.Log("Original animation " + previousAnim.name + " does not conflict, returning.")
			Return
		EndIf
		
		;Let's try and see if we can get valid animations right here
		sslBaseAnimation[] anims = SelectValidAnimations(Controller, originalActors.Length, previousAnim, PermitOral, PermitVaginal, PermitAnal, permitBoobs, noBindings)
		;if we didn't get a valid animation, try fallbacks
		If anims.Length <= 0
			If anims.Length <= 0 && !permitVaginal
				;if it STILL doesn't work, we hide belts and plugs too
				libs.Log("No bound animation found. Hiding chastity and plugs.")
				StoreBelts(originalActors)
				StorePlugs(originalActors)
				permitVaginal = True
				permitAnal = True
				anims = SelectValidAnimations(Controller, originalActors.Length, previousAnim, PermitOral, PermitVaginal, PermitAnal, permitBoobs, noBindings)
			EndIf
			If anims.Length <= 0 && !permitOral
				;try removing the gag
				libs.Log("No bound animation found. Hiding gags.")
				StoreGags(originalActors)
				permitOral = True
				anims = SelectValidAnimations(Controller, originalActors.Length, previousAnim, PermitOral, PermitVaginal, PermitAnal, permitBoobs, noBindings)
			EndIf
			If anims.Length <= 0 && !noBindings
				;try to remove the heavy bondage items last
				libs.Log("No bound animation found. Hiding heavy bondage.")
				StoreHeavyBondage(originalActors)
				noBindings = True
				anims = SelectValidAnimations(Controller, originalActors.Length, previousAnim, PermitOral, PermitVaginal, PermitAnal, permitBoobs, noBindings)
			EndIf
		EndIf
		;Failure... clean up animation and pretend it didn't happen... :(
		If anims.Length <= 0
			libs.log("Failed to find any valid animations, aborting.")
			Controller.EndAnimation(quickly=True)
			Return
		EndIf
		
		libs.Log("Overriding animations.")
		Controller.SetForcedAnimations(anims)
		;sort actors into the proper positions, in other words: the bound actor gets fucked
		If !libs.NeedsBoundAnim(originalActors[0]) && originalActors.length > 1
			Actor tmp = originalActors[0]
			originalActors[0] = originalActors[1]
			originalActors[1] = tmp
			Controller.ChangeActors(originalActors)
		EndIf
		Wait_Animating_State(Controller)
		Controller.SetAnimation()
	EndIf
EndFunction


Function Wait_Animating_State(SslThreadController controller)
	float Time = 0.0
	While controller.Getstate() != "Animating" && Time < 5.0
		Time += 0.5
		Utility.Wait(0.5)
	endwhile
	if Time == 5.0
		libs.Log("SexLabThread "+controller+" not get Animating State in 5 seconds but try continue",1); to add WARNING
	else
		libs.Log("SexLabThread "+controller+" get Animating State in "+Time+" seconds")
	endif
EndFunction



Bool Function HasBelt(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousBelt))
EndFunction

Bool Function HasArmbinder(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousArmbinder) || akActor.WornHasKeyword(libs.zad_DeviousArmbinderElbow))
EndFunction

Bool Function HasYoke(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousYoke))
EndFunction

Bool Function HasBBYoke(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousYokeBB))
EndFunction

Bool Function HasFrontCuffs(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousCuffsFront))
EndFunction

Bool Function HasElbowbinder(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousArmbinderElbow))
EndFunction

Bool Function HasArmbinderNonStrict(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousArmbinder)) && !(akActor.WornHasKeyword(libs.zad_DeviousArmbinderElbow))
EndFunction

Bool Function HasPetSuit(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousPetSuit))
EndFunction

Bool Function HasHeavyBondage(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousHeavyBondage))
EndFunction

Bool Function HasStraitJacket(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousStraitJacket))
EndFunction

Bool Function HasElbowShackles(Actor akActor)
	Return (akActor != None) && (akActor.WornHasKeyword(libs.zad_DeviousElbowTie))
EndFunction

;DEPRECATED, not needed anymore
;sslBaseAnimation[] Function GetSoloAnimations(Actor akActor)
;	sslBaseAnimation[] soloAnims
;	Bool bHasBelt = HasBelt(akActor)
;	Bool bHasArmbinder = HasArmbinderNonStrict(akActor) ; Conservative with binding support
;	Bool bHasYoke = HasYoke(akActor) ; Conservative with binding support
;	Bool bHasElbowbinder = HasElbowbinder(akActor)
;	Bool bHasBBYoke = HasBBYoke(akActor)
;	Bool bHasFrontCuffs = HasFrontCuffs(akActor)
;	Bool bHasElbowTie = HasElbowShackles(akActor)
;
;	String gender = "F"
;	if SexLab.GetGender(akActor) == 0
;		gender = "M"
;	Endif
;
;	if bHasBelt || bHasArmbinder || bhasYoke || bHasElbowbinder || bHasBBYoke || bHasFrontCuffs || bHasElbowTie
;		libs.Log("Devious Devices solo scene.")
;
;		soloAnims = New sslBaseAnimation[1]
;		If bHasArmbinder
;			soloAnims[0] = SexLab.GetAnimationObject("DDArmbinderSolo")
;		ElseIf bHasYoke
;			soloAnims[0] = SexLab.GetAnimationObject("DDYokeSolo")
;		ElseIf bHasElbowbinder
;			soloAnims[0] = SexLab.GetAnimationObject("DDElbowbinderSolo")
;		ElseIf bHasBBYoke
;			soloAnims[0] = SexLab.GetAnimationObject("DDBBYokeSolo")
;		ElseIf bHasFrontCuffs
;			soloAnims[0] = SexLab.GetAnimationObject("DDFrontCuffsSolo")
;		ElseIf bHasElbowTie
;			soloAnims[0] = SexLab.GetAnimationObject("DDElbowTieSolo")
;		Else
;			soloAnims[0] = SexLab.GetAnimationObject("DDBeltedSolo")
;		EndIf
;	else
;		libs.Log("Vanilla solo scene.")
;		soloAnims = SexLab.GetAnimationsByTag(1, "Solo", "Masturbation", gender, requireAll = True)
;	Endif
;
;	Return soloAnims
;EndFunction

;DEPRECATED, sex scenes will not be broken up anymore, restraint hiding is preferred instead
;function ProcessSolos(actor[] solos)
;	int i = solos.length
;	while i > 0
;		i -= 1
;		if solos[i] != none && !SexLab.ActorLib.IsCreature(solos[i]) ; the creatures not have masturbation animations
;			libs.Log("Starting solo scene for " + solos[i].GetLeveledActorBase().GetName())
;			sslBaseAnimation[] soloAnims = GetSoloAnimations(solos[i])
;
;			if soloAnims.length <= 0
;				libs.Log("Could not find valid solo scene for " + solos[i].GetLeveledActorbase().GetName())
;				libs.Notify("Could not find valid solo scene for " + solos[i].GetLeveledActorBase().GetName() + ".")
;			else
;				actor[] solosTmp = new actor[1] ; There must be a better way.
;				solosTmp[0] = solos[i]
;				SexLab.UnequipStrapon(solos[i])
;				SexLab.StartSex(solosTmp, soloAnims)
;			Endif
;		EndIf
;	EndWhile
;EndFunction


Event OnAnimationStart(int threadID, bool HasPlayer)
	libs.Log("OnAnimationStart()")
    Logic(threadID, hasPlayer)
EndEvent


Event OnLeadInEnd(int threadID, bool HasPlayer)
if libs.config.useAnimFilter ;so DD doesn't mess with this if the user wants to change the animation and has the filters turned off
    libs.Log("OnLeadInEnd()")
    Logic(threadID, hasPlayer)
endif
EndEvent


Event OnAnimationChange(int threadID, bool HasPlayer)
if libs.config.useAnimFilter ;so DD doesn't mess with this if the user wants to change the animation and has the filters turned off
    libs.Log("OnAnimationChange()")
    Logic(threadID, hasPlayer)
endif
EndEvent


Function ChangeLockState(actor[] actors, bool lockState)
	int i = actors.length
	while i > 0
		i -= 1
	 	if HasBelt(actors[i]) || StorageUtil.GetFloatValue(actors[i], "zad.StoredExposureRate", 0.0) >= 1; Avoid potential race-condition
			string 	tmp
			float exposureRate = 0
			if !lockState
				tmp = "Unlocked"
				exposureRate = 	libs.GetModifiedRate(actors[i])
				SexLab.Stats.SetFloat(actors[i], "LastSex.GameTime", StorageUtil.GetFloatValue(actors[i], "zad.GameTimeLock"))
				SexLab.Stats.SetFloat(actors[i], "LastSex.RealTime", StorageUtil.GetFloatValue(actors[i], "zad.RealTimeLock"))
				StorageUtil.UnsetFloatValue(actors[i], "zad.GameTimeLock")
				StorageUtil.UnsetFloatValue(actors[i], "zad.RealTimeLock")
			else
				tmp = "Locked"
				StorageUtil.SetFloatValue(actors[i], "zad.RealTimeLock", Sexlab.Stats.GetFloat(actors[i], "LastSex.RealTime"))
				StorageUtil.SetFloatValue(actors[i], "zad.GameTimeLock", Sexlab.Stats.GetFloat(actors[i], "LastSex.GameTime"))
				exposureRate = 0
			Endif
			libs.Log("" + tmp + " arousal for actor " + actors[i].GetLeveledActorBase().GetName())
			Aroused.SetActorExposureRate(actors[i], exposureRate)
		Endif
	EndWhile
EndFunction


Event OnOrgasmStart(int threadID, bool HasPlayer)
	actor[] actors = Sexlab.ThreadSlots.GetController(threadID).Positions
	if CountBeltedActors(actors) <= 0
	 	return
	endif
	libs.Log("OnOrgasmStart()")
	ChangeLockState(actors, true)
EndEvent


Function RefreshBlindfoldState(actor[] actors)
	int i = actors.length
	while i > 0
		i -= 1
		if actors[i] == libs.PlayerRef && libs.PlayerRef.WornHasKeyword(libs.zad_DeviousBlindfold)
			game.ForceFirstPerson()
			game.ForceThirdPerson()
		EndIf
	EndWhile
EndFunction


Event OnAnimationEnd(int threadID, bool HasPlayer)
	libs.Log("OnAnimationEnd()")
	sslThreadController Controller = Sexlab.ThreadSlots.GetController(threadID)
	actor[] actors = controller.Positions
	sslBaseAnimation previousAnim = controller.Animation
	int numBeltedActors = CountBeltedActors(controller.Positions)
	if (BoundMasturbation.Find(previousAnim.name) >=0 ) && actors.length == 1
		if actors[0]!=libs.PlayerRef
			libs.NotifyNPC(actors[0].GetLeveledActorbase().GetName() + " ceases her efforts, looking both frustrated and aroused.")
		else
			libs.NotifyPlayer("With a sigh, you realize that this is futile. You cannot possibly reach yourself, bound as you are. Your struggle has left you feeling even more aroused than when you began.", true)
		Endif
	EndIf
	If (numBeltedActors > 0) && previousAnim.name=="DDBeltedSolo" && actors.length==1
		if actors[0]!=libs.PlayerRef
			libs.NotifyNPC(actors[0].GetLeveledActorbase().GetName() + " ceases her efforts, looking both frustrated and aroused.")
		else
			libs.NotifyPlayer("With a sigh, you realize that this is futile. You cannot fit even a single finger beneath the cruel embrace of the belt. Your struggle has left you feeling even more aroused than when you began.", true)
		Endif
	Endif
	TogglePanelGag(actors, True)
	RetrieveHeavyBondage(actors)
	RetrieveBelts(actors)
	RetrieveGags(actors)
	RetrievePlugs(actors)
	RefreshBlindfoldState(actors)
	Utility.Wait(5)
	ChangeLockState(actors, false)
EndEvent


function RelieveSelf()
    libs.Log("RelieveSelf()")
    sslBaseAnimation[] anims = SexLab.GetAnimationsByTag(1, "Solo", "Masturbation", "F", requireAll=true)
    if anims.length <=0
        libs.Warn("No masturbation animations available. Skipping scene.")
    else
        actor[] actors = new actor[1]
        actors[0] = libs.PlayerRef
        SexLab.StartSex(actors, anims)
    endif
    SetStage(100)
EndFunction

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)	
	libs.Log("OnSleepStart()")
	; add sleep time to some timed functions to prevent players from just sleeping it out...
	float naplength = afDesiredSleepEndTime - afSleepStartTime
	libs.LastInflationAdjustmentVaginal += naplength
	libs.LastInflationAdjustmentAnal += naplength
EndEvent

Event OnSleepStop(bool abInterrupted)
	libs.Log("OnSleepStop()")
	if abInterrupted
		return
	EndIf
	actor akActor = libs.PlayerRef
	if !HasBelt(akActor)
		return
	Endif
	int arousal = Aroused.GetActorExposure(akActor)
	Message tmp
	if arousal >= libs.ArousalThreshold("Desperate")
		tmp = zad_eventSleepStopDesperate
	elseIf arousal >= libs.ArousalThreshold("Horny")
		tmp = zad_eventSleepStopHorny
	elseIf arousal >= libs.ArousalThreshold("Desire")
		tmp = zad_eventSleepStopDesire
	else
		tmp = zad_eventSleepStopContent
	Endif
	tmp.Show()
	libs.PlayThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny"), utility.RandomInt(5,9))
EndEvent

; helper function to translate strings passed to the ModEvent() item equip feature
KeyWord Function GetKeywordByString(String s)
	If s == "Hood"
		Return libs.zad_DeviousHood
	ElseIf s == "Suit"
		Return libs.zad_DeviousSuit
	ElseIf s == "Gloves"
		Return libs.zad_DeviousGloves
	ElseIf s == "Boots"
		Return libs.zad_DeviousBoots
	ElseIf s == "Gag"
		Return libs.zad_DeviousGag
	; We are generous and allow variations in spelling, because people are going to do that anyway.
	ElseIf s == "BallGag" || s == "Ball Gag"
		Return libs.zad_DeviousGag
	ElseIf s == "PanelGag" || s == "Panel Gag"
		Return libs.zad_DeviousGag
	ElseIf s == "RingGag" || s == "Ring Gag"
		Return libs.zad_DeviousGag
	ElseIf s == "Collar"
		Return libs.zad_DeviousCollar	
	ElseIf s == "Armbinder"
		Return libs.zad_DeviousArmbinder
	ElseIf s == "Yoke"
		Return libs.zad_DeviousYoke
	ElseIf s == "Blindfold"
		Return libs.zad_DeviousBlindfold
	ElseIf s == "Harness"
		Return libs.zad_DeviousHarness
	ElseIf s == "Corset"
		Return libs.zad_DeviousCorset
	ElseIf s == "ArmCuffs" || s == "Arm Cuffs"
		Return libs.zad_DeviousArmCuffs
	ElseIf s == "LegCuffs" || s == "Leg Cuffs"
		Return libs.zad_DeviousLegCuffs
	ElseIf s == "Belt" || s == "Chastity Belt" || s == "ChastityBelt"
		Return libs.zad_DeviousBelt
	ElseIf s == "Bra" || s == "Chastity Bra" || s == "ChastityBra"
		Return libs.zad_DeviousBra
	ElseIf s == "NipplePiercings" || s == "Nipple Piercings"
		Return libs.zad_DeviousPiercingsNipple
	ElseIf s == "VaginalPiercings" || s == "Vaginal Piercings"
		Return libs.zad_DeviousPiercingsVaginal
	ElseIf s == "VaginalPlug" || s == "Vaginal Plug"
		Return libs.zad_DeviousPlugVaginal
	ElseIf s == "AnalPlug" || s == "Anal Plug"
		Return libs.zad_DeviousPlugAnal
	Endif
	Return None
EndFunction

Event OnDDIEquipDevice(Form akActor, String DeviceType)
	Actor a = akActor As Actor
	String tags = ""
	; Adding support for optional tags separated from device string by a '|' - ex: 'Collar|metal,black'
	Int iTagsIndex 
	String sDevice = ""
	String sTags = ""
	; Split _args between Device and Tags (separated by '|')
	iTagsIndex = StringUtil.Find(DeviceType, "|")
	if (iTagsIndex!=-1)
		sDevice = StringUtil.Substring(DeviceType, 0, iTagsIndex )
		sTags = StringUtil.Substring(DeviceType, iTagsIndex +1 )
		DeviceType = sDevice
	endIf
	libs.log("DDI ModEvent equip request received. Trying to equip device: " + DeviceType + " on " + a.GetLeveledActorBase().GetName())
	KeyWord kw = GetKeywordByString(DeviceType)	
	; check for invalid return values and bail out if no valid davice was passed.
	If !kw || !a
		libs.log("DDI ModEvent failed. No valid device string or no valid actor received.")
		return
	Endif
	Bool reqall = false
	; special cases
	if DeviceType == "BallGag" || DeviceType == "Ball Gag"
		tags = "ball"
		reqall = true
	Endif
	if DeviceType == "RingGag" || DeviceType == "Ring Gag"
		tags = "ring"
		reqall = true
	Endif
	if DeviceType == "PanelGag" || DeviceType == "Panel Gag"
		tags = "panel"
		reqall = true
	Endif
	armor iDevice 

	if (tags!="")
		tags = tags + "," + sTags
	else
		tags = sTags
	endif

	If tags == ""
		iDevice = libs.GetGenericDeviceByKeyword(Kw)
	Else
		iDevice = libs.GetDeviceByTags(Kw, tags, reqall, tagsToSuppress = "", fallBack = true)
	Endif
	if !iDevice
		libs.log("DDI ModEvent failed. No matching device found.")
		return
	Endif
	armor rDevice = libs.GetRenderedDevice(iDevice)
	libs.equipDevice(a, iDevice, rDevice, Kw, skipEvents = false, skipMutex = true)
EndEvent

Event OnDDIRemoveDevice(Form akActor, String DeviceType)
	Actor a = akActor As Actor
	libs.log("DDI ModEvent device remove request received. Trying to remove device: " + DeviceType + " from " + a.GetLeveledActorBase().GetName())
	KeyWord kw = GetKeywordByString(DeviceType)	
	; check for invalid return values and bail out if no valid davice was passed.
	If !kw || !a
		libs.log("DDI ModEvent failed. No valid device string or no valid actor received.")
		return
	Endif
	Armor iDevice = libs.GetWornDevice(a, kw)
	If !iDevice
		libs.log("DDI ModEvent device removal failed: " + a.GetLeveledActorBase().GetName() + " is not wearing the requested device type.")
		return
	Endif
	if libs.ManipulateGenericDeviceByKeyword(a, Kw, false, skipEvents = false, skipMutex = true)
		libs.log("DDI ModEvent:. Successfully removed device.")
	Else
		libs.log("DDI ModEvent device removal failed on " + a.GetLeveledActorBase().GetName() + ". Likely cause: Worn item is a non generic device.")
	Endif
EndEvent

Event OnDDICreateRestraintsKey(Form akActor)
	Actor a = akActor As Actor
	If !a
		libs.log("DDI ModEvent failed. No valid actor received.")
		return
	Endif
	libs.log("DDI ModEvent create key request received. Trying to give a restraints key to: " + a.GetLeveledActorBase().GetName())	
	a.Additem(libs.RestraintsKey, 1)
EndEvent
	
Event OnDDICreateChastityKey(Form akActor)
	Actor a = akActor As Actor
	If !a
		libs.log("DDI ModEvent failed. No valid actor received.")
		return
	Endif
	libs.log("DDI ModEvent create key request received. Trying to give a chastity key to: " + a.GetLeveledActorBase().GetName())	
	a.Additem(libs.ChastityKey, 1)
EndEvent

Event OnDDICreatePiercingKey(Form akActor)
	Actor a = akActor As Actor
	If !a
		libs.log("DDI ModEvent failed. No valid actor received.")
		return
	Endif
	libs.log("DDI ModEvent create key request received. Trying to give a piercing key to: " + a.GetLeveledActorBase().GetName())	
	a.Additem(libs.PiercingKey, 1)
EndEvent	
