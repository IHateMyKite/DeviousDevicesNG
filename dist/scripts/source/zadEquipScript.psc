Scriptname zadEquipScript extends ObjectReference

; Libraries
zadlibs     Property libs       Auto
slaUtilScr  Property Aroused    Auto

; Old escape dialog - DO NOT USE
; These silly properties are baked in a lot of scripts, so removing them will make the engine barf errors into the log like crazy. 
; Probably leave them in and just hide them in CK...
Message     Property zad_DeviceMsgMagic                         auto Hidden    ; Device removal via magic message Deprecated!!
Message     Property zad_DeviceRemoveMsg                        auto Hidden    ; Device removal message Deprecated!!
Message     Property zad_DeviceEscapeMsg                        Auto Hidden    ; Device escape message Deprecated!!
Bool        Property JammedLock                 = False         Auto Hidden    ; Is the lock currently jammed? (Deprecated, do NOT use!)

; Item Descriptors
Message     Property zad_DeviceMsg                              auto           ; Device interaction message
Armor       Property deviceRendered                             Auto           ; Rendered Device - is what's displayed in game.
Armor       Property deviceInventory                            Auto           ; Inventory Device - has the script
Keyword     Property zad_DeviousDevice                          Auto

; Persistant Variables
Quest       Property deviceQuest                                Auto
String      Property deviceName                                 Auto
MiscObject  Property Lockpick                                   Auto
Actor 		Property DeviceWearer 								Auto Hidden		; The actor currently wearing the device

; Wrist Bondage and struggle system
String[]    Property struggleIdles                              Auto
String[]    Property struggleIdlesHob                           Auto

; Unlock system
Key         Property deviceKey                                  Auto      ; Key type to unlock this device
Bool        Property DestroyKey                 = False         Auto      ; If set to true, the key(s) will be destroyed when the device is unlocked or escaped from.
Bool        Property DestroyOnRemove            = False         Auto      ; If set to true, they device will be destroyed when it is unlocked or escaped from.
Int         Property NumberOfKeysNeeded         = 1             Auto      ; Number of keys needed (=multiple locks)
Float       Property LockAccessDifficulty       = 0.0           Auto      ; If set to greater than zero, the character cannot easily reach the locks when locked in this restraint. The higher the number, the harder she will find it to unlock herself, even when in possession of the key. A value of 100 will make it impossible for her to reach the locks. She will need help. Make sure that your mod actually provides a means to escape such retraints!
Float       Property UnlockCooldown             = 0.0           Auto      ; How many hours have to pass between unlock attempts for hard to unlock restraints.
Float       Property KeyBreakChance             = 0.0           Auto      ; Chance that the key breaks when trying to unlock an item. WARNING: Do NOT use this feature when there is only one key in the game etc.
Float       Property LockJamChance              = 0.0           Auto      ; Chance that the key gets stuck in the lock when it breaks. The lock has to be repaired before further unlock attempts.
Float       Property LockShieldTimerMin         = 0.0           Auto      ; If this number is greater than zero, the player has to wait for a minimum of this many hours before she can unlock the device with a key.
Float       Property LockShieldTimerMax         = 0.0           Auto      ; If this number is greater than zero, the player has to wait for a maximum of this many hours before she can unlock the device with a key.
Bool        Property TimedUnlock                = False         Auto      ; If set to true, the device can be removed without the key when the lock timer is expired. Uses parameters below. When the timed lock is engaged, the device can STILL be unlocked with a key. This way, restraints can use either or both methods simultaneously.
Float       Property LockTimerMin               = 0.0           Auto      ; Minimum hours before the lock timer expires
Float       Property LockTimerMax               = 0.0           Auto      ; Maximum hours before the lock timer expires

; Escape system
Float       Property BaseEscapeChance           = 0.0           Auto      ; Base chance to escape a restraint via struggling. Magic bonus applies. 0 disables this feature.
Float       Property LockPickEscapeChance       = 0.0           Auto      ; Base chance to escape a restraint via lockpicking Need proper lockpick, Lockpick bonus applies. 0 disables this feature.
Form[]      Property AllowedLockPicks                           Auto      ; List of items other than lockpicks considered a valid pick tool for this device. The lockpick is allowed by default unless disabled.
Bool        Property AllowLockPick              = True          Auto      ; Indicates whether or not the bobby pin is considered a valid lockpick for this device.
Float       Property CutDeviceEscapeChance      = 0.0           Auto      ; Base chance to escape a restraint via cutting it open. Need proper tool, Agiliy bonus applies. 0 disables this feature.
Bool        Property AllowStandardTools         = True          Auto      ; Indicates whether or not the items in the standard tools list (all small blades) are considered a valid cutting tool for this device.
Keyword[]   Property AllowedTool                                Auto      ; List of item keywords considered a cutting tool for this device. 
Float       Property CatastrophicFailureChance  = 0.0           Auto      ; Chance that an escape attempt fails in a catastrophic manner, preventing any further attempts to escape this device using that method.
Float       Property EscapeCooldown             = 2.0           Auto      ; How many hours have to pass between escape attempts.
Float       Property RepairJammedLockChance     = 20.0          Auto      ; Chance that the player manages to successfully repair a jammed lock.
Float       Property RepairCooldown             = 4.0           Auto      ; How many hours have to pass between repair attempts.
Bool        Property AllowDifficultyModifier    = False         Auto      ; Override to allow the difficulty modifier for quest/custom items (tagged with zad_BlockGeneric or zad_QuestItem). For generic items this is always allowed, regardless of this setting.
Bool        Property DisableLockManipulation    = False         Auto      ; Override to disallow the player manipulating the locks. Not needed for quest/custom items, as this feature is disabled for them anyway.

; These messages exist both here and in zadlibs. Modders can override the messages per item with these!
Message     Property zad_DD_EscapeDeviceMSG                     Auto      ; Device escape dialogue. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message     Property zad_DD_OnEquipDeviceMSG                    Auto      ; Message is displayed upon device equip (dialogue only)
Message     Property zad_DD_OnNoKeyMSG                          Auto      ; Message is displayed when the player has no key
Message     Property zad_DD_OnNotEnoughKeysMSG                  Auto      ; Message is displayed when the player has not enough keys
Message     Property zad_DD_OnLeaveItNotWornMSG                 Auto      ; Message is displayed when the player clicks the "Leave it Alone" button while not wearing the device.
Message     Property zad_DD_OnLeaveItWornMSG                    Auto      ; Message is displayed when the player clicks the "Leave it Alone" button while wearing the device.
Message     Property zad_DD_KeyBreakMSG                         Auto      ; Message is displayed when a key breaks while trying to unlock this device.
Message     Property zad_DD_KeyBreakJamMSG                      Auto      ; Message is displayed when a key breaks and gets stuck in the lock when trying to unlock this device.
Message     Property zad_DD_UnlockFailJammedMSG                 Auto      ; Message displayed when a player tries to unlock a jammed device.
Message     Property zad_DD_RepairLockNotJammedMSG              Auto      ; Message displayed when a player tries to repair a device that's not jammed.
Message     Property zad_DD_RepairLockMSG                       Auto      ; Message displayed when a player tries to repair a lock.
Message     Property zad_DD_RepairLockSuccessMSG                Auto      ; Message displayed when a player successfully tries to repair a lock.
Message     Property zad_DD_RepairLockFailureMSG                Auto      ; Message displayed when a player fails to repair a lock.
Message     Property zad_DD_EscapeStruggleMSG                   Auto      ; Message to be displayed when the player tries to struggle out of a restraint
Message     Property zad_DD_EscapeStruggleFailureMSG            Auto      ; Message to be displayed when the player fails to struggle out of a restraint
Message     Property zad_DD_EscapeStruggleSuccessMSG            Auto      ; Message to be displayed when the player succeeds to struggle out of a restraint
Message     Property zad_DD_EscapeLockPickMSG                   Auto      ; Message to be displayed when the player tries to pick a restraint
Message     Property zad_DD_EscapeLockPickFailureMSG            Auto      ; Message to be displayed when the player fails to pick a restraint
Message     Property zad_DD_EscapeLockPickSuccessMSG            Auto      ; Message to be displayed when the player succeeds to pick a restraint
Message     Property zad_DD_EscapeCutMSG                        Auto      ; Message to be displayed when the player tries to cut a restraint
Message     Property zad_DD_EscapeCutFailureMSG                 Auto      ; Message to be displayed when the player fails to cut a restraint
Message     Property zad_DD_EscapeCutSuccessMSG                 Auto      ; Message to be displayed when the player succeeds to cut open a restraint
Message     Property zad_DD_OnPutOnDevice                       Auto      ; Message to be displayed when the player locks on an item, so she can manipulate the locks if she choses. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message     Property zad_DD_OnTimedUnlockMSG                    Auto      ; Message to be displayed when the player removes an item after the timed lock has expired.

; Device dependencies
Keyword[]   Property EquipConflictingDevices                    Auto      ; These item keywords, if present on the character, will prevent the item from getting equipped, unless a script does it.
Keyword[]   Property EquipRequiredDevices                       Auto      ; These item keywords, if NOT present on the character, will prevent the item from getting equipped, unless a script does it.
Keyword[]   Property UnEquipConflictingDevices                  Auto      ; These item keywords, if present on the character, will prevent the item from getting unequipped, unless a script does it.
Message     Property zad_EquipConflictFailMsg                   auto      ; This message will get displayed if an item fails to equip due to present keyword conflicts. Make sure to explain the conflicts, so the player knows what's going on!
Message     Property zad_EquipRequiredFailMsg                   auto      ; This message will get displayed if an item fails to equip due to missing keyword conflicts. Make sure to explain the conflicts, so the player knows what's going on!
Message     Property zad_UnEquipFailMsg                         auto      ; This message will get displayed if an item fails to unequip due to keyword conflicts. Make sure to explain the conflicts, so the player knows what's going on!

