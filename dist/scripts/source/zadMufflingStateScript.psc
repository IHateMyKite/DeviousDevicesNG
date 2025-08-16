Scriptname zadMufflingStateScript extends ReferenceAlias  
{The sound muffling mechanic works by manipulating the frequency and volume of certain SoundCategories (currently "Effects" and "Voice"). 
 However, these changes persist through game loads. This is undesired functionality for devious devices: the changes should only be active while the devices are worn.
 This script handles the state of the sound categories. A call to UpdateMuffleState will check whether any changes to the sound categories are needed based on worn devices.}

zadLibs Property libs Auto
Actor Property PlayerRef Auto
SoundCategory Property AudioCategorySFX Auto
SoundCategory Property AudioCategoryVOCGeneral Auto
MagicEffect Property zad_effMuffling Auto
Sound Property zadMuffledNeutralNoise Auto
{The looping sound that acts as "White noise".}

Int loopSoundInstance = -1

bool started = false
float usersEffectsVolume = -1.0
float usersVoiceVolume = -1.0

; =================================== API ===================================

Float Property MuffledFrequency = 0.92 Auto
{Frequency shift when a muffling device is equipped. Typically, higher frequencies are absorbed more than lower ones, so you want this to be < 1 for realism. Between 0.8 and 1.0 is usually good.}

Function UpdateMuffleState()
	If PlayerRef.HasMagicEffect(zad_effMuffling)
		StartMuffle()
	Else
		EndMuffle()
	EndIf
EndFunction

; =================================== INTERNAL ======================================

Function StartMuffle()
	; Store the volume settings from before the muffle effect starts, we'll need these to restore them later.
	StoreUserVolumes()

	; Set the frequency/volume.
	AudioCategorySFX.SetFrequency(MuffledFrequency)
	AudioCategorySFX.SetVolume(libs.Config.VolumeMuffled * usersEffectsVolume)
	AudioCategoryVOCGeneral.SetFrequency(MuffledFrequency)
	AudioCategoryVOCGeneral.SetVolume(libs.Config.VolumeMuffled * usersVoiceVolume)
	started = true

	; Start the white noise SFX.
	If loopSoundInstance != -1
		Sound.StopInstance(loopSoundInstance) ; If one is playing, make sure to stop it before starting a new one.
	EndIf
	loopSoundInstance = zadMuffledNeutralNoise.Play(PlayerRef)
	Sound.SetInstanceVolume(loopSoundInstance, libs.Config.VolumeMuffleWhiteNoise)
EndFunction

Function EndMuffle()
	AudioCategorySFX.SetFrequency(1.0)
	AudioCategorySFX.SetVolume(usersEffectsVolume)
	AudioCategoryVOCGeneral.SetFrequency(1.0)
	AudioCategoryVOCGeneral.SetVolume(usersVoiceVolume)
	started = false

	If loopSoundInstance != -1
		Sound.StopInstance(loopSoundInstance)
		loopSoundInstance = -1
	EndIf
EndFunction

Event OnInit()
	StoreUserVolumes()
	RegisterForMenu("Journal Menu")
EndEvent

Event OnPlayerLoadGame()
	UpdateMuffleState()
EndEvent

Event OnMenuClose(string MenuName)
	; Update stored user volume settings when they close the main menu, since they may have changed them.
	If MenuName == "Journal Menu"
		StoreUserVolumes()
	EndIf
EndEvent

Function StoreUserVolumes()
	If !started ; If the muffle effect is running, these won't be the user's values, so don't store.
		usersEffectsVolume = Utility.GetINIfloat("fVal0:AudioMenu") ; Val0 is "Effects"
		usersVoiceVolume = Utility.GetINIfloat("fVal2:AudioMenu") ; Val2 is "Voice"
	EndIf
EndFunction