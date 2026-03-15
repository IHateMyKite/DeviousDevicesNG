ScriptName zadBlindfoldEffect extends ActiveMagicEffect

; Libraries
zadLibs Property Libs Auto
ImagespaceModifier Property zad_BlindfoldModifier Auto
ImagespaceModifier Property zad_BlindfoldLeeches Auto

actor Target
Bool Terminate
Bool blinded

float lastBlindfoldStrength = 0.0
int lastdarkfogStrength = 0
int lastBlindfoldMode = -1

Function ApplyBlindfold()
    if !(blinded && libs.config.BlindfoldMode == lastBlindfoldMode && libs.config.BlindfoldStrength == lastBlindfoldStrength && libs.config.darkfogStrength == lastdarkfogStrength)
        lastBlindfoldMode = libs.config.BlindfoldMode
        if libs.config.BlindfoldMode == 3 ;dark fog
            if Weather.GetSkyMode() != 0
              zadNativeFunctions.ExecuteConsoleCmd("ts")
              Utility.Wait(0.1)
            endif
            zadNativeFunctions.ExecuteConsoleCmd("setfog " + 1 + " " + libs.config.darkfogStrength)
            lastdarkfogStrength = libs.config.darkfogStrength
        EndIf        
        if libs.config.BlindfoldStrength != lastBlindfoldStrength
            zad_BlindfoldLeeches.Remove()
            zad_BlindfoldModifier.Remove()
        EndIf
        lastBlindfoldStrength = libs.config.BlindfoldStrength
        if libs.config.BlindfoldMode == 2  || libs.config.BlindfoldMode == 1;Leeches Mode
            zad_BlindfoldModifier.Remove()
            zad_BlindfoldLeeches.Apply(libs.config.blindfoldStrength)
        ElseIf libs.config.BlindfoldMode == 0
            zad_BlindfoldLeeches.Remove()
            zad_BlindfoldModifier.Apply(libs.config.BlindfoldStrength)
        EndIf
        blinded = true
    EndIf
EndFunction

Event UpdateEvent(string eventName, string strArg, float numArg, Form sender)
    ApplyBlindfold()
EndEvent

Event OnPlayerCameraState(int oldState, int newState)
    if newState != -1 ; Do not process map state changes
        if libs.config.blindfoldMode == 2 || libs.config.blindfoldMode == 3 ; Leeches or Dark fog Mode    
            ApplyBlindfold()
            libs.UpdateControls()
        Else
            if newState == 3 || newState == 8 || newState == 9 ; Free, Third person 1, Third person 2
                ;Input.TapKey(Input.GetMappedKey("Forward"))
                blinded = false
                zad_BlindfoldModifier.Remove()
                zad_BlindfoldLeeches.Remove()
            Else
                ApplyBlindfold()
            EndIf
            libs.UpdateControls()
        EndIf
    EndIf
EndEvent

Event OnPlayerLoadGame()
    Utility.wait(1.0)
    if libs.config.BlindfoldMode == 3 ;dark fog
        if Weather.GetSkyMode() != 0
          zadNativeFunctions.ExecuteConsoleCmd("ts")
          Utility.Wait(0.1)
        endif
        zadNativeFunctions.ExecuteConsoleCmd("setfog " + 1 + " " + libs.config.darkfogStrength)
        lastdarkfogStrength = libs.config.darkfogStrength
    EndIf
EndEvent

Event OnUpdate()
    if Target == Libs.PlayerRef
        libs.ToggleCompass(Terminate)
        DoRegister()
    EndIf
EndEvent

Function DoRegister()
    if !Terminate
        RegisterForSingleUpdate(5.0)
    EndIf
EndFunction


Event OnEffectStart(Actor akTarget, Actor akCaster)
    target = akTarget
    if target == libs.PlayerRef
        libs.Log("OnEffectStart(blindfold)")
        if libs.config.BlindfoldMode == 0 || libs.config.BlindfoldMode == 1 ; Both DD modes.
            if !libs.config.BlindfoldTooltip
                libs.config.BlindfoldTooltip = True
                libs.NotifyPlayer("The Devious Devices Blindfold effect is now active. While in third person, you will be able to see, but unable to move. Switch back to first person at any time to act normally. If you dislike this mode, there are other modes available in the MCM configuration.", 1)
            EndIf
        EndIf
        blinded = false
        Terminate = False
        lastBlindfoldStrength = libs.config.BlindfoldStrength
        libs.ToggleCompass(false)
        DoRegister()
        OnPlayerCameraState(0, Game.GetCameraState())
        RegisterForCameraState()
        RegisterForModEvent("zadBlindfoldEffectUpdate","UpdateEvent")
    EndIf
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
    libs.Log("OnEffectFinish(blindfold)")
    Terminate = True
    if target == libs.PlayerRef
        if (libs.config.BlindfoldMode == 3) ;dark fog
            if Weather.GetSkyMode() == 0
            zadNativeFunctions.ExecuteConsoleCmd("ts")
            endif
            zadNativeFunctions.ExecuteConsoleCmd("setfog 0 0") 
        EndIf
        zad_BlindfoldModifier.Remove()
        zad_BlindfoldLeeches.Remove()
        libs.ToggleCompass(true)
        libs.UpdateControls()
    EndIf
EndEvent
