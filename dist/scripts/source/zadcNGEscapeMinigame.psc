Scriptname zadcNGEscapeMinigame extends Quest
{Script controller for an unlock minigame for a Devious Devices Contraption.}

; This minigame is intended to be played when a player is locked into and trying to escape a Devious Devices furniture device (a "contraption").
; The basic idea of the minigame is that to free themselves, the player has to hold a specific sequence of movement keys for at least a certain amount of time.
; If a player hits the wrong key or doesn't hold it long enough, the entered sequence resets and they have to start over.
; E.g. if the sequence is "WDSA", if the player first hits "W" they will get FX to indicate the first guess is correct. If they then hit "S" they get FX to indicate their 
; guess for the second key is wrong (a "fail"). They then have to start from the first key again, which if they paid attention they should know is "W".
; There is an optional chance to allow for a "critical fail". This is a chance that on a fail a new sequence to guess is rolled, e.g. if it was "WDSA", it could become "SDWA".
; All previously memorized keys are then useless and the player has to start over. A critical fail has its own FX to indicate to the player that it happened.
; A further difficulty setting is "escalation". If so, on a critical fail there is an additional chance that the new sequence is longer than the previous one,
; e.g. if it was "WDSA", it could become "SADWA". This introduces some risk to the game: wrong guesses or just bad luck can make the game much harder.
; All these options can be controlled via an MCM, or set manually by a mod author by calling SetDifficultyParameters after calling StartMinigame.
; Starting the minigame, and succeeding on or failing an input all send modEvents that can be caught externally to hook into the minigame.
; For example, you could catch the zadc_EscapeMinigameProgress event and use it to make a nearby NPC detect that the player is trying to escape.
; Or listen for the zadc_EscapeMinigameFail event to count the number of fails and when this exceeds a number, make an NPC come free the player.

; ================================ API ================================

; Starts the minigame. Requires the player to be locked in a contraption first. If not, will warn.
Function StartMinigame()
	contraption = DDclibs.GetDevice(PlayerRef) as zadcFurnitureScript
	If contraption == None
		Debug.Notification("[zadc-NG] Cannot start contraption struggle escape minigame because player is not locked into a contraption.")
		DDLibs.Log("[zadc-NG] Cannot start contraption struggle escape minigame because player is not locked into a contraption.", level=1)
		Return
	EndIf

	; Slot the appropriate sounds depending on the player sex and gag status
	SlotAppropriateSounds()

	; Set the difficulty using the settings from the MCM
	SetDifficultyParameters()

	; Register for the DD orgasm event so we can suspend the minigame controls while that happens.
	RegisterForModEvent("DeviceActorOrgasmEx", "SuspendMinigameWhileOrgasming")

	; Take control and set up minigame state
	GenerateNewRequiredCode()
	RegisterControls()
	SendStartMinigameModEvent()
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Started minigame.")

	; Show a tutorial message to get started
	If Config.ShowMinigameTutorial
		zadcNG_Minigame03TutorialMsg01.ShowAsHelpMessage("zadcNG_ContraptionMinigame03_01", afDuration=7, afInterval=0, aiMaxTimes=1)
		Utility.Wait(7.0)
		zadcNG_Minigame03TutorialMsg02.ShowAsHelpMessage("zadcNG_ContraptionMinigame03_02", afDuration=7, afInterval=0, aiMaxTimes=1)
		Utility.Wait(7.0)
		zadcNG_Minigame03TutorialMsg03.ShowAsHelpMessage("zadcNG_ContraptionMinigame03_03", afDuration=7, afInterval=0, aiMaxTimes=1)
	EndIf

	_isSuspended = false
EndFunction

; Suspends the minigame, but keeps the player locked into the contraption with all minigame state intact.
Function SuspendMinigame()
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Suspending minigame.")
	_isSuspended = true
EndFunction

; Resumes a suspended minigame.
Function ResumeMinigame()
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) resuming minigame.")
	_isSuspended = false
EndFunction

; Returns whether the minigame is currently suspended.
bool Function IsSuspended()
	return _isSuspended
EndFunction

; Stops the minigame and unlocks the player.
Function StopMinigame()
	Stop()
EndFunction

