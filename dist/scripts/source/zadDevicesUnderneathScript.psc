scriptname zadDevicesUnderneathScript extends Quest

zadLibs Property libs Auto
Armor Property zad_DeviceHider Auto
ArmorAddon Property zad_DeviceHiderAA Auto

int[] Property SlotMaskFilters Auto Hidden
int[] Property ShiftCache Auto Hidden

int Property SlotMask Auto ; Avoid repeated lookups

int Property Setting = 1 Auto Hidden

bool _init = false

;; [30]: 0x00000001
;; [31]: 0x00000002
;; [32]: 0x00000004
;; [33]: 0x00000008
;; [34]: 0x00000010
;; [35]: 0x00000020
;; [36]: 0x00000040
;; [37]: 0x00000080
;; [38]: 0x00000100
;; [39]: 0x00000200
;; [40]: 0x00000400
;; [41]: 0x00000800
;; [42]: 0x00001000
;; [43]: 0x00002000
;; [44]: 0x00004000
;; [45]: 0x00008000
;; [46]: 0x00010000
;; [47]: 0x00020000
;; [48]: 0x00040000
;; [49]: 0x00080000
;; [50]: 0x00100000
;; [51]: 0x00200000
;; [52]: 0x00400000
;; [53]: 0x00800000
;; [54]: 0x01000000
;; [55]: 0x02000000
;; [56]: 0x04000000
;; [57]: 0x08000000
;; [58]: 0x10000000
;; [59]: 0x20000000

Event OnInit()
    RegisterForSingleUpdate(15.0)
EndEvent

Event OnUpdate()
    if !_Init
        SetDefaultSlotMasks()
        _Init = true
    endif
EndEvent

Function Validate()
    OnUpdate()
EndFunction

Function SetDefaultSlotMasks()
    SlotMaskFilters = new int[128]
    ShiftCache = new int [33]
    int i = 0
    while i <= 32
        ShiftCache[i] = Math.LeftShift(1, i)
        i += 1
    EndWhile
    ; SlotMaskFilters[2*4] = Math.LeftShift(1,26) ; For slot 32, hide slot 56.
    HideEquipment(32, 51) ; When slot 32 is equipped, hide slot 51 (Nipple Piercings).
    HideEquipment(32, 56) ; When slot 32 is equipped, hide slot 56 (Chastity Bra's).
    HideEquipment(32, 58) ; When slot 32 is equipped, hide slot 58 (Corsets).
    HideEquipment(32, 49) ; When slot 32 is equipped, hide slot 49 (Belts).
    ;HideEquipment(49, 52) ; When slot 49 (belt) is equipped, hide slot 52 (SoS).
    
    SyncSetting()
EndFunction

Function HideEquipment(int slot1, int slot2)
    if slot1 < 30 || slot1 > 61 || slot2 < 30 || slot2 > 61
        libs.Error("HideEquipment received out of bound slot number.")
    else
        int index = ((slot1 - 30) * 4)
        int i = 0
        while i < 4
            if SlotMaskFilters[index+i] == 0
                SlotMaskFilters[index+i] = ShiftCache[slot2 - 30]
                libs.Log("DevicesUnderneath Registered(" + index+i + ":" + (slot2 - 30)+")")
                return
            EndIf
            i += 1
        EndWhile
        libs.Error("Maximum number of equipment slots reached for slot "+ slot1 + " while trying to hide slot "+ slot2)
    EndIf
EndFunction


Function SyncSetting()
    ZadNativeFunctions.SyncSetting(SlotMaskFilters,Setting)
EndFunction

Function Maintenance()
    ZadNativeFunctions.SyncSetting(SlotMaskFilters,Setting)
EndFunction

Function ApplySlotmask(Actor akActor)
EndFunction

Function RebuildSlotmask(actor akActor)
EndFunction