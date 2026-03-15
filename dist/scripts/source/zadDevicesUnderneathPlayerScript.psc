Scriptname zadDevicesUnderneathPlayerScript extends ReferenceAlias

zadLibs Property libs Auto

Event OnPlayerLoadGame()
    RegisterForSingleUpdate(3.0)
EndEvent

Function OnUpdate()
    libs.DevicesUnderneath.Maintenance()
    libs.PlayerRef.RemoveItem(libs.DevicesUnderneath.zad_DeviceHider, 999, true)
EndFunction