; Sets difficulty options of the minigame. Call this function *after* StartMinigame and specify the parameters manually.
; Every specified option will be locked and cannot be changed from the MCM until the minigame has ended and restarted.
; Every option not specified is loaded from its default in the config script / MCM and will not be locked.
Function SetDifficultyParameters(Int MinimumActions = -1, Int MaximumActions = -1, Float MinHoldTime = -1.0, Float MaxHoldTime = -1.0, Float CriticalFailChance = -1.0, Float EscalationChance = -1.0)
	If MinimumActions < 1
		If !MinimumLengthOfSequenceLocked
			MinimumLengthOfSequence = Config.MinigameMinSequenceLength
		EndIf
	Else
		MinimumLengthOfSequence = MinimumActions
		MinimumLengthOfSequenceLocked = True
		If MinimumLengthOfSequence > requiredCode.Length
			DDLibs.Log("[zadc-NG] Requested starting length of sequence " + MinimumLengthOfSequence + " exceeds allocated array size of " + requiredCode.Length + ". Clamping length to " + requiredCode.Length + ".", level=1)
			LengthOfSequence = requiredCode.Length
		EndIf
	EndIf

	If MaximumActions < 1
		If !MaximumLengthOfSequenceLocked
			MaximumLengthOfSequence = Config.MinigameMaxSequenceLength
		EndIf
	Else
		MaximumLengthOfSequence = MaximumActions
		MaximumLengthOfSequenceLocked = True
		If MaximumLengthOfSequence > requiredCode.Length
			DDLibs.Log("[zadc-NG] Requested maximum length of sequence " + MaximumLengthOfSequence + " exceeds allocated array size of " + requiredCode.Length + ". Clamping length to " + requiredCode.Length + ".", level=1)
			MaximumLengthOfSequence = requiredCode.Length
		EndIf
	EndIf

	If MinHoldTime < 0.0
		If !MinKeyHoldTimeLocked
			MinKeyHoldTime = Config.MinigameMinKeyHoldTime 
		EndIf
	Else
		MinKeyHoldTime = MinHoldTime
		MinKeyHoldTimeLocked = True
	EndIf

	If MaxHoldTime < 0.0
		If !MaxKeyHoldTimeLocked
			MaxKeyHoldTime = Config.MinigameMaxKeyHoldTime 
		EndIf
	Else
		MaxKeyHoldTime = MaxHoldTime
		MaxKeyHoldTimeLocked = True
	EndIf

	If CriticalFailChance < 0.0
		If !CriticalFailChanceLocked
			CriticalFailChancePercent = Config.MinigameCriticalFailChance
		EndIf
	Else
		CriticalFailChancePercent = CriticalFailChance
		CriticalFailChanceLocked = True
	EndIf

	If EscalationChance < 0.0
		If !EscalationChanceLocked
			EscalationChancePercent = Config.MinigameEscalationChance
		EndIf
	Else
		EscalationChancePercent = EscalationChance
		EscalationChanceLocked = True
	EndIf

	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Difficulty set. Min actions: " + MinimumLengthOfSequence + ", Max actions: " + MaximumLengthOfSequence + ", Min hold time: " + MinKeyHoldTime + ", Max hold time: " + MaxKeyHoldTime + ", Crit fail%: " + CriticalFailChancePercent + ", Escalate%: " + EscalationChancePercent)
	lengthOfSequence = MinimumLengthOfSequence
EndFunction

; Difficulty locks. If set to true, these prevent the respective difficulty options from being changed if the MCM changes while the minigame is active.
; Specifying difficulty options via SetDifficultyParameters will set these flags automatically. 
bool Property MinimumLengthOfSequenceLocked = False Auto Hidden
bool Property MaximumLengthOfSequenceLocked = False Auto Hidden
bool Property MinKeyHoldTimeLocked = False Auto Hidden
bool Property MaxKeyHoldTimeLocked = False Auto Hidden
bool Property CriticalFailChanceLocked = False Auto Hidden
bool Property EscalationChanceLocked = False Auto Hidden

; (Read-only) The total number of keys that have to be guessed in the *current* sequence. Escalation can change this.
int Property NumberOfKeysToGuess
int Function Get()
	return LengthOfSequence
EndFunction
EndProperty

; (Read-only) The number of keys in the current sequence that the player has already guessed.
int Property NumberOfKeysGuessed
int Function Get()
	return nrEnteredKeys
EndFunction
EndProperty

; ================= CODE BELOW IS CONSIDERED INTERNAL - DO NOT CALL EXTERNALLY ==================

zadConfig Property Config Auto

zadlibs Property DDlibs Auto
zadclibs Property DDclibs Auto