; Linked Devices - Attention: This feature works only for the player character. Linked devices will be ignored if the device is worn by an NPC.
Armor       Property LinkedDeviceEquipOnUntighten               Auto      ; This device will get equipped when the player unlocks this device. This allows multiple-stage devices, e.g. a straitjacket that needs to be gradually unlocked. The linked device will NOT get equipped when the device is removed with zadlibs.UnlockDevice().
Armor       Property LinkedDeviceEquipOnTighten                 Auto      ; This device will get equipped when the device is "tightend".

; Local Variables
bool    menuDisable                     = false
int     mutexTimeout                    = 10
bool    unequipMutex

; Internal script variables
Float   LastUnlockAttemptAt             = 0.0       ; When did the player last attempt to unlock this device.
Float   DeviceEquippedAt                = 0.0       ; When was this device equipped?
Int     EscapeCutAttemptsMade           = 0         ; Tracker of how often the player tried to escape this device via cutting.
Int     EscapeStruggleAttemptsMade      = 0         ; Tracker of how often the player tried to escape this device via struggling.
Int     EscapeLockPickAttemptsMade      = 0         ; Tracker of how often the player tried to escape this device via lockpicking.
Float   LastStruggleEscapeAttemptAt     = 0.0       ; When did the player last attempt to escape via struggling.
Float   LastCutEscapeAttemptAt          = 0.0       ; When did the player last attempt to escape via cutting.
Float   LastLockPickEscapeAttemptAt     = 0.0       ; When did the player last attempt to escape via lockpicking.
Int     RepairAttemptsMade              = 0         ; Tracker of how often the player tried to escape this device.
Float   LastRepairAttemptAt             = 0.0       ; When did the player last attempt to escape.
Float   RepairDifficultyModifier        = 0.0       ; Global modifier for escape attempts. Can be used to make escape harder or easier.
Float   LockShieldTimer                 = 0.0       ; The actual uptime of the lockshield. Randomly determined when the item is equipped using the min and max values.
Float   LockTimer                       = 0.0       ; The actual uptime of the timed lock. Randomly determined when the item is equipped using the min and max values.
Bool    QuestItemRemovalTokenInternal   = False

Function ProcessLinkedDeviceOnUntighten(Actor akActor)
    If akActor != Libs.PlayerRef || LinkedDeviceEquipOnUntighten == None
        return
    EndIf    
    if LinkedDeviceEquipOnUntighten.HasKeyword(libs.zad_InventoryDevice)
        Utility.Wait(0.5)
        libs.LockDevice(akActor, LinkedDeviceEquipOnUntighten)
    EndIf
EndFunction

Function ProcessLinkedDeviceOnTighten(Actor akActor)        
    If akActor != Libs.PlayerRef || LinkedDeviceEquipOnTighten == None
        return
    EndIf    
    if LinkedDeviceEquipOnTighten.HasKeyword(libs.zad_InventoryDevice)
        Utility.Wait(0.5)
        libs.LockDevice(akActor, LinkedDeviceEquipOnTighten)
    EndIf
EndFunction

Function MultipleItemFailMessage(string offendingItem)
    offendingItem = libs.MakeSingularIfPlural(offendingItem)
    libs.NotifyPlayer("It is impossible to wear multiple " + offendingItem + "s simultaneously.", true)
    libs.Log("Actor attempted to equip multiple "+offendingItem+"s simultaneously ("+zad_DeviousDevice+").")
EndFunction


bool Function ShouldEquipSilently(actor akActor)
    if libs.zad_AlwaysSilent.HasForm(akActor)
        ; if the actor is in that list we never want dialogs. That's mainly for safely equipping a large number of devices via script and avoid dialogue popping up when the player accesses the inventory in between.
        return true
    EndIf
    ; Differentiate between item being forced on actor, and voluntary equips.
    if !UI.IsMenuOpen("ContainerMenu") && (akActor != libs.PlayerRef || !UI.IsMenuOpen("InventoryMenu"))
        libs.Log("No menus are open. Equipping silently.")
        return true
    EndIf
    return false
EndFunction

Event OnEquipped(Actor akActor)        
    libs.Log("OnEquipped("+akActor.GetLeveledActorBase().GetName()+": "+deviceInventory.GetName()+")")
	DeviceWearer = none ;clear wearer in case of invalid pre-equip checks
    if akActor == libs.PlayerRef
        libs.log("Checking for active unequip operation for " + zad_DeviousDevice)
        int counter = 10 ; half second intervals, so 5 secs max
        while (StorageUtil.GetIntValue(akActor, "zad_RemovalOperation" + zad_DeviousDevice) == 1) && counter > 0
            libs.log("Device Swap detected. Waiting for removal operation to complete.")
            ; this looks to be a device swap, let's wait a bit
            counter -= 1
            Utility.Wait(0.5)
        EndWhile
        libs.log("No active unequip operation running for " + zad_DeviousDevice + ". Proceeding")
    EndIf    
    If !akActor.IsEquipped(deviceRendered) && akActor.GetItemCount(deviceRendered) > 0
        akActor.RemoveItem(deviceRendered, akActor.GetItemCount(deviceRendered),true)
    EndIf    
    if akActor.GetItemCount(deviceRendered) > 0
        libs.Log("OnEquipped aborted - item is already worn.")
        ; no need to process if the item is already worn
        return
    EndIf
    if akActor.GetItemCount(deviceRendered) == 0 && akActor.WornHasKeyword(zad_DeviousDevice)
        libs.Log("Wearing conflicting device type:" + zad_DeviousDevice)
        menuDisable = true
        akActor.UnequipItem(deviceInventory, false, true)
        return
    EndIf    
    bool silently = ShouldEquipSilently(akActor)
    ; check for device conflicts
    If !silently && (IsEquipDeviceConflict(akActor) || IsEquipRequiredDeviceConflict(akActor))
        menuDisable = true        
        akActor.UnequipItem(deviceInventory, false, true)
        return
    EndIf    
    If !silently && akActor == libs.playerref && !akActor.WornHasKeyword(zad_DeviousDevice) && akActor.GetItemCount(deviceRendered) == 0
        Int msgChoice = zad_DeviceMsg.Show() ; display menu
        if msgChoice != 0 ; Equip Device voluntarily
            menuDisable = true
            akActor.UnequipItem(deviceInventory, false, true)
            return
        Else            
            StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_ManipulatedStatus", 0)
            If !DisableLockManipulation && libs.Config.UseItemManipulation && ( deviceRendered.HasKeyword(libs.zad_Lockable) || deviceInventory.HasKeyword(libs.zad_Lockable) ) && !deviceInventory.HasKeyword(libs.zad_QuestItem) && !deviceRendered.HasKeyword(libs.zad_QuestItem) && !deviceInventory.HasKeyword(libs.zad_BlockGeneric) && !deviceRendered.HasKeyword(libs.zad_BlockGeneric) 
                Int Choice = 0
                If zad_DD_OnPutOnDevice
                    Choice = zad_DD_OnPutOnDevice.Show()
                Else
                    Choice = libs.zad_DD_OnPutOnDevice.Show()
                EndIf
                If Choice == 1
                    StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_ManipulatedStatus", 1)
                EndIf
            EndIf
        EndIf
    EndIf    
    int filter = OnEquippedFilter(akActor, silent=silently)
    if filter >= 1
        if filter == 2
            menuDisable = true
            akActor.UnequipItem(deviceInventory, false, true)
        EndIf
        return
    EndIf
    if akActor == libs.PlayerRef ; Store equipped devices for faster generic calls.
        StoreEquippedDevice(akActor)
        StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 0)
        StorageUtil.UnSetIntValue(akActor, "zad_UntightenToken" + deviceInventory)
        StorageUtil.UnSetIntValue(akActor, "zad_TightenToken" + deviceInventory)
    EndIf
    OnEquippedPre(akActor, silent=silently)
    if !akActor.IsEquipped(DeviceInventory)
        akActor.EquipItem(DeviceInventory, false, true)
    EndIf    
    akActor.EquipItem(DeviceRendered, true, true)
    if akActor == libs.PlayerRef && !akActor.IsOnMount()
        ; make it visible for the player in case the menu is open
        akActor.QueueNiNodeUpdate()
    elseif akActor != libs.PlayerRef && !akActor.IsOnMount() && deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
        ; prevent a bug with straitjackets and elbowbinders not hiding NPC hands when equipping these items.        
        akActor.UpdateWeight(0)
    EndIf    
    if akActor != libs.PlayerRef && (deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage) || deviceRendered.HasKeyword(libs.zad_DeviousHobbleSkirt))
        libs.RepopulateNpcs()
    EndIf    
    OnEquippedPost(akActor)
    ResetLockShield()
    If TimedUnlock
        SetLockTimer()
    EndIf
    libs.StartBoundEffects(akActor)
    LastCutEscapeAttemptAt = 0.0
    LastStruggleEscapeAttemptAt = 0.0
    LastLockPickEscapeAttemptAt = 0.0
    LastUnlockAttemptAt = 0.0
    LastRepairAttemptAt = 0.0
    EscapeCutAttemptsMade = 0
    EscapeStruggleAttemptsMade = 0
    EscapeLockpickAttemptsMade = 0
    menuDisable = false
	DeviceWearer = akActor
    libs.SendDeviceEquippedEvent(deviceName, akActor)
    libs.SendDeviceEquippedEventVerbose(deviceInventory, zad_DeviousDevice, akActor)
EndEvent

