Scriptname zadx_BondageMittensEffectScript extends activemagiceffect  

zadlibs Property libs  Auto

Armor Property zad_DeviceHider Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget != libs.playerRef
        return
    EndIf
    while libs.hasAnyWeaponEquipped(akTarget)
        libs.stripweapons(akTarget)
    EndWhile
EndEvent