Faction Property zadAnimatingFaction Auto
Actor Property PlayerRef Auto
Sound Property zadShortPant Auto
Sound Property zadNG_BreathingFemaleTiredLP Auto
Sound Property zadNG_BreathingMaleTiredLP Auto
Sound Property zadNG_BreathingFemaleTired Auto
Sound Property zadNG_BreathingMaleTired Auto
Sound Property zadNG_InhaleFemale Auto
Sound Property zadNG_InhaleMale Auto
Sound Property zadNG_GruntFemaleMild Auto
Sound Property zadNG_GruntMaleMild Auto
Sound Property zadNG_GruntFemaleFrustrated Auto
Sound Property zadNG_GruntMaleFrustrated Auto
Sound Property zadNG_PantFemaleMild Auto
Sound Property zadNG_PantMaleMild Auto
Sound Property zadNG_WoodCreak Auto
Sound Property zadNG_WhisperSuccessFemale Auto
Sound Property zadNG_WhisperSuccessMale Auto
Sound Property zadNG_YesGaggedFemale Auto
Sound Property zadNG_YesGaggedMale Auto
Message Property zadcNG_Minigame03TutorialMsg01 Auto
Message Property zadcNG_Minigame03TutorialMsg02 Auto
Message Property zadcNG_Minigame03TutorialMsg03 Auto
Keyword Property zad_DeviousGag Auto
Spell Property zadcNG_FlashGreen Auto
Spell Property zadcNG_FlashRed Auto
Spell Property zadcNG_FlashPurpleBig Auto

zadcFurnitureScript contraption = None
bool _isSuspended = false Conditional

; Sounds. These are set to appropriate sounds depending on player sex and whether they are gagged.
sound breathingTiredLP = None
sound breathingTired = None
sound inhale = None
sound gruntMild = None
sound gruntFrustrated = None
sound pantMild = None
sound progressSound = None

; Difficulty settings. These can be controlled via the MCM too, but can be overwritten with an API call for customization.
Int MinimumLengthOfSequence
Int MaximumLengthOfSequence
Float MinKeyHoldTime
Float MaxKeyHoldTime
Float CriticalFailChancePercent
Float EscalationChancePercent

Package currentAnim = None
bool cooldown = false
int durationHintState = 0 ; The states are: 0 = no hint given yet, 1 = "halfway" or "almost done" hint given, 2 = "duration well exceeded" hint given
int lengthOfSequence = 1 Conditional
int breathingLPSoundID = -1

Event OnInit()
	validKeys = new int[4]
	validKeys[0] = Input.GetMappedKey("Back")
	validKeys[1] = Input.GetMappedKey("Forward")
	validKeys[2] = Input.GetMappedKey("Strafe Left")
	validKeys[3] = Input.GetMappedKey("Strafe Right")

	requiredCode = new int[16]
	requiredDurations = new float[16]
	enteredCode = new int[16]
EndEvent

Event OnUpdate()
	; If key is still held, play sounds to give hints on the required duration
	If keyHeld != -1 
		If durationHintState == 0
			gruntMild.Play(PlayerRef)
			durationHintState = 1
			
			; Schedule the next hint sound to play when the required duration is well exceeded: one full duration past whatever was needed for the first hint, but never too short or it'd be silly.
			RegisterForSingleUpdate( MaxFloat(requiredDurations[nrEnteredKeys], 8.0) )
		ElseIf durationHintState == 1
			breathingLPSoundID = breathingTiredLP.Play(PlayerRef)
		EndIf
	EndIf
EndEvent

Function Fail()
	; Critical fail chance is increased if a vibration effect is active, and further increased if that happens at high arousal.
	; The extra chance ranges from +10% to +60%. This makes it quite risky to fail during vibration events. Maybe just sit back instead for a bit, hm? ;-)
	float critFailPct = CriticalFailChancePercent
	if DDLibs.IsVibrating(PlayerRef) && CriticalFailChancePercent > 0.0 ; If crit fail% is 0, assume there's a good reason for it and don't increase it.
		critFailPct += 10.0 + DDlibs.Aroused.GetActorExposure(PlayerRef) / 2.0
	EndIf
	
	; Check for critical fail.
	If Utility.RandomFloat(0, 100) < critFailPct
		; If so, roll a new sequence, possibly a longer one than before (escalation). Play SFX and VFX for some feedback.
		CriticalFail(EscalationChancePercent)
	Else
		; Regular fail. Play (different) VFX/SFX and only reset the entered code, but don't make it longer.
		RegularFail()
	EndIf