Event OnUnequipped(Actor akActor)
    ; no processing when rendered item isn't even worn and the menu is open. Otherwise the code would equip the item even when the player declines to do so in the menu.    
    unequipMutex = true
    libs.Log("OnUnequipped("+akActor.GetLeveledActorBase().GetName()+": "+deviceInventory.GetName()+")")
    if !akActor.IsEquipped(deviceRendered) && UI.IsMenuOpen("InventoryMenu")
        return
    EndIf
    if akActor == libs.PlayerRef
        libs.log("Starting unequip operation for " + zad_DeviousDevice)
        StorageUtil.SetIntValue(akActor, "zad_RemovalOperation" + zad_DeviousDevice, 1)
    EndIf
	DeviceWearer = akActor
    If DeviceRendered.HasKeyword(Libs.Zad_QuestItem) || DeviceInventory.HasKeyword(Libs.Zad_QuestItem)
        libs.Log("Attempt to remove quest item: "+akActor.GetLeveledActorBase().GetName()+": "+deviceInventory.GetName()+")")
        if !QuestItemRemovalTokenInternal && (libs.questItemRemovalAuthorizationToken == None || libs.zadStandardKeywords.HasForm(libs.questItemRemovalAuthorizationToken) || (!DeviceRendered.HasKeyword(libs.questItemRemovalAuthorizationToken) && !DeviceInventory.HasKeyword(libs.questItemRemovalAuthorizationToken)))
            libs.Log("Caught and prevented unauthorized removal attempt!")
            unequipMutex = false            
            If !akActor.IsEquipped(deviceInventory)
                akActor.EquipItem(deviceInventory, false, true)
            EndIf            
            ; If this is a genuine attempt to unlock the item, display the menu
            if UI.IsMenuOpen("InventoryMenu")
                DeviceMenu()
            EndIf
            if akActor == libs.PlayerRef
                StorageUtil.UnsetIntValue(akActor, "zad_RemovalOperation" + zad_DeviousDevice)
            EndIf
            Return
        Else
            libs.questItemRemovalAuthorizationToken = None
            QuestItemRemovalTokenInternal = False
        EndIf
    EndIf        
    if StorageUtil.GetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 0) >= 1 
        if OnUnequippedFilter(akActor) >= 1
            libs.Log("OnUnequipped(): Detected removal token, but OnUnequippedFilter return >= 1. Not removing device.")
            ; Clear removal token
            StorageUtil.UnsetIntValue(akActor, "zad_RemovalToken"+deviceInventory)
            ; Cleanup
            unequipMutex = false
            If !akActor.IsEquipped(deviceInventory)
                akActor.EquipItem(deviceInventory, false, true)
            EndIf            
        elseif (StorageUtil.GetIntValue(akActor, "zad_TightenToken" + deviceInventory, 0) == 1) && !LinkedDeviceEquipOnTighten
            libs.Log("OnUnequipped(): Called tighten device, but no linked device defined. Not removing device.")
            ; Clear removal tokens
            StorageUtil.UnsetIntValue(akActor, "zad_RemovalToken"+deviceInventory)
            StorageUtil.UnSetIntValue(akActor, "zad_TightenToken" + deviceInventory)
            ; Cleanup
            unequipMutex = false            
            If !akActor.IsEquipped(deviceInventory)
                akActor.EquipItem(deviceInventory, false, true)
            EndIf
        else
            libs.Log("Detected removal token. Done.")
            akActor.RemoveItem(deviceRendered, 1, true)
            UnsetStoredDevice(akActor)
            OnRemoveDevice(akActor)
            libs.SendDeviceRemovalEvent(libs.LookupDeviceType(zad_DeviousDevice), akActor)
            libs.SendDeviceRemovedEventVerbose(deviceInventory, zad_DeviousDevice, akActor)            
            If deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage) || deviceRendered.HasKeyword(libs.zad_DeviousPonyGear) || deviceRendered.HasKeyword(libs.zad_DeviousHobbleSkirt) 
                libs.StopBoundEffects(akActor)
            EndIf                        
            StorageUtil.UnsetIntValue(akActor, "zad_RemovalToken"+deviceInventory)
            if akActor == libs.PlayerRef
                StorageUtil.UnsetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_ManipulatedStatus")
                StorageUtil.UnsetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus")
            EndIf
            unequipMutex = false
            if StorageUtil.GetIntValue(akActor, "zad_UntightenToken" + deviceInventory, 0) == 1
                ProcessLinkedDeviceOnUntighten(akActor)
                StorageUtil.UnSetIntValue(akActor, "zad_UntightenToken" + deviceInventory)
            elseif StorageUtil.GetIntValue(akActor, "zad_TightenToken" + deviceInventory, 0) == 1
                ProcessLinkedDeviceOnTighten(akActor)
                StorageUtil.UnSetIntValue(akActor, "zad_TightenToken" + deviceInventory)
            EndIf
			DeviceWearer = none
        EndIf
    else        
        if akActor==libs.PlayerRef
            if !menuDisable
                ; Catch removeallitems and similar effects for compatibility with impolite mods.
                ; Not doing this for npc's, since equip state can't be relied upon for them.
                if akActor.GetItemCount(deviceInventory) <=0
                    libs.Log("Caught remove-all (inventory device missing). Re-equipping device.")
                    If !akActor.IsEquipped(deviceInventory)
                        akActor.EquipItem(deviceInventory, false, true)
                    EndIf                
                    if !libs.PlayerRef.IsEquipped(deviceRendered)
                        akActor.EquipItem(deviceRendered, true, true)
                    EndIf
                    StorageUtil.UnsetIntValue(akActor, "zad_RemovalOperation" + zad_DeviousDevice)
                    return
                EndIf
                if !libs.PlayerRef.IsEquipped(deviceRendered) && akActor.GetItemCount(deviceInventory) < 2
                    libs.Log("Caught remove-all (rendered device missing). Re-equipping device.")
                    akActor.EquipItem(deviceRendered, true, true)
                    StorageUtil.UnsetIntValue(akActor, "zad_RemovalOperation" + zad_DeviousDevice)
                    return
                EndIf    
                ; Player had to unequip item to access this. Reequip it immediately, to help avoid spam-unlocks.
                libs.PlayerRef.EquipItem(deviceInventory, false, true)
                DeviceMenu()
            Else
                menuDisable = false
            Endif
        Endif
        unequipMutex = false
    EndIf
    if akActor == libs.PlayerRef
        StorageUtil.UnsetIntValue(akActor, "zad_RemovalOperation" + zad_DeviousDevice)
    EndIf    
EndEvent


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    libs.Log("OnContainerChanged()")
    bool avoidRaceCondition = unequipMutex    
    if OnContainerChangedFilter(akNewContainer, akOldContainer) < 1
        if akNewContainer && !akOldContainer
            ; PC or NPC picked up a device. No action required.
            return
        elseif akOldContainer && !akNewContainer
            ; Item is being dropped.
            if libs.IsWearingDevice((akOldContainer as actor), DeviceRendered, zad_DeviousDevice) == 1
                libs.Log(deviceName+" dropped.")
                self.Delete()
            Endif
            return
        else
            ; Item is changing inventories, or being stored in a container 
            if akNewContainer != libs.PlayerRef
                ; Avoid giving away last copy of worn item.
                if (akOldContainer.GetItemCount(deviceInventory) >= 1 && !avoidRaceCondition) || (akOldContainer.GetItemCount(deviceRendered)== 0 && !avoidRaceCondition)
                    libs.Log("Giving item away. Not last copy.")
                    Actor npc = (akNewContainer as Actor)
                    if npc != none && !npc.IsDead()
                        ; Differentiate between intentionally giving it away, and having it stolen by (submit/SD/etc). Hmmm.
                        ; Inventory, Barter, Container
                        if UI.IsMenuOpen("ContainerMenu")
                            libs.Log("ContainerMenu is open, and container is "+npc.GetLeveledActorBase().GetName()+". Forcing npc to equip device.")
                            ; Giving item to an npc, equip it.
                            if libs.WearingConflictingDevice(npc, deviceRendered, zad_DeviousDevice)
                                libs.NotifyPlayer(npc.GetLeveledActorBase().GetName()+" is already wearing a "+deviceName+"!")
                                npc.RemoveItem(deviceInventory, 1, false, libs.PlayerRef)
                            Else
                                If !IsEquipDeviceConflict(npc) && !IsEquipRequiredDeviceConflict(npc)
                                    libs.EquipDevice(npc, deviceInventory, deviceRendered, zad_DeviousDevice)
                                Endif
                            EndIf
                            ; OnEquipped(npc) ; Not sure why this isn't being called for npc's. Temporary work-around.
                        EndIf
                    EndIf
                    return
                EndIf
                libs.Log(deviceName+" is switching containers. Count: " + akOldContainer.GetItemCount(deviceInventory))
                akNewContainer.RemoveItem(deviceInventory, 1, true)
                akNewContainer.RemoveItem(deviceRendered, 1, true)
            else
                Actor npc = (akOldContainer as Actor)
				DeviceWearer = npc
                ; Is this an npc, or a container?
                if npc != none && npc.GetItemCount(deviceRendered)!=0
                    if libs.PlayerRef.WornHasKeyword(libs.zad_DeviousHeavyBondage)
                        libs.Notify("Your wrist bindings prevent you from removing the "+deviceName+" from " + npc.GetLeveledActorBase().GetName() + ".")
                        npc.AddItem(deviceInventory, 1, true)
                        npc.EquipItem(deviceInventory, false, true)
                        libs.PlayerRef.RemoveItem(deviceInventory, 1, true)
                        return
                    EndIf
                    ; handle belts locking in plugs
                    if npc.WornHasKeyword(libs.zad_DeviousBelt) && (DeviceRendered.HasKeyword(libs.zad_DeviousPlugVaginal) || (DeviceRendered.HasKeyword(libs.zad_DeviousPlugAnal) && !npc.WornHasKeyword(libs.zad_PermitAnal)))
                        libs.Notify(npc.GetLeveledActorBase().GetName() + " is wearing a chastity belt. You can't remove the " + deviceName)
                        npc.AddItem(deviceInventory, 1, true)
                        npc.EquipItem(deviceInventory, false, true)
                        libs.PlayerRef.RemoveItem(deviceInventory, 1, true)
                        return
                    EndIf
                    if npc.WornHasKeyword(libs.zad_DeviousBra) && (DeviceRendered.HasKeyword(libs.zad_DeviousPiercingsNipple) && !DeviceRendered.HasKeyword(libs.zad_BraNoBlockPiercings))
                        libs.Notify(npc.GetLeveledActorBase().GetName() + " is wearing a chastity bra. You can't remove the " + deviceName)
                        npc.AddItem(deviceInventory, 1, true)
                        npc.EquipItem(deviceInventory, false, true)
                        libs.PlayerRef.RemoveItem(deviceInventory, 1, true)
                        return
                    EndIf
                    if npc.IsDead() 
                        RemoveDevice(npc, skipMutex=true)
                        return
                    EndIf
                    ; Does the player have the right key?
                    if deviceKey && libs.PlayerRef.GetItemCount(deviceKey) >= NumberOfKeysNeeded
                        ; Free npc.
                        If !IsUnEquipDeviceConflict(npc)
                            libs.Notify("You use the key to unlock the "+deviceName+" from " + npc.GetLeveledActorBase().GetName() + ".")
                            RemoveDevice(npc, skipMutex=true)
                            If DestroyKey
                                libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)
                            elseif libs.Config.GlobalDestroyKey && DeviceKey.HasKeyword(libs.zad_NonUniqueKey)
                                libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)
                            EndIf
                        EndIf
                    ; Does not have correct key
                    else
                        ; Does npc have multiple instances of this device?
                        if npc.GetItemCount(deviceInventory) <= 0 
                            ; Does this device not have a key?
                            if deviceKey == none
                                if OnUnequippedFilter(npc) >= 1
                                    npc.AddItem(deviceInventory, 1, true)
                                    libs.PlayerRef.RemoveItem(deviceInventory, 1, true)
                                    NoKeyFailMessage(npc)
                                else
                                    libs.Notify("You remove the "+deviceName+" from "+ npc.GetLeveledActorBase().GetName() + ".")
                                    RemoveDevice(npc, skipMutex=true)
                                EndIf
                            ; Device has a key, player does not have it
                            else
                                libs.Notify("You lack the key required to free " + npc.GetLeveledActorBase().GetName() + " from the "+deviceName+".")
                                npc.AddItem(deviceInventory, 1, true)
                                npc.EquipItem(deviceInventory, false, true)
                                libs.PlayerRef.RemoveItem(deviceInventory, 1, true)
                            EndIf
                        EndIf
                    EndIf
                EndIf
                libs.Log((akNewContainer as Actor).GetLeveledActorBase().GetName() + " received "+deviceName+".")
                return
            EndIf
        EndIf
        OnContainerChangedPre(akNewContainer, akOldContainer)
        Actor npc = (akOldContainer as Actor)
        OnContainerChangedPost(akNewContainer, akOldContainer)
    EndIf
