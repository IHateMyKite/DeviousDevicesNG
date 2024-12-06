scriptName zadNativeFunctions Hidden

Form Function FindMatchingDevice(Actor akActor, Keyword kwd)  global native
bool Function FormHasKeywordString(form theForm, string kwd)  global native
bool Function Print(string msg) global native
     Function CTrace(string msg) global native ;print message to console
     
; === Expressions
; Apply expression from aaExpression to actor akActor
bool    Function ApplyExpression        (Actor akActor, float[] aaExpression, int aiStrength, bool abOpenMouth,int aiPriority)  global native
; Reset expression
; abPhonems = true -> phonems will be reset
; abModifiers = true -> modifiers will be reset
        Function ResetExpression        (Actor akActor, int aiPriority)                                 global native
; Returns phonems and modifiers expression
float[] Function GetExpression          (Actor akActor)                                                 global native
;register gag type. Returns false if gag cant be registered or if it is already registered
Bool    Function RegisterGagType        (Keyword akKeyword, Faction[] aakFactions, Int[] aaiDefaults)   global native
;register default gag type. Returns false if gag cant be registered or if it is already registered
Bool    Function RegisterDefaultGagType (Faction[] aakFactions, Int[] aaiDefaults)                      global native
;updates gag expression
        Function UpdateGagExpression    (Actor akActor)                                                 global native
;reset gag expression (phonems). If actor is gagged, this function will do nothing
        Function ResetGagExpression     (Actor akActor)                                                 global native

; === Device Hider
        Function SyncSetting    (Int[] aaFilter, Int aiSetting = 1)                 global native
        Function SetActorStripped(Actor akActor, Bool abStripped, Int aiArmorFilter = 0xFFFFFFFF, Int aiDeviceFilter = 0x00000000) global native
Bool    Function IsActorStripped(Actor akActor)                                     global native

; === Node hider
        Function HideWeapons    (Actor akActor)                                     global native
        Function ShowWeapons    (Actor akActor)                                     global native

; === Device database
; return render device based on passed inventory device
Armor    Function GetRenderDevice(Armor akInvDevice)                                global native
; return inventory device based on passed render device
Armor    Function GetInventoryDevice(Armor akRendDevice)                            global native
; return render device based on passed inventory device name - note that if there are multiple devices with same name, only first found will be returned
; I do not recommend using this, as when the device name will be edited, this function will stop returning intended device
Armor    Function GetDeviceByName(String asName)                                    global native
;return array of all mods which edit passed device
;array is ordered, where first element is original mod, and last element is the last editing mod
String[] Function GetEditingMods(Armor akInvDevice)                                 global native


; === device property reader
; These functions returns properties from passed inventory devices
;   if aiMode == 0 -> Property is read from LAST iteration of device after device is overwritten by other mods
;   if aiMode != 0 -> Property is read from FIRST iteretion of device before it gets overwritten by other mods (original value)
Form        Function GetPropertyForm        (Armor akInvDevice, String asPropertyName, Form     akDefValue = none   , Int aiMode = 0)  global native
Int         Function GetPropertyInt         (Armor akInvDevice, String asPropertyName, Int      akDefValue = 0      , Int aiMode = 0)  global native
Float       Function GetPropertyFloat       (Armor akInvDevice, String asPropertyName, Float    akDefValue = 0.0    , Int aiMode = 0)  global native
Bool        Function GetPropertyBool        (Armor akInvDevice, String asPropertyName, Bool     akDefValue = false  , Int aiMode = 0)  global native
String      Function GetPropertyString      (Armor akInvDevice, String asPropertyName, String   akDefValue = ""     , Int aiMode = 0)  global native
Form[]      Function GetPropertyFormArray   (Armor akInvDevice, String asPropertyName, Int aiMode = 0)  global native
Int[]       Function GetPropertyIntArray    (Armor akInvDevice, String asPropertyName, Int aiMode = 0)  global native
Float[]     Function GetPropertyFloatArray  (Armor akInvDevice, String asPropertyName, Int aiMode = 0)  global native
Bool[]      Function GetPropertyBoolArray   (Armor akInvDevice, String asPropertyName, Int aiMode = 0)  global native
String[]    Function GetPropertyStringArray (Armor akInvDevice, String asPropertyName, Int aiMode = 0)  global native

; === equip rework
        Function SetDisableUnequip (Actor akActor, Armor akInvDevice, bool abDisableUnequip)    global native
bool    Function GetDisableUnequip (Actor akActor, Armor akInvDevice)                  global native
        Function SetManipulated (Actor akActor, Armor akInvDevice, bool abManip)    global native
bool    Function GetManipulated (Actor akActor, Armor akInvDevice)                  global native

; === Lib functions
; Return all devices
; aiMode - What type of device should be returned
;   aiMode = 0 -> Return all inventory devices
;   aiMode = 1 -> Return all render devices
; abWorn - If only worn devices should be returned
;   abWorn = False -> All devices will be returned
;   abWorn = True  -> Only worn devices will be returned
Armor[]  Function GetDevices(Actor akActor, int aiMode = 0, bool abWorn = False)    global native

; Return worn device based on passed main keyword (set on equip script)
Armor    Function GetWornDevice(Actor akActor, Keyword akKeyword, bool fuzzy = false)                   global native

; Returns true if plugin is installed. Full name with extension is required
Bool    Function PluginInstalled(String asName) global native

; Implementation copied from https://github.com/VersuchDrei/ConsoleUtilSSE/tree/master to prevent ctd by using old version of ConsoleUtils
        Function ExecuteConsoleCmd(String asCmd) global native