EndFunction

Function CriticalFail(float escalationChancePct)
	; Roll a new sequence, possibly a longer one than before. Play SFX and VFX for some feedback.
	bool escalate = Utility.RandomFloat(0, 100) < escalationChancePct && lengthOfSequence < MaximumLengthOfSequence
	SendFailModEvent(wasCriticalFail=true, wasEscalated=escalate)
	PlayerRef.SetExpressionOverride(aiMood=9, aiStrength=90) ; 9 = Mood Fear
	zadcNG_FlashPurpleBig.Cast(PlayerRef)
	gruntFrustrated.Play(PlayerRef)
	Utility.Wait(0.3)
	zadNG_WoodCreak.Play(PlayerRef)
	Utility.Wait(0.7)
	breathingTired.Play(PlayerRef)
	If escalate
		EscalateSequence()
	Else
		If Config.ShowMinigameNotifications
			Debug.Notification("A wrong move shifted your binds, and you have to start over.")
		EndIf
	EndIf
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Critical fail triggered, re-randomizing the code to guess...")
	GenerateNewRequiredCode()
	ResetEnteredCode()
EndFunction

Function EscalateSequence()
	lengthOfSequence += 1
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Critical fail escalated length of sequence from " + (lengthOfSequence - 1) + " to " + lengthOfSequence + ".")
	If Config.ShowMinigameNotifications
		Debug.Notification("You fear you've just made your bonds even tighter...")
	EndIf
EndFunction

Function RegularFail()
	; Regular fail. Only reset the entered code, not anything else.
	SendFailModEvent(wasCriticalFail=false, wasEscalated=false)
	PlayerRef.SetExpressionOverride(aiMood=8, aiStrength=90) ; 8 = Mood Anger
	zadcNG_FlashRed.Cast(PlayerRef)
	gruntFrustrated.Play(PlayerRef)
	Utility.Wait(0.3)
	zadNG_WoodCreak.Play(PlayerRef)
	If (nrEnteredKeys > 2)
		; Extra cooldown depending on how far player got into sequence.
		; This just feels appropriate: if you fail early you want to try again fast, if you fail late you need a second to reset.
		breathingTired.Play(PlayerRef)
		Utility.Wait(nrEnteredKeys / 2)
	EndIf
	ResetEnteredCode()
	If Config.ShowMinigameNotifications
		Debug.Notification("That didn't work, but you're ready to try again.")
	EndIf
EndFunction

Function Success()
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) player entered the correct code. Stopping minigame.")
	StopMinigame()
EndFunction

Function Progress()
	; Correct, but not done yet. Play VFX / SFX to indicate progress.
	SendProgressModEvent()
	PlayerRef.SetExpressionOverride(aiMood=10, aiStrength=70) ; 10 = Mood Happy
	zadcNG_FlashGreen.Cast(PlayerRef)
	progressSound.Play(PlayerRef)
	
	; Let the player know if they reach the halfway point
	If nrEnteredKeys > LengthOfSequence / 2
		Debug.Notification("Your binds are starting to feel looser...")
	EndIf

	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Entered " + nrEnteredKeys + "-digit code is: " + enteredCode)
EndFunction

Function SlotAppropriateSounds()
	If PlayerRef.GetActorBase().GetSex() == 0
		gruntMild = zadNG_GruntMaleMild
		gruntFrustrated = zadNG_GruntMaleFrustrated
		pantMild = zadNG_PantMaleMild
		breathingTired = zadNG_BreathingMaleTired
		breathingTiredLP = zadNG_BreathingMaleTiredLP
		inhale = zadNG_InhaleMale
		If PlayerRef.WornHasKeyword(zad_DeviousGag)
			progressSound = zadNG_YesGaggedMale
		Else
			progressSound = zadNG_WhisperSuccessMale
		EndIf
	Else
		gruntMild = zadNG_GruntFemaleMild
		gruntFrustrated = zadNG_GruntFemaleFrustrated
		pantMild = zadNG_PantFemaleMild
		breathingTired = zadNG_BreathingFemaleTired
		breathingTiredLP = zadNG_BreathingFemaleTiredLP
		inhale = zadNG_InhaleFemale
		If PlayerRef.WornHasKeyword(zad_DeviousGag)
			progressSound = zadNG_YesGaggedFemale
		Else
			progressSound = zadNG_WhisperSuccessFemale
		EndIf
	EndIf
EndFunction