endEvent

Function EquipDevice(actor akActor, bool skipMutex=false)
    libs.log("EquipDevice (Device Script) ("+akActor.GetLeveledActorBase().GetName()+": "+deviceInventory.GetName()+")")
    libs.LockDevice(akActor, deviceInventory)
    menuDisable = False
EndFunction

Function RemoveDevice(actor akActor, bool destroyDevice=false, bool skipMutex=false)    
    libs.log("RemoveDevice (Device Script) ("+akActor.GetLeveledActorBase().GetName()+": "+deviceInventory.GetName()+")")
    ;libs.SendDeviceRemovalEvent(libs.LookupDeviceType(zad_DeviousDevice), akActor)
    ;libs.SendDeviceRemovedEventVerbose(deviceInventory, zad_DeviousDevice, akActor)
    if deviceInventory.HasKeyword(libs.zad_QuestItem) || deviceRendered.HasKeyword(libs.zad_QuestItem)
        StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)
        QuestItemRemovalTokenInternal = True
        akActor.UnequipItemEx(deviceInventory, 0, false)
        akActor.RemoveItem(deviceRendered, 1, true)
        if DestroyOnRemove
            akActor.RemoveItem(deviceInventory, 1, true)
        EndIf
        return
    EndIf
    Bool DestroyInventoryDevice = destroyDevice || DestroyOnRemove
    libs.UnlockDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, destroyDevice = DestroyInventoryDevice)
    if akActor != libs.PlayerRef
        OnRemoveDevice(akActor)
    EndIf   
	DeviceWearer = none
EndFunction

bool Function RemoveDeviceWithKey(actor akActor = none, bool destroyDevice=false)
    ; the destroyDevice Parameter is ignored since it's now an item property, but it's left in not to cause conflicts with existing mods.
    if akActor == none
        akActor = libs.PlayerRef
    EndIf   
    If StorageUtil.GetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_ManipulatedStatus") == 1
        libs.Notify("As you have manipulated the " + deviceName + ", you are able to slip out of the device with ease!", messageBox = True)
        ; could call ProcessLinkedDeviceOnUnlock(Actor akActor)    here, but there is a theoretical chance that OnUnequipped() will not be completed before the new device will get locked on, so we're just signaling OnUnequipped() to do it.
        StorageUtil.SetIntValue(akActor, "zad_UntightenToken" + deviceInventory, 1)
        RemoveDevice(akActor)
        Return True
    EndIf    
    if (akActor == libs.PlayerRef) && StorageUtil.GetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus") == 1
        libs.Log("RemoveDeviceWithKey called, but lock is jammed.")
        If zad_DD_UnlockFailJammedMSG
            zad_DD_UnlockFailJammedMSG.Show()
        Else
            libs.zad_DD_UnlockFailJammedMSG.Show()
        EndIf
        return false
    EndIf    
    If TimedUnlock
        ; we check for the lock timer first.
        If CheckLockTimer()
            If zad_DD_OnTimedUnlockMSG
                zad_DD_OnTimedUnlockMSG.Show()
            EndIf        
            ; could call ProcessLinkedDeviceOnUnlock(Actor akActor)    here, but there is a theoretical chance that OnUnequipped() will not be completed before the new device will get locked on, so we're just signaling OnUnequipped() to do it.
            StorageUtil.SetIntValue(akActor, "zad_UntightenToken" + deviceInventory, 1)
            RemoveDevice(akActor)
            return true
        EndIf
        ; if the timed lock is still engaged we continue and see if we can unlock the device with a key, so we do not return false here
    EndIf    
    If !CheckLockShield() ; is the shield timer expired?
        Return False
    EndIf
    ; Check if she is able to unlock herself. We do this check here to allow it to apply even to keyless restraints that shouldn't be just removed.
    If !CheckLockAccess()
        Return False
    EndIf        
    If DeviceKey
        If libs.PlayerReF.GetItemCount(DeviceKey) <= 0
            If zad_DD_OnNoKeyMSG
                zad_DD_OnNoKeyMSG.Show()
            Else
                libs.Notify("You do not posess the correct key to manipulate this " + deviceName + ".")
            EndIf
            Return False
        ElseIf libs.PlayerRef.GetItemCount(DeviceKey) < NumberOfKeysNeeded
            If zad_DD_OnNotEnoughKeysMSG
                zad_DD_OnNotEnoughKeysMSG.Show()
            Else
                libs.Notify("You do not posess enough keys to manipulate this " + deviceName + ".")
            EndIf
            Return False
        EndIf        
        ; We show the struggle scene now.
        StruggleScene(libs.PlayerRef)
        ; The key break chance defaults to zero, so we don't need to check for quest items etc. If modders set this chance higher, it's their responsibility!
        Float ModValue = (KeyBreakChance * CalculateKeyModifier(False))
        If (KeyBreakChance < 100.0) && (ModValue >= 100.0)
            ; If the modder didn't mean to make it completely impossible to unlock this item, it shouldn't be after applying the modifier either!
            ModValue = 95.0
        EndIf        
        If Utility.RandomFloat(0.0, 99.9) < ModValue
            Libs.PlayerRef.RemoveItem(DeviceKey, Utility.RandomInt(1, NumberOfKeysNeeded))
            libs.SendDeviceKeyBreakEventVerbose(deviceInventory, zad_DeviousDevice, akActor)
            If Utility.RandomFloat(0.0, 99.9) < (LockJamChance * CalculateKeyModifier(False)) && !libs.Config.DisableLockJam
                ; broken key becomes stuck in the lock
                libs.SendDeviceJamLockEventVerbose(deviceInventory, zad_DeviousDevice, akActor)
                StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 1)
                if zad_DD_KeyBreakJamMSG
                    zad_DD_KeyBreakJamMSG.Show()
                Else
                    libs.zad_DD_KeyBreakJamMSG.Show()
                EndIf
            Else
                If zad_DD_KeyBreakMSG
                    zad_DD_KeyBreakMSG.Show()
                Else
                    libs.zad_DD_KeyBreakMSG.Show()
                EndIf
            EndIf
            Return False
        EndIf
        If DestroyKey
            libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)
        elseif libs.Config.GlobalDestroyKey && DeviceKey.HasKeyword(libs.zad_NonUniqueKey)
            libs.PlayerRef.RemoveItem(DeviceKey, NumberOfKeysNeeded, False)    
        EndIf    
    EndIf        
    ; could call ProcessLinkedDeviceOnUnlock(Actor akActor)    here, but there is a theoretical chance that OnUnequipped() will not be completed before the new device will get locked on, so we're just signaling OnUnequipped() to do it.
    StorageUtil.SetIntValue(akActor, "zad_UntightenToken" + deviceInventory, 1)
    RemoveDevice(akActor)
    return True
EndFunction

Function ResetLockShield()
    DeviceEquippedAt = Utility.GetCurrentGameTime()
    SetLockShield()
EndFunction

Function SetLockShield()
    If (LockShieldTimerMin > 0.0) && (LockShieldTimerMin <= LockShieldTimerMax)
        if LockShieldTimerMin == LockShieldTimerMax
            LockShieldTimer = LockShieldTimerMin
        else
            LockShieldTimer = CalculateTimerModifier(LockShieldTimerMin, LockShieldTimerMax)
        endif
    Else
        LockShieldTimer = 0.0
    EndIf
