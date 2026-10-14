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
float lastTintStrength = -1.0
Bool fogLightingActive = False
Bool restoreVolumetricLighting = False
ImageSpaceModifier splitBlur
ImageSpaceModifier splitTint

Function ClearSplitEffects()
    if splitBlur
        splitBlur.Remove()
    endif
    if splitTint
        splitTint.Remove()
    endif
EndFunction

Function ReleaseFogVolumetricLighting()
    if fogLightingActive
        fogLightingActive = False
        ; Restore only lighting this effect disabled; keep a manual enabled state.
        if restoreVolumetricLighting && !Utility.GetINIBool("bVolumetricLightingEnable:Display")
            zadNativeFunctions.ExecuteConsoleCmd("tvl")
        endif
        restoreVolumetricLighting = False
    endif
EndFunction

Function UpdateFogVolumetricLighting(Int mode)
    if mode != 3 && mode != 4
        ReleaseFogVolumetricLighting()
        return
    endif
    ; Entering fog disables godrays once. Camera/slider updates must not undo
    ; subsequent manual TVL commands, including switching between fog modes.
    if !fogLightingActive
        fogLightingActive = True
        restoreVolumetricLighting = Utility.GetINIBool("bVolumetricLightingEnable:Display")
        if restoreVolumetricLighting
            zadNativeFunctions.ExecuteConsoleCmd("tvl")
        endif
    endif
EndFunction

Function ClearFog()
    if Weather.GetSkyMode() == 0
        zadNativeFunctions.ExecuteConsoleCmd("ts")
    endif
    zadNativeFunctions.ExecuteConsoleCmd("setfog 0 0")
EndFunction

Function ApplyBlindfold()
    if Terminate
        return
    endif
    libs.config.InitializeBlindfoldTint()
    float tintStrength = libs.config.blindfoldTintStrength
    if tintStrength < 0.0
        tintStrength = 0.0
    elseif tintStrength > 1.0
        tintStrength = 1.0
    endif
    int mode = libs.config.BlindfoldMode
    UpdateFogVolumetricLighting(mode)
    float strength = libs.config.BlindfoldStrength
    if strength < 0.0
        strength = 0.0
    elseif strength > 5.0
        strength = 5.0
    endif
    if mode == 0 && strength > 1.0
        strength = 1.0
    endif
    if blinded && tintStrength == lastTintStrength && mode == lastBlindfoldMode && strength == lastBlindfoldStrength && libs.config.darkfogStrength == lastdarkfogStrength
        return
    endif
    ClearSplitEffects()
    ; Mode changes must remove the previous modifier, including switching to pure fog.
    zad_BlindfoldLeeches.Remove()
    zad_BlindfoldModifier.Remove()
    if (lastBlindfoldMode == 3 || lastBlindfoldMode == 4) && mode != 3 && mode != 4
        ClearFog()
    endif
    if mode == 3 || mode == 4
        if Weather.GetSkyMode() != 0
            zadNativeFunctions.ExecuteConsoleCmd("ts")
            Utility.Wait(0.1)
        endif
        ; Do not reapply fog after removal or another mode change during the latent wait.
        if Terminate || libs.config.BlindfoldMode != mode
            if Terminate || (libs.config.BlindfoldMode != 3 && libs.config.BlindfoldMode != 4)
                ClearFog()
            endif
            return
        endif
        zadNativeFunctions.ExecuteConsoleCmd("setfog 1 " + libs.config.darkfogStrength)
    endif
    if mode != 3
        if mode == 0
            splitBlur = zad_BlindfoldModifier
            splitTint = Game.GetFormFromFile(0xA200E0, "Devious Devices - Integration.esm") as ImageSpaceModifier
        else
            splitBlur = zad_BlindfoldLeeches
            if strength > 1.0
                int step = (((strength - 1.0) * 10.0) + 0.5) as Int
                if step < 1
                    step = 1
                elseif step > 40
                    step = 40
                endif
                ; Extended profiles occupy 0xA200E1 through 0xA20108 in Integration.
                splitBlur = Game.GetFormFromFile(0xA200E0 + step, "Devious Devices - Integration.esm") as ImageSpaceModifier
            endif
            splitTint = Game.GetFormFromFile(0xA200DF, "Devious Devices - Integration.esm") as ImageSpaceModifier
        endif
        if splitBlur && splitTint
            if strength > 0.0
                if strength > 1.0
                    ; Native blend stays in range; the selected record adds blur radius.
                    splitBlur.Apply(1.0)
                else
                    splitBlur.Apply(strength)
                endif
            endif
            if tintStrength > 0.0
                splitTint.Apply(tintStrength)
            endif
        else
            libs.Log("Blindfold effect records are missing from Devious Devices - Integration.esm; update the plugin and scripts together.")
        endif
    endif
    lastTintStrength = tintStrength
    lastBlindfoldMode = mode
    lastBlindfoldStrength = strength
    lastdarkfogStrength = libs.config.darkfogStrength
    blinded = true
EndFunction

Event UpdateEvent(string eventName, string strArg, float numArg, Form sender)
    ApplyBlindfold()
EndEvent

Event OnPlayerCameraState(int oldState, int newState)
    if newState != -1 ; Do not process map state changes
        if libs.config.blindfoldMode == 2 || libs.config.blindfoldMode == 3 || libs.config.blindfoldMode == 4 ; Leeches, fog or combined
            ApplyBlindfold()
            libs.UpdateControls()
        Else
            if newState == 3 || newState == 8 || newState == 9 ; Free, Third person 1, Third person 2
                ;Input.TapKey(Input.GetMappedKey("Forward"))
                ClearSplitEffects()
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
    ; Console lighting state is initialized again when Skyrim starts.
    fogLightingActive = False
    restoreVolumetricLighting = False
    Utility.wait(1.0)
    blinded = false
    ApplyBlindfold()
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
    ReleaseFogVolumetricLighting()
    ClearSplitEffects()
    if target == libs.PlayerRef
        if libs.config.BlindfoldMode == 3 || libs.config.BlindfoldMode == 4 || lastBlindfoldMode == 3 || lastBlindfoldMode == 4 ; Either fog mode
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