Function EndMinigame()
	keyHeld = -1
	If breathingLPSoundID > 0
		Sound.StopInstance(breathingLPSoundID)
	EndIf
	breathingLPSoundID = -1
	PlayerRef.ClearExpressionOverride()
	UnregisterForModEvent("DeviceActorOrgasmEx")
	UnregisterForAllKeys()
	contraption.scriptedDevice = false
	contraption.UnlockActor()
	contraption = None
	Message.ResetHelpMessage("zadcNG_ContraptionMinigame03_01")
	Message.ResetHelpMessage("zadcNG_ContraptionMinigame03_02")
	Message.ResetHelpMessage("zadcNG_ContraptionMinigame03_03")
	cooldown = false
	_isSuspended = false
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Stopped minigame.")
EndFunction

; ================================ Controls & core logic ================================ 

int[] validKeys
int keyHeld = -1
int[] requiredCode
float[] requiredDurations
int[] enteredCode
int nrEnteredKeys = 0 Conditional

Function RegisterControls()
	int i = validKeys.Length
	While i > 0
		i -= 1
		RegisterForKey(validKeys[i])
	EndWhile
EndFunction

Event OnKeyDown(Int keyCode)
	; Only one key can be held at a time, and no input is processed during cooldown or while the minigame is suspended.
	If cooldown || _isSuspended || keyHeld != -1
		return
	EndIf

	; Check whther the MCM changed and we need to update the difficulty options of the game.
	if Config.ScheduleMinigameOptionsUpdate
		SetDifficultyParameters()
		Config.ScheduleMinigameOptionsUpdate = False
	endIf

	keyHeld = keyCode

	; Play a sound for some feedback
	inhale.Play(PlayerRef)

	; start struggle animation
	PlayerRef.SetExpressionOverride(aiMood=14, aiStrength=45) ; 14 = Mood Disgusted
	ActorUtil.RemovePackageOverride(PlayerRef, currentAnim)
	currentAnim = contraption.PickRandomStruggle()
	ActorUtil.AddPackageOverride(PlayerRef, currentAnim, 100)
	PlayerRef.EvaluatePackage()

	; Schedule a sound to play when the keypress duration is met as feedback / hint.
	RegisterForSingleUpdate(requiredDurations[nrEnteredKeys])
	durationHintState = 0
EndEvent

Event OnKeyUp(Int keyCode, float heldTime)
	; Don't process during cooldown, and guard against button spam by only processing the one held key
	If cooldown || keyCode != keyHeld
		return
	EndIf
	cooldown = true

	; Stop struggle anim, go back to passive contraption pose
	ActorUtil.RemovePackageOverride(PlayerRef, currentAnim)
	currentAnim = contraption.PickRandomPose()
	ActorUtil.AddPackageOverride(PlayerRef, currentAnim, 99)
	PlayerRef.EvaluatePackage()

	; Prevent the onupdate from one keypress from spilling over into the next.
	UnregisterForUpdate()

	; Stop breathing sound, if it's playing
	If breathingLPSoundID > 0
		Sound.StopInstance(breathingLPSoundID)
	EndIf

	; Check if the correct key was held and for long enough
	If keyCode != requiredCode[nrEnteredKeys] || heldTime < requiredDurations[nrEnteredKeys]
		; Wrong key or not held long enough. Either way: fail and try again.
		Fail()
	ElseIf nrEnteredKeys < LengthOfSequence - 1
		; Correct, but not done yet. Play VFX / SFX to indicate progress, and increment the code.
		enteredCode[nrEnteredKeys] = keyCode
		nrEnteredKeys += 1
		Progress()
	Else
		; Last key in sequence. Success!
		Success()
	EndIf

	keyHeld = -1
	cooldown = false
EndEvent

; ================================= Passcode logic ================================= 