EndFunction

Bool Function CheckLockShield()
    If LockShieldTimer == 0.0
        return True
    EndIf
    Float HoursNeeded = LockShieldTimer
    Float HoursPassed = (Utility.GetCurrentGameTime() - DeviceEquippedAt) * 24.0
    if HoursPassed > HoursNeeded
        return True
    Else
        Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
        libs.notify("This lock is protected with a timed lock shield preventing you from inserting a key as long as it is active! You can try to unlock this device in about " + HoursToWait + " hours.", messageBox = true)
        return False
    EndIf
EndFunction

Function SetLockTimer()
    If (LockTimerMin > 0.0) && (LockTimerMin <= LockTimerMax)
        if LockTimerMin == LockTimerMax
            LockTimer = LockTimerMin
        else
            LockTimer = CalculateTimerModifier(LockTimerMin, LockTimerMax)
        endIf
        
    Else
        LockTimer = 0.0
    EndIf
EndFunction

Function SyncInventory()
EndFunction

Bool Function CheckLockTimer()
    If LockTimer == 0.0
        return True
    EndIf
    Float HoursNeeded = LockTimer
    Float HoursPassed = (Utility.GetCurrentGameTime() - DeviceEquippedAt) * 24.0
    if HoursPassed > HoursNeeded
        return True
    Else
        Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
        libs.notify("This lock is fitted with a timer that will automatically unlock your restraint in about " + HoursToWait + " hours.", messageBox = true)
        return False
    EndIf
EndFunction

string function GetMessageName(actor akActor)
    if akActor != libs.PlayerRef
        return akActor.GetLeveledActorBase().GetName()+"'s"
    else
        return "your"
    EndIf
EndFunction

Bool Function IsEquipDeviceConflict(Actor akActor)
    If EquipConflictingDevices.Length > 0
        int i = EquipConflictingDevices.Length
        Keyword kw
        bool break = false
        While i > 0 && !break
            i -= 1
            kw = EquipConflictingDevices[i]
            if kw && akActor.WornHasKeyword(kw)
                break = true
            EndIf
        EndWhile
        If break
            If zad_EquipConflictFailMsg
                zad_EquipConflictFailMsg.Show()
            EndIf
            Return True
        Endif
    Endif
    return false
EndFunction

Bool Function IsEquipRequiredDeviceConflict(Actor akActor)
    If EquipRequiredDevices.Length > 0
        int i = EquipRequiredDevices.Length
        Keyword kw
        bool ok = true
        While i > 0 && ok
            i -= 1
            kw = EquipRequiredDevices[i]
            if kw && !akActor.WornHasKeyword(kw)
                ok = false
            EndIf
        EndWhile
        If !ok
            If zad_EquipRequiredFailMsg
                zad_EquipRequiredFailMsg.Show()
            EndIf
            Return True
        Endif
    Endif
    return false
EndFunction

Bool Function IsUnEquipDeviceConflict(Actor akActor)
    If UnEquipConflictingDevices.Length > 0
        int i = UnEquipConflictingDevices.Length
        Keyword kw
        bool break = false
        While i > 0 && !break
            i -= 1
            kw = UnEquipConflictingDevices[i]
            if kw && akActor.WornHasKeyword(kw)
                break = true
            EndIf
        EndWhile
        If break
            If zad_UnEquipFailMsg
                zad_UnEquipFailMsg.Show()
            EndIf
            Return True
        Endif
    Endif
    return false
EndFunction

Bool Function CanMakeUnlockAttempt()
    ; check if the character can make an unlock attempt.
    Float HoursNeeded = (UnlockCooldown * CalculateCooldownModifier(False))
    Float HoursPassed = (Utility.GetCurrentGameTime() - LastUnlockAttemptAt) * 24.0
    if HoursPassed > HoursNeeded
        If !DeviceKey || (DeviceKey && libs.PlayerRef.GetItemCount(DeviceKey) >= NumberOfKeysNeeded)
            ; don't reset the timer if the player doesn't even have keys, that's mean!
            LastUnlockAttemptAt = Utility.GetCurrentGameTime()
        EndIf
        return True
    Else
        Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
        libs.notify("You are still tired from the last attempt, and cannot again try to unlock this device already! You can try again in about " + HoursToWait + " hours.", messageBox = true)
    EndIf
    return False
EndFunction