Function GenerateNewRequiredCode()
	; Initialize as simple sequence: fill the whole array of length A as [0, 1, ..., M-1, 0, 1, ..., M-1] where M is the number of keys that can be pressed.
	; Map each number to a valid input button / key.
	; Generate the required durations while we're at it.
	int i = requiredCode.Length
	While i > 0
		i -= 1
		requiredCode[i] = validKeys[i % validKeys.Length]
		requiredDurations[i] = Utility.RandomFloat(MinKeyHoldTime, MaxKeyHoldTime)
	EndWhile

	; Shuffle the code into random order with Fisher-Yates (aka Knuth) shuffle
	int swap
	i = validKeys.Length ; This is intentionally the *input key* array length M, so that e.g. if M=4, N=3 and A=12, we only shuffle [0,1,2,3] of a sequence [0,1,2,3,0,1,2,3,0,1,2,3]. This guarantees that numbers are only minimally reoccurring.
	While i > 0
		i -= 1
		int j = Utility.RandomInt(0, i)
		swap = requiredCode[j]
		requiredCode[j] = requiredCode[i]
		requiredCode[i] = swap
	EndWhile

	; We will take the first N digits of this code to be the required code.
	; For short codes (say N=3, M=4) we could thus have e.g. [1, 0, 3] i.e. one input key is not used.
	; For long codes (M > N, say N=6, M=4) we will have duplicate keys, but only minimally e.g. [1, 0, 3, 3, 1, 2].
	; Numbers can only appear N/M times at maximum. This is a pattern that can be figured out by a player.
	
	DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) New required code is first " + LengthOfSequence + " digits of: " + requiredCode + " with required durations: " + requiredDurations)
EndFunction

Function ResetEnteredCode()
	; Reset the code
	int i = LengthOfSequence
	While i > 0
		i -= 1
		enteredCode[i] = -1
	EndWhile

	nrEnteredKeys = 0
EndFunction

; ================================ Some logic to suspend the minigame while the player has an orgasm ================================ 

; Note that the parameters of this event must match the number & order of parameters as they were pushed in the sending script.
Event SuspendMinigameWhileOrgasming(Form sender, Form akActor, int arousalAfter)
	DDLibs.Log("Orgasm event caught on " + akActor + ", sent by  " + sender)
	If akActor == PlayerRef
		DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Caught DD orgasm event on player from sender " + sender + ". Temporarily suspending minigame.")
		; If the player is actively struggling when the orgasm starts, critically fail them with a guaranteed escalation.
		SuspendMinigame()
		if keyHeld != -1
			If Config.ShowMinigameNotifications
				Debug.Notification("You involuntarily flex as the orgasm comes over you, pulling on your binds.")
			EndIf
			CriticalFail(escalationChancePct=100.0)
		EndIf
		Utility.Wait(10.0)
		ResumeMinigame()
		DDLibs.Log("[zadc-NG] (Contraption struggle escape minigame) Player orgasm done. Resuming minigame.")
		If Config.ShowMinigameNotifications
			Debug.Notification("You are ready to try again.")
		EndIf
	EndIf
EndEvent

; ================================ Mod Events ======================================

Function SendStartMinigameModEvent()
	int handle = ModEvent.Create("zadc_EscapeMinigameStart")
	if (handle)
		ModEvent.Send(Handle)
	endIf
EndFunction

; No event for endMinigame, because when the game ends succesfully the player escapes the contraption, and this already has its own event.

Function SendProgressModEvent()
	int handle = ModEvent.Create("zadc_EscapeMinigameProgress")
	if (handle)
       	ModEvent.PushInt(handle, nrEnteredKeys)
		ModEvent.PushInt(handle, LengthOfSequence)
		ModEvent.Send(Handle)
	endIf
EndFunction

Function SendFailModEvent(bool wasCriticalFail, bool wasEscalated)
	int handle = ModEvent.Create("zadc_EscapeMinigameFail")
	if (handle)
       ModEvent.PushInt(handle, nrEnteredKeys)
       ModEvent.PushInt(handle, LengthOfSequence)
       ModEvent.PushBool(handle, wasCriticalFail)
       ModEvent.PushBool(handle, wasEscalated)
	ModEvent.Send(Handle)
	endIf
EndFunction

; ================================ Helper functions that Bethesda really should've provided ================================ 

Float Function MaxFloat(Float a, Float b)
	If a > b
		Return a
	Else
		Return b
	EndIf
EndFunction

; ================================ Debug stuff ================================ 

Function ShowDebugInfo()
	Debug.MessageBox("[zadc-NG] (Contraption struggle escape minigame) Controls: back="+Input.GetMappedKey("Back")+", forward="+Input.GetMappedKey("Forward")+", left="+Input.GetMappedKey("Left")+", right="+Input.GetMappedKey("Right")+", jump="+Input.GetMappedKey("Jump")+", sneak="+Input.GetMappedKey("Sneak"))
	Debug.MessageBox("[zadc-NG] (Contraption struggle escape minigame) Required code: " + requiredCode)
	Debug.MessageBox("[zadc-NG] (Contraption struggle escape minigame) Required durations: " + requiredDurations)
EndFunction