Bool Function CheckLockAccess()
    ; You can unlock only wrist restraints when wearing wrist restraints.
    If libs.playerRef.WornHasKeyword(libs.zad_DeviousHeavyBondage) && !deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
        libs.notify("You cannot unlock the " + DeviceName + " with your wrists tied.", messageBox = True)
        Return False
    EndIf
    ; cannot remove other DD devices when wearing bondage mittens either
    if !deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage) && (libs.PlayerRef.WornHasKeyword(libs.zad_DeviousBondageMittens) && !deviceRendered.HasKeyword(libs.zad_DeviousBondageMittens))
        libs.NotifyPlayer("You cannot remove the " + deviceName + " while wearing bondage mittens!", true)
        return False
    EndIf    
    If LockAccessDifficulty > 0.0
        If !CanMakeUnlockAttempt()
            Return False
        EndIf
        Float ModValue = (LockAccessDifficulty * CalculateDifficultyModifier(False))
        If (LockAccessDifficulty < 100.0) && (ModValue >= 100.0)
            ; If the modder didn't mean to make it completely impossible to reach the locks, it shouldn't be after applying the modifier either!
            ModValue = 95.0
        EndIf
        If Utility.RandomFloat(0.0, 99.9) < ModValue
            If DeviceKey != None || StorageUtil.GetIntValue(libs.PlayerRef, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_ManipulatedStatus") == 1
                If LockAccessDifficulty < 50.0
                    libs.notify("You try to insert the key into the " + DeviceName + "'s lock, but find the locks a bit outsides of your reach. After a few failed attempts to slide the key into the lock, you have no choice but to give up for now. You should still eventually be able to unlock yourself. Just try again a bit later!", messageBox = True)
                ElseIf LockAccessDifficulty < 100.0
                    libs.notify("This restraint was designed to make it hard for the person wearing it in to unlock herself. You struggle hard trying to insert the key into the " + DeviceName + "'s lock anyway, but find the locks well outsides of your reach. Tired from your struggles, you have no choice but to give up for now. Maybe try again later!", messageBox = True)
                Else
                    libs.notify("This restraint was designed to put the locks safely out of reach of the person wearing it. There is no way you will ever be able to unlock yourself, even when in possession of the proper key. You will need to seek help!", messageBox = True)
                EndIf
            Else
                libs.notify("You try to undo your restraint, but you are unable to reach the locking mechanism!", messageBox = True)
            EndIf
            Return False
        EndIf
    EndIf
    Return True
EndFunction


; ================================================================
; Functions for Inheritance 
; ================================================================

; ===============
; Interface
; ===============
Function NoKeyFailMessage(Actor akActor) ; Display fail removal for devices without a key
    
EndFunction

Function DeviceMenu(Int msgChoice = 0)
    msgChoice = zad_DeviceMsg.Show() ; display menu
    if msgChoice == 0 ; Equip Device voluntarily
        DeviceMenuEquip()
    elseif msgChoice == 1    ; Remove device, with key
        DeviceMenuRemoveWithKey()
    elseif msgChoice == 2 ; Remove device, without key
        DeviceMenuRemoveWithoutKey()
    endif
    DeviceMenuExt(msgChoice)
EndFunction


Function DeviceMenuExt(Int msgChoice)

EndFunction

Function DeviceMenuEquip()
    if libs.PlayerRef.IsEquipped(DeviceRendered) || libs.PlayerRef.WornHasKeyword(zad_DeviousDevice)
        return
    EndIf
    EquipDevice(libs.PlayerRef)
    If zad_DD_OnEquipDeviceMSG
        zad_DD_OnEquipDeviceMSG.Show()
    Else
        libs.zad_DD_OnEquipDeviceMSG.Show()
    EndIf    
EndFunction

function DeviceMenuRemoveWithKey()    
    If !IsUnEquipDeviceConflict(libs.playerref)
        if RemoveDeviceWithKey()
            libs.NotifyPlayer("You succesfully unlock the " + deviceName+".")
        Endif
    Endif
EndFunction

Function DeviceMenuCarryOn()
    libs.Notify("Since there seems to be no obvious way to remove the "+deviceName+" you have no choice but to reluctantly leave it locked on for now.", messageBox=true)
EndFunction

Function DisplayDifficultyMsg()
    Int StruggleEscapeChance = Math.Floor(BaseEscapeChance)
    String result = "You carefully examine the " + DeviceName + ". "
    If StruggleEscapeChance > 75
        result += "This restraint is fairly weak and will not offer much resistance against struggling."
    ElseIf StruggleEscapeChance >= 50
        result += "This is not a very secure restraint. Struggling out should be easy."
    ElseIf StruggleEscapeChance >= 25
        result += "This restraint is somewhat secure, but not overly much so. Struggling out will be moderately difficult."
    ElseIf StruggleEscapeChance >= 15
        result += "This restraint is designed to be secure, but with enough patience could probably be struggled out from."
    ElseIf StruggleEscapeChance >= 10
        result += "This restraint is fairly secure and will be hard to struggle out from, but not impossible."
    ElseIf StruggleEscapeChance >= 5
        result += "This restraint is secure and will be extremely difficult to struggle out from."
    ElseIf StruggleEscapeChance > 0
        result += "This restraint is very secure and will withstand most escape attempts. Struggling out of this device will be almost impossible."
    Else
        result += "This is a high security restraint. Struggling out from this device will be completely impossible!"
    Endif
    result += " "
    If LockPickEscapeChance > 75
        result += "Its lock is weak and will not offer much resistance to pick attempts."
    ElseIf LockPickEscapeChance >= 50
        result += "Its lock is not very secure. Picking it should be easy."
    ElseIf LockPickEscapeChance >= 25
        result += "Its lock is somewhat secure, but not overly much so. Picking it will be moderately difficult."
    ElseIf LockPickEscapeChance >= 15
        result += "Its lock is designed to be secure, but might not withstand serious picking attempts."
    ElseIf LockPickEscapeChance >= 10
        result += "Its lock is fairly secure and will be hard to pick, but not impossible."
    ElseIf LockPickEscapeChance >= 5
        result += "Its lock is secure and will be extremely difficult to pick."
    ElseIf LockPickEscapeChance > 0
        result += "Its lock is very secure and will withstand most attempts to pick it."
    Else
        result += "It has a tamper proof lock. Unlocking it without the proper key will be absolutely impossible!"
    Endif
    result += " "
    If CutDeviceEscapeChance > 75
        result += "Its material is weak and will not offer much resistance to cutting."
    ElseIf CutDeviceEscapeChance >= 50
        result += "Its material is not very tough. Cutting it should be easy."
    ElseIf CutDeviceEscapeChance >= 25
        result += "Its material is somewhat tough, but not overly much so. Cutting it will be moderately difficult."
    ElseIf CutDeviceEscapeChance >= 15
        result += "Its material is tough, but could probably be cut with the right tool and enough effort."
    ElseIf CutDeviceEscapeChance >= 10
        result += "Its material is fairly tough and will be hard to cut, but not impossible."
    ElseIf CutDeviceEscapeChance >= 5
        result += "Its material is hard and will be extremely difficult to cut."
    ElseIf CutDeviceEscapeChance > 0
        result += "Its material is very hard and will withstand most attempts to cut it."
    Else
        result += "Its made of material impossible to cut with any tool!"
    Endif
    libs.notify(result, messageBox = true)
EndFunction

Float Function CalculateDifficultyModifier(Bool operator = true)
    ; We don't modify for quest items
    If deviceInventory.HasKeyword(libs.zad_BlockGeneric) || deviceRendered.HasKeyword(libs.zad_BlockGeneric) || deviceInventory.HasKeyword(libs.zad_QuestItem) || deviceRendered.HasKeyword(libs.zad_QuestItem)
        ; except the modder specifically allowed the system to be used for that item!
        If !AllowDifficultyModifier
            libs.log("Difficulty modifier not applied - custom/quest item!")
            return 1.0
        EndIf
    EndIf
    Float val = 1.0
    Int mcmValue = libs.config.EscapeDifficulty    
    Int mcmLength = libs.config.EsccapeDifficultyList.Length
    Int median = ((mcmLength - 1) / 2) As Int ; This assumes the array to be uneven, otherwise there is no median value.
    Float maxModifier = 0.75 ; set this as desired - it's the maximum possible +/- modifier. It should not be larger than 1 (=100%)
    Float StepLength = maxModifier / median
    Int Steps = mcmValue - median    
    If operator
        val = 1 + (Steps * StepLength)
    Else
        val = 1 - (Steps * StepLength)
    EndIf
    libs.log("Difficulty modifier applied: " + val + " [setting: " + mcmValue + "]")
    return val
EndFunction

Float Function CalculateCooldownModifier(Bool operator = true)
    ; We don't modify for quest items
    If deviceInventory.HasKeyword(libs.zad_BlockGeneric) || deviceRendered.HasKeyword(libs.zad_BlockGeneric) || deviceInventory.HasKeyword(libs.zad_QuestItem) || deviceRendered.HasKeyword(libs.zad_QuestItem)
        ; except the modder specifically allowed the system to be used for that item!
        If !AllowDifficultyModifier
            libs.log("Difficulty modifier not applied - custom/quest item!")
            return 1.0
        EndIf
    EndIf
    Float val = 1.0
    Int mcmValue = libs.config.CooldownDifficulty    
    Int mcmLength = libs.config.EsccapeDifficultyList.Length
    Int median = ((mcmLength - 1) / 2) As Int ; This assumes the array to be uneven, otherwise there is no median value.
    Float maxModifier = 0.9 ; set this as desired - it's the maximum possible +/- modifier. It should not be larger than 1 (=100%)
    Float StepLength = maxModifier / median
    Int Steps = mcmValue - median    
    If operator
        val = 1 + (Steps * StepLength)
    Else
        val = 1 - (Steps * StepLength)
    EndIf
    libs.log("Difficulty modifier applied: " + val + " [setting: " + mcmValue + "]")
    return val
EndFunction

Float Function CalculateTimerModifier(float timerMin, float timerMax)
    ; We don't modify for quest items
    If deviceInventory.HasKeyword(libs.zad_BlockGeneric) || deviceRendered.HasKeyword(libs.zad_BlockGeneric) || deviceInventory.HasKeyword(libs.zad_QuestItem) || deviceRendered.HasKeyword(libs.zad_QuestItem)
        ; except the modder specifically allowed the system to be used for that item!
        If !AllowDifficultyModifier
            libs.log("Difficulty timer modifier not applied - custom/quest item!")
            return Utility.RandomFloat(timerMin,timerMax)
        EndIf
    EndIf
    Float timerRange = timerMax - timerMin
    ;use escape difficulty for calculations
    Int mcmValue = libs.config.EscapeDifficulty    
    Int mcmLength = libs.config.EsccapeDifficultyList.Length
    Float StepLength = timerRange / mcmLength
    ;let's call it escape chance instead - from zero to max
    float upperTargetBound = timerMax - mcmValue * StepLength
    float lowerTargetBound = timerMax - (mcmValue + 1) * StepLength
    float val = timerMin
    float fateValue = Utility.randomFloat(0.0,1.0)
    if fateValue < 0.2
        ; lower range selected
        val = Utility.randomFloat(timerMin,lowerTargetBound)
    elseif fateValue < 0.37
        ; upper range selected
        val = Utility.randomFloat(upperTargetBound,timerMax)
    else
        ; target range selected
        val = Utility.randomFloat(lowerTargetBound,upperTargetBound)
    endIf
    ;sanity checks just because
    if val < timerMin
        val = timerMin
    endIf
    if val > timerMax
        val = timerMax
    endIf
    libs.log("Difficulty timer modifier applied: " + val + " [setting: " + mcmValue + "]")
    return val
EndFunction

Float Function CalculateKeyModifier(Bool operator = true)
    ; We don't modify for quest items
    If deviceInventory.HasKeyword(libs.zad_BlockGeneric) || deviceRendered.HasKeyword(libs.zad_BlockGeneric) || deviceInventory.HasKeyword(libs.zad_QuestItem) || deviceRendered.HasKeyword(libs.zad_QuestItem)
        ; except the modder specifically allowed the system to be used for that item!
        If !AllowDifficultyModifier
            libs.log("Difficulty modifier not applied - custom/quest item!")
            return 1.0
        EndIf
    EndIf
    Float val = 1.0
    Int mcmValue = libs.config.KeyDifficulty    
    Int mcmLength = libs.config.EsccapeDifficultyList.Length
    Int median = ((mcmLength - 1) / 2) As Int ; This assumes the array to be uneven, otherwise there is no median value.
    Float maxModifier = 1 ; set this as desired - it's the maximum possible +/- modifier. It should not be larger than 1 (=100%)
    Float StepLength = maxModifier / median
    Int Steps = mcmValue - median    
    If operator
        val = 1 + (Steps * StepLength)
    Else
        val = 1 - (Steps * StepLength)
    EndIf
    libs.log("Difficulty modifier applied: " + val + " [setting: " + mcmValue + "]")
    return val
EndFunction

Bool Function CanMakeStruggleEscapeAttempt()
    ; check if the character can make an escape attempt
    If libs.PlayerRef.WornHasKeyword(libs.zad_DeviousHeavyBondage) && !deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
        libs.notify("You cannot try to struggle out of the " + DeviceName + " with bound hands.", messageBox = true)
        return False
    EndIf    
    Float HoursNeeded = (EscapeCooldown * CalculateCooldownModifier(False))
    Float HoursPassed = (Utility.GetCurrentGameTime() - LastStruggleEscapeAttemptAt) * 24.0
    if HoursPassed > HoursNeeded
        LastStruggleEscapeAttemptAt = Utility.GetCurrentGameTime()
        return True
    Else
        Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
        libs.notify("You cannot try to struggle out of this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
    EndIf
    return False
EndFunction

Bool Function CanMakeCutEscapeAttempt()
    ; check if the character can make an escape attempt
    If libs.PlayerRef.WornHasKeyword(libs.zad_DeviousHeavyBondage) && !deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
        libs.notify("You cannot try to cut the " + DeviceName + " with bound hands.", messageBox = true)
        return False
    EndIf    
    Float HoursNeeded = (EscapeCooldown * CalculateCooldownModifier(False))
    Float HoursPassed = (Utility.GetCurrentGameTime() - LastCutEscapeAttemptAt) * 24.0
    if HoursPassed > HoursNeeded
        LastCutEscapeAttemptAt = Utility.GetCurrentGameTime()
        return True
    Else
        Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
        libs.notify("You cannot try to cut open this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
    EndIf
    return False
EndFunction

Bool Function CanMakeLockPickEscapeAttempt()
    ; check if the character can make an escape attempt
    ; can't try this with bound hands. We do allow wrist restraints itself, though.
    If libs.PlayerRef.WornHasKeyword(libs.zad_DeviousHeavyBondage) && !deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
        libs.notify("You cannot try to pick the " + DeviceName + " with bound hands.", messageBox = true)
        return False
    EndIf    
    Float HoursNeeded = (EscapeCooldown * CalculateCooldownModifier(False))
    Float HoursPassed = (Utility.GetCurrentGameTime() - LastLockPickEscapeAttemptAt) * 24.0
    if HoursPassed > HoursNeeded
        LastLockPickEscapeAttemptAt = Utility.GetCurrentGameTime()
        return True
    Else
        Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
        libs.notify("You cannot try to pick this device so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
    EndIf
    return False
EndFunction

; returns 0 when the escape attempt fails, 1 at success and -1 when no attempt was made due to cooldown
Int Function Escape(Float Chance)
    StruggleScene(libs.PlayerRef)
    Bool Success = False
    If Chance == 0.0
        ; no need to process, but returning here will prevent catastrophic failures when there is zero chance of success. We're not THAT mean!
        return 0
    Endif
    libs.log("Player is trying to escape " + DeviceName + ". Escape chance after modifiers: " + Chance +"%")
    If Utility.RandomFloat(0.0, 99.9) < (Chance * CalculateDifficultyModifier(True))
        libs.log("Player has escaped " + DeviceName)
        ; increase success counter
        libs.zadDeviceEscapeSuccessCount.SetValueInt(libs.zadDeviceEscapeSuccessCount.GetValueInt() + 1)
        RemoveDevice(libs.PlayerRef)
        libs.SendDeviceEscapeEvent(DeviceInventory, zad_DeviousDevice, true)
        return 1
    Else
        libs.log("Player has failed to escape " + DeviceName)
        libs.SendDeviceEscapeEvent(DeviceInventory, zad_DeviousDevice, false)
    EndIf
    return 0
EndFunction

Bool Function HasValidCuttingTool()
    ; on second thought...this is Skyrim! Does anybody ever NOT carry a blade?
    Return True    
    ; Bool HasValidItem = false    
    ; Int i = libs.zad_DD_StandardCuttingToolsList.GetSize()
    ; While i > 0 && !HasValidItem
        ; i -= 1
        ; Form frm = libs.zad_DD_StandardCuttingToolsList.GetAt(i)
        ; If libs.playerref.GetItemCount(frm) > 0
            ; HasValidItem = True
        ; EndIf
    ; EndWhile    
    ; i = AllowedTool.Length
    ; While i > 0 && !HasValidItem
        ; i -= 1
        ; Form frm = AllowedTool[i]        
        ; If libs.playerref.GetItemCount(frm) > 0
            ; HasValidItem = True
        ; EndIf
    ; EndWhile
    ; return HasValidItem
EndFunction

Float Function CalclulateCutSuccess()
    Float result = CutDeviceEscapeChance
    ; Apply modifiers, but only if the device is not impossible to escape from to begin with.
    If CutDeviceEscapeChance > 0.0
        ; add 1% for every previous attempt
        result += EscapeCutAttemptsMade        
        If Libs.PlayerRef.GetAV("OneHanded") > 25
            result += 1.0
        Endif
        If Libs.PlayerRef.GetAV("OneHanded") > 50
            result += 2.0
        Endif
        If Libs.PlayerRef.GetAV("OneHanded") > 75
            result += 3.0
        Endif
        ; apply bonus for total successful escapes
        Int EscapesMade = libs.zadDeviceEscapeSuccessCount.GetValueInt()
        If EscapesMade > 10
            result += 1.0
        Endif
        If EscapesMade > 25
            result += 1.0
        Endif
        If EscapesMade > 50
            result += 1.0
        Endif
        If EscapesMade > 100
            result += 1.0
        Endif
    Endif
    If result < 0.0
        return 0.0
    ElseIf result > 100.0
        return 100.0
    Endif
    return result
EndFunction

Function EscapeAttemptCut()    
    If !HasValidCuttingTool()
        libs.notify("You do not possess a tool you could use for cutting your " + DeviceName + ".", messageBox = true)
        return
    EndIf
    ; can't try this with bound hands. We do allow cutting wrist restraints itself, though.
    If libs.PlayerRef.WornHasKeyword(libs.zad_DeviousHeavyBondage) && !deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
        libs.notify("You cannot try to cut open the " + DeviceName + " with bound hands.", messageBox = true)
        return
    EndIf
    If !CanMakeCutEscapeAttempt()
        return
    EndIf    
    If zad_DD_EscapeCutMSG
        zad_DD_EscapeCutMSG.Show()
    Else 
        libs.zad_DD_EscapeCutMSG.Show()
    EndIf
    Int i = Escape(CalclulateCutSuccess())
    If i == 1
        ; device got removed in Escape(), so just need to show the success message.
        If zad_DD_EscapeCutSuccessMSG
            zad_DD_EscapeCutSuccessMSG.Show()
        Else
            libs.zad_DD_EscapeCutSuccessMSG.Show()
        EndIf
    Elseif i == 0
        ; catastrophic failure will prevent further escape attempts
        if Utility.RandomFloat(0.0, 99.9) < CatastrophicFailureChance
            CutDeviceEscapeChance = 0.0
            libs.notify("You fail to escape from your " + DeviceName + " and your feeble attempts tighten the device so much that you won't ever be able to cut it open.", messageBox = true)
        Else
            ; regular failure
            EscapeCutAttemptsMade += 1
            If zad_DD_EscapeCutFailureMSG
                zad_DD_EscapeCutFailureMSG.Show()
            Else
                libs.zad_DD_EscapeCutFailureMSG.Show()
            EndIf
        Endif
    EndIf
EndFunction

Function EscapeAttemptLockPick()
    if StorageUtil.GetIntValue(libs.Playerref, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus") == 1
        libs.Notify("You cannot try to pick a jammed lock!", true)
        return
    EndIf
    If !HasValidLockPick()
        libs.notify("You do not possess a pick you could use on your " + DeviceName + ".", messageBox = true)
        return
    EndIf    
    If !CanMakeLockPickEscapeAttempt()
        return
    EndIf
    If zad_DD_EscapeLockPickMSG    
        zad_DD_EscapeLockPickMSG.Show()
    Else
        libs.zad_DD_EscapeLockPickMSG.Show()
    EndIf
    ; first make a check against lock difficulty as you can't pick what you can't reach! The cooldown timer has already reset at this point.
    If Utility.RandomFloat(0.0, 99.9) < LockAccessDifficulty
        libs.notify("You fail to reach your " + DeviceName + "'s locks and can't attempt to pick the lock.", messageBox = true)
        return
    EndIf
    Int i = Escape(CalclulateLockPickSuccess())
    If i == 1
        ; device got removed in Escape(), so just need to show the success message.
        If zad_DD_EscapeLockPickSuccessMSG
            zad_DD_EscapeLockPickSuccessMSG.Show()
        Else
            libs.zad_DD_EscapeLockPickSuccessMSG.Show()
        EndIf
    Elseif i == 0
        ; catastrophic failure will prevent further escape attempts
        if Utility.RandomFloat(0.0, 99.9) < CatastrophicFailureChance
            LockPickEscapeChance = 0.0
            libs.notify("You fail to escape from your " + DeviceName + " and your feeble attempts trigger a safety shield inside the lock, preventing further pick attempts.", messageBox = true)
        Else
            ; regular failure
            EscapeLockPickAttemptsMade += 1
            ; destroy the lockpick
            DestroyLockPick()
            If zad_DD_EscapeLockPickFailureMSG
                zad_DD_EscapeLockPickFailureMSG.Show()
            Else
                libs.zad_DD_EscapeLockPickFailureMSG.Show()
            EndIf
        Endif
    EndIf
EndFunction

Bool Function HasValidLockPick()
    Bool HasValidItem = false
    If AllowLockPick && libs.PlayerRef.GetItemCount(libs.Lockpick) > 0
        return true
    EndIf
    Int i = AllowedLockPicks.Length
    While i > 0 && !HasValidItem
        i -= 1
        Form frm = AllowedLockPicks[i]
        If libs.playerRef.GetItemCount(frm) > 0
            HasValidItem = True
        EndIf
    EndWhile
    return HasValidItem
EndFunction

Bool Function DestroyLockPick()
    Bool LockPickDestroyed = false
    If AllowLockPick && libs.PlayerRef.GetItemCount(libs.Lockpick) > 0
        libs.playerRef.RemoveItem(libs.Lockpick)
        return True
    EndIf
    Int i = AllowedLockPicks.Length
    While i > 0 && !LockPickDestroyed
        i -= 1
        Form frm = AllowedLockPicks[i]
        If libs.playerRef.GetItemCount(frm) > 0 && !(frm As Keyword)
            libs.playerRef.RemoveItem(frm)
            LockPickDestroyed = True
        EndIf
    EndWhile
    return LockPickDestroyed
EndFunction

Float Function CalclulateLockPickSuccess()
    Float result = LockPickEscapeChance
    ; Apply modifiers, but only if the device is not impossible to escape from to begin with.
    If LockPickEscapeChance > 0.0
        ; add 1% for every previous attempt
        result += EscapeLockPickAttemptsMade        
        If Libs.PlayerRef.GetAV("Lockpicking") > 25
            result += 1.0
        Endif
        If Libs.PlayerRef.GetAV("Lockpicking") > 50
            result += 2.0
        Endif
        If Libs.PlayerRef.GetAV("Lockpicking") > 75
            result += 3.0
        Endif
        ; apply bonus for total successful escapes
        Int EscapesMade = libs.zadDeviceEscapeSuccessCount.GetValueInt()
        If EscapesMade > 10
            result += 1.0
        Endif
        If EscapesMade > 25
            result += 1.0
        Endif
        If EscapesMade > 50
            result += 1.0
        Endif
        If EscapesMade > 100
            result += 1.0
        Endif
    Endif
    If result < 0.0
        return 0.0
    ElseIf result > 100.0
        return 100.0
    Endif
    return result
EndFunction

String[] Function SelectStruggleArray(actor akActor)
    If akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt) && !akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
        if struggleIdlesHob.length > 0
            return struggleIdlesHob         ; Use hobbled struggle idles
        else
            return struggleIdles            ; Fall back to standard animations if no hobbled variants are available
        endif
    Else
        return struggleIdles                ; Use regular struggle idles
    Endif
EndFunction

Function StruggleScene(actor akActor)
    if libs.IsAnimating(akActor)
        return
    EndIf
    String[] struggleArray = SelectStruggleArray(akActor)
    int len = struggleArray.length - 1
    If len < 0
        return
    EndIf
    bool[] cameraState = libs.StartThirdPersonAnimation(akActor, struggleArray[Utility.RandomInt(0, len)], true)
    Utility.Wait(10)
    libs.Pant(libs.PlayerRef)
    If zad_DeviousDevice == libs.zad_DeviousHeavyBondage
        Utility.Wait(10)
        libs.Pant(libs.PlayerRef)
        If Utility.RandomInt() < 50
            Utility.Wait(10)
        EndIf
    EndIf
    libs.EndThirdPersonAnimation(akActor, cameraState, true)
    libs.SexlabMoan(libs.PlayerRef)
EndFunction

Function EscapeAttemptStruggle()
    If !CanMakeStruggleEscapeAttempt()
        return
    EndIf
    If zad_DD_EscapeStruggleMSG
        zad_DD_EscapeStruggleMSG.Show()
    Else
        libs.zad_DD_EscapeStruggleMSG.Show()
    EndIf    
    Int i = Escape(CalclulateStruggleSuccess())
    If i == 1
        ; device got removed in Escape(), so just need to show the success message.
        If zad_DD_EscapeStruggleSuccessMSG
            zad_DD_EscapeStruggleSuccessMSG.Show()
        Else
            libs.zad_DD_EscapeStruggleSuccessMSG.Show()
        EndIf
    Elseif i == 0
        ; catastrophic failure will prevent further escape attempts
        if Utility.RandomFloat(0.0, 99.9) < CatastrophicFailureChance
            BaseEscapeChance = 0.0
            libs.notify("You fail to escape from your " + DeviceName + " and your feeble attempts tighten the device so much that you won't ever be able to struggle out from it.", messageBox = true)
        Else
            ; regular failure
            EscapeStruggleAttemptsMade += 1
            If zad_DD_EscapeStruggleFailureMSG
                zad_DD_EscapeStruggleFailureMSG.Show()
            Else
                libs.zad_DD_EscapeStruggleFailureMSG.Show()
            EndIf
        Endif
    EndIf
EndFunction

Float Function CalclulateStruggleSuccess()
    Float result = BaseEscapeChance
    ; Apply modifiers, but only if the device is not impossible to escape from to begin with.
    If BaseEscapeChance > 0.0
        ; add 1% for every previous attempt
        result += EscapeStruggleAttemptsMade        
        ; apply strength bonus
        If Libs.PlayerRef.GetAV("Destruction") > 25 || Libs.PlayerRef.GetAV("Alteration") > 25
            result += 1.0
        Endif
        If Libs.PlayerRef.GetAV("Destruction") > 50 || Libs.PlayerRef.GetAV("Alteration") > 50
            result += 2.0
        Endif
        If Libs.PlayerRef.GetAV("Destruction") > 75 || Libs.PlayerRef.GetAV("Alteration") > 75
            result += 3.0
        Endif        
        ; apply bonus for total successful escapes
        Int EscapesMade = libs.zadDeviceEscapeSuccessCount.GetValueInt()
        If EscapesMade > 10
            result += 1.0
        Endif
        If EscapesMade > 25
            result += 1.0
        Endif
        If EscapesMade > 50
            result += 1.0
        Endif
        If EscapesMade > 100
            result += 1.0
        Endif
    Endif
    If result < 0.0
        return 0.0
    ElseIf result > 100.0
        return 100.0
    Endif
    return result
EndFunction

; returns 0 when the escape attempt fails, 1 at success and -1 when no attempt was made due to cooldown
Int Function RepairJammedLock(Float Chance)
    Bool Success = False
    If Chance == 0.0
        ; no need to process, but returning here will prevent catastrophic failures when there is zero chance of success. We're not THAT mean!
        return 0
    Endif
    libs.log("Player is trying to repair " + DeviceName + ". Repair chance after modifiers: " + Chance +"%")
    ; check if the character can make a repair attempt
    Float HoursNeeded = (RepairCooldown * CalculateCooldownModifier(False))
    Float HoursPassed = (Utility.GetCurrentGameTime() - LastRepairAttemptAt) * 24.0    
    if HoursPassed > HoursNeeded
        LastRepairAttemptAt = Utility.GetCurrentGameTime()
        If Utility.RandomFloat(0.0, 99.9) < (Chance * CalculateDifficultyModifier(True))
            libs.log("Player has repaired " + DeviceName)
            StorageUtil.SetIntValue(libs.playerref, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 0)
            return 1
        Else
            libs.log("Player has failed to repair " + DeviceName)
        EndIf
    Else
        Int HoursToWait = Math.Ceiling(HoursNeeded - HoursPassed)
        libs.notify("You cannot try to repair this device's lock so soon after the last attempt! You can try again in about " + HoursToWait + " hours.", messageBox = true)
        return -1
    EndIf
    return 0
EndFunction

Function DeviceMenuRemoveWithoutKey()
    If IsUnEquipDeviceConflict(libs.playerref)
        return
    Endif
    int msgOption 
    If !zad_DeviceEscapeMsg ; legacy device, use the default message in zadlibs
        msgOption = libs.zad_DeviceEscapeMsg.show()
    Else
        msgOption = zad_DeviceEscapeMsg.show()
    Endif
    If msgOption == 0 ; try to escape        
        If IsUnequipDeviceConflict(libs.PlayerRef)
            Return
        EndIf
        Int EscapeOption
        If !zad_DD_EscapeDeviceMSG ; legacy device, use the default message in zadlibs
            EscapeOption = libs.zad_DD_EscapeDeviceMSG.show()
        Else
            EscapeOption = zad_DD_EscapeDeviceMSG.show()
        Endif        
        If EscapeOption == 0 ; Struggle
            EscapeAttemptStruggle()
        Elseif EscapeOption == 1 ; Pick Lock
            EscapeAttemptLockPick()
        Elseif EscapeOption == 2 ; Cut Device
            EscapeAttemptCut()
        Elseif EscapeOption == 3 ; Examine
            DisplayDifficultyMsg()
        Elseif EscapeOption == 4 ; Repair
            If StorageUtil.GetIntValue(libs.playerref, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus") == 1
                ; this device has a jammed lock
                Int JamOption 
                If zad_DD_RepairLockMSG
                    JamOption = zad_DD_RepairLockMSG.Show()
                Else
                    JamOption = libs.zad_DD_RepairLockMSG.Show()
                EndIf
                If JamOption == 0 ; try
                    Int RepairResult = RepairJammedLock(RepairJammedLockChance)
                    If RepairResult == 0 ; fail
                        If zad_DD_RepairLockFailureMSG
                            zad_DD_RepairLockFailureMSG.Show()
                        Else
                            libs.zad_DD_RepairLockFailureMSG.Show()
                        EndIf
                    Elseif RepairResult == 1 ; success
                        If zad_DD_RepairLockSuccessMSG
                            zad_DD_RepairLockSuccessMSG.Show()
                        Else
                            libs.zad_DD_RepairLockSuccessMSG.Show()
                        EndIf
                        ; no further action needed. Jammed lock status got reset in the function
                    EndIf
                EndIf
            Else
                ; not jammed. Silly player!
                If zad_DD_RepairLockNotJammedMSG
                    zad_DD_RepairLockNotJammedMSG.Show()
                Else
                    libs.zad_DD_RepairLockNotJammedMSG.Show()
                EndIf
            EndIf        
        Elseif EscapeOption == 5 ; Nothing
            If zad_DD_OnLeaveItWornMSG
                zad_DD_OnLeaveItWornMSG.Show()
            EndIf
        EndIf        
    ElseIf msgOption == 1 ; examine
        DisplayDifficultyMsg()
    ElseIf msgOption == 2 ; leave it on
        DeviceMenuCarryOn()
    Endif
EndFunction

; ===============
; Event Equip
; ===============
; Returns 0 if it's okay to proceed. Returns 1 if it is not. Returns 2 if it is not, and the offending item
; must be unequipped.
int Function OnEquippedFilter(actor akActor, bool silent=false)
    return 0
EndFunction

Function OnEquippedPre(actor akActor, bool silent=false)

EndFunction

Function OnEquippedPost(actor akActor)

EndFunction
; ===============
; Event Unequip
; ===============

; 5.0: Looking at these functions, they seems not to be called from ANYWHERE in the framework. Don't be surpised if they don't work. They won't.
; Why I am not fixing it? Because they will never work for NPCs anyway and might just confuse people making content mods.

int Function OnUnequippedFilter(actor akActor)
    return 0
EndFunction

Function OnUnequippedPre(Actor akActor)

EndFunction

Function OnUnequippedPost(Actor akActor)
    
EndFunction
; ===============
; Event OnContainerChanged
; ===============
int Function OnContainerChangedFilter(ObjectReference akNewContainer, ObjectReference akOldContainer)
    return 0
EndFunction

Function OnContainerChangedPre(ObjectReference akNewContainer, ObjectReference akOldContainer)

EndFunction

Function OnContainerChangedPost(ObjectReference akNewContainer, ObjectReference akOldContainer)

EndFunction
; ================================================================
; Functions for Quest use 
; ================================================================
Function OnRemoveDevice(actor akActor)
    ; This is reliably called, so long as the API is used.
EndFunction


Function StoreEquippedDevice(actor akActor)
    StorageUtil.SetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_Inventory", DeviceInventory)
    StorageUtil.SetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_Rendered", DeviceRendered)
    StorageUtil.SetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_Key", DeviceKey)
EndFunction

Function UnsetStoredDevice(actor akActor)
    StorageUtil.UnsetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_Inventory")
    StorageUtil.UnsetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_Rendered")
    StorageUtil.UnsetFormValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_Key")
EndFunction
