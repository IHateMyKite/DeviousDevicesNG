Scriptname zadWidgets extends SKI_WidgetBase
;/
iWant Scaleform (Flash) interface for widgets credits to DaemonPrime
The actioncode in the SWF is modified to start the widget ID with an offset of 100 and named 'DDiWant' instead of iWant.
This should prevent other mods that rely on iWant creating widgets with the same ID. Which creates obvious conflicts.

--------------------------------------------------
-------------- Documentation ---------------------
--------------------------------------------------

***** Layout *****
The widget screen is a grid sized 1280px (horizontal) and 720px (vertical). This grid is always 720p even on a 4K game resolution.
With 0.0,0.0 beeing max top left. And 1280.0,720.0 beeing max bottom right. So to center an object in the screen. 
Use a X position (xpos) of 1280/2 and ypos of 720/2 as you can use calulations in the values. Or just use 640 and 360.
This might vary with ultra-wide monitors. As this system was designed with 16:9 monitors in mind.
Use the provided grid files as reference. Make a screenshot and overlay the png in a photo editor

***** Fonts *****
Default Skyrim:
"$ConsoleFont"
"$StartMenuFont"
"$DialogueFont"
"$EverywhereFont" (default message font)
"$EverywhereBoldFont"
"$EverywhereMediumFont"
"$DragonFont"
"$SkyrimBooks"
"$HandwrittenFont"
"$HandwrittenBold"
"$FalmerFont"
"$DwemerFont"
"$DaedricFont"
"$MageScriptFont"
"$SkyrimSymbolsFont"

Custom added by Iwant:
"Nova Cut"
"Medieval Sharp"
"Minipax"
"Sofia"

***** Colors *****
Colors are set in RGB format. With values 0 to 255. Use any random online color picker to get the RGB values
Some examples to check the output of the color picker
Black R:0 G:0 B:0 Pink R:252 G:5 B:141 White R:255 G:255 B:255

***** Transparency *****
Alpha values can be used to make text/objects (semi) transparant 0 is fully transparant 100 is fully visible
To pop in text from a widget with ID "TextWidget" in 3 seconds without a delay
doTransitionByTime(TextWidget, 100, 3.0, "alpha", "None", "None", 0.0)

***** Meters *****
Some gotchas. Meters support most widget commands. "setSize" breaks the meter display, use "setZoom" instead. 
"setRGB" will color the entire meter, "setMeterRGB" results in more appropriate results for most use cases.
"setMeterPercent" has no effects to it. For a more transitional effect use doTransitionByTime with "meterpercent"
You can also use this with fancy effects like "bounce" or "elastic". Be sure to have "easingMethod" not set to "none"

***** Cleanup *****
When you no longer need an object. Call 'destroy' on it's ID. Otherwise it will remain in memory

***** Persistence *****
Widgets only exist in the context of a running game session. So add a function to reload/redisplay on game load if required.

Examples:
	zadWidgets Property DDWidgets Auto
	int TextWidget
	int MeterWidget
	int IconA
	**you can also move these variables to the function if you don't need them globally**

	Show a message center screen, in white with default font in size 24. Wait x seconds to remove it again
	Function ShowTextAndWait(String msg, Float WaitTimeSeconds)
		TextWidget = DDWidgets.loadText(msg, "$EverywhereFont", 24, 10000, 10000, False)
		DDWidgets.setPos(TextWidget, 1280/2, 720/2)
		DDWidgets.setRGB(TextWidget, 255, 255, 255)
		DDWidgets.sendToFront(TextWidget)
		DDWidgets.setVisible(TextWidget, 1)
		Utility.Wait(WaitTimeSeconds)
		DDWidgets.sendToBack(TextWidget)
		DDWidgets.destroy(TextWidget)
	EndFunction

	Show a full (100%) meter with pruple bar on the left side of the screen. Below the center. That is 25% thicker than normal.
	It empties the bar in 5 seconds using the default effect
	Function ShowMeter()
		MeterWidget = DDWidgets.loadMeter(10000, 10000, False)
		DDWidgets.setPos(MeterWidget, 1280/3, (720/3)*2)
		DDWidgets.setMeterRGB(MeterWidget, 179, 100, 222, 60, 7, 89, 127,127,127)
		DDWidgets.setZoom(MeterWidget, 100, 125)
		DDWidgets.setMeterPercent(MeterWidget, 100)
		DDWidgets.sendToFront(MeterWidget)
		DDWidgets.setVisible(MeterWidget, 1)
		DDWidgets.doTransitionByTime(MeterWidget, 0, 5.0, "meterpercent", "regular", "in", 0.0)

		**Dont forget to call DDWidgets.destroy(MeterWidget) in another function**
	EndFunction
	
	Show the keyboard key icon 'a' at 75% of it's size (they are quite big so I recommend a max of 75%)
	Function ShowAIcon()
		IconA = DDWidgets.loadControlIcon("a", 10000, 10000, False)
		DDWidgets.setTransparency(IconA, 50) **optional**
		DDWidgets.setPos(IconA, 160, 180)
		DDWidgets.setZoom(IconA, 75, 75)
		DDWidgets.sendToFront(IconA)
		DDWidgets.setVisible(IconA, 1)
		
		**Dont forget to call DDWidgets.destroy(IconA) in another function**
	EndFunction
/;

;--------------------------------------------------
;----------- Devious Devices code -----------------
;--------------------------------------------------

zadlibs Property libs Auto

int Property WidgetMode Auto ;1 Basic 2 Default with MovementDisabled (disablecontrols) 3 Default with Inventory and MovementDisabled 4 Everything

;/
Check docs zadWidgets control list file for the control names. For example "capslock" or "a". 
This uses the icons exported from "Skyrim - Interface.bsa", but without the '.png' in the filename
Icons are alligned from the center of the icon. So imagine drawing an X over the icon.
Starting top left to bottom right. The other top right to bottom left. The point where the lines meet is where you place the icon.
This is the value you provide to xpos and ypos.
/;
Int Function loadControlIcon(String Control, Int xpos = 10000, Int ypos = 10000, Bool visible = False)
	String path
	Int id
	
	path = "widgets/iwantDD/library/Controls/" + Control + ".dds"
	id = loadWidget(path, xpos, ypos, visible)
	
	Return(id)
EndFunction

;/----------- Default setting wrappers -----------------

These functions provide a way to quickly display the 3 widget types with their default 'required' calls.
Color is defined in default RGB (0-255), not hex.
DisplayTime is in seconds, if set to 0 then it will stay onscreen unless 'destroy' is called on the ID. It does not count menutime!
/;

int Function ShowControlIcon(String Control, Int xpos, Int ypos, int zoomX = 75, int zoomY = 75, int DisplayTime = 0)
	int SCI = loadControlIcon(Control, 10000, 10000, False)
	if SCI > 0
		setPos(SCI, xpos, ypos)
		setZoom(SCI, zoomX, zoomY)
		sendToFront(SCI)
		setVisible(SCI, 1)
		if DisplayTime > 0
			StartDestroyTimer(SCI, DisplayTime)
		endif
	Else
		Libs.Log("ShowControlIcon could not be initialised because of an error. Check input values", level=2)
	endif
	
	Return(SCI)
EndFunction

int Function ShowDefaultText(String msg, Int xpos, Int ypos, int FontSize = 24, int TextR = 255, int TextG = 255, int TextB = 255, int DisplayTime = 0)
	int SDT = loadText(msg, "$EverywhereFont", FontSize, 10000, 10000, False)
	if SDT > 0
		setPos(SDT, xpos, ypos)
		setRGB(SDT, TextR, TextG, TextB)
		sendToFront(SDT)
		setVisible(SDT, 1)
		if DisplayTime > 0
			StartDestroyTimer(SDT, DisplayTime)
		endif
	Else
		Libs.Log("ShowDefaultText could not be initialised because of an error. Check input values", level=2)
	endif
	
	Return(SDT)
EndFunction

int Function ShowDefaultBar(String Control, Int xpos, Int ypos, int zoomX = 100, int zoomY = 100, Int lightR = 255, Int lightG = 255, Int lightB = 255, Int darkR = 0, Int darkG = 0, Int darkB = 0, Int flashR = 127, Int flashG = 127, Int flashB = 127, Int MeterPercent = 100, int DisplayTime = 0)
	int SDB = loadMeter(10000, 10000, False)
	if SDB > 0
		setPos(SDB, xpos, ypos)
		setMeterRGB(SDB, lightR, lightG, lightB, darkR, darkG, darkB, flashR, flashG, flashB)
		setZoom(SDB, zoomX, zoomY)
		setMeterPercent(SDB, MeterPercent)
		sendToFront(SDB)
		setVisible(SDB, 1)
		if DisplayTime > 0
			StartDestroyTimer(SDB, DisplayTime)
		endif
	Else
		Libs.Log("ShowDefaultBar could not be initialised because of an error. Check input values", level=2)
	endif
	
	Return(SDB)
EndFunction

;/---------------- Timer Section -----------------------

As Skyrim only supports 1 active timer per script we require some jank to allow for multiple timers. 
It has a maximum of 10 timers, which seems enough. It only works on full seconds and doesn't count menutime
/;

bool Property TimerIsTicking = false Auto Hidden

int Property Timer1Ticks = -1 Auto Hidden
int Property Timer1WidgetID = -1 Auto Hidden

int Property Timer2Ticks = -1 Auto Hidden
int Property Timer2WidgetID = -1 Auto Hidden

int Property Timer3Ticks = -1 Auto Hidden
int Property Timer3WidgetID = -1 Auto Hidden

int Property Timer4Ticks = -1 Auto Hidden
int Property Timer4WidgetID = -1 Auto Hidden

int Property Timer5Ticks = -1 Auto Hidden
int Property Timer5WidgetID = -1 Auto Hidden

int Property Timer6Ticks = -1 Auto Hidden
int Property Timer6WidgetID = -1 Auto Hidden

int Property Timer7Ticks = -1 Auto Hidden
int Property Timer7WidgetID = -1 Auto Hidden

int Property Timer8Ticks = -1 Auto Hidden
int Property Timer8WidgetID = -1 Auto Hidden

int Property Timer9Ticks = -1 Auto Hidden
int Property Timer9WidgetID = -1 Auto Hidden

int Property Timer10Ticks = -1 Auto Hidden
int Property Timer10WidgetID = -1 Auto Hidden


Function StartDestroyTimer(int WidgetID, int seconds)
	if seconds <= 0
		Libs.Log("StartDestroyTimer seconds needs to be 1 or more. Changing to 1", level=1)
		seconds = 1
	endif
	
	if WidgetID <= 0
		Libs.Log("StartDestroyTimer got WidgetID that is smaller or qual to 0. This is invalid. Skipping timer.", level=2)
		return
	endif
	
	if Timer1Ticks == -1
		Timer1Ticks = seconds
		Timer1WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer2Ticks == -1
		Timer2Ticks = seconds
		Timer2WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer3Ticks == -1
		Timer3Ticks = seconds
		Timer3WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer4Ticks == -1
		Timer4Ticks = seconds
		Timer4WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer5Ticks == -1
		Timer5Ticks = seconds
		Timer5WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer6Ticks == -1
		Timer6Ticks = seconds
		Timer6WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer7Ticks == -1
		Timer7Ticks = seconds
		Timer7WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer8Ticks == -1
		Timer8Ticks = seconds
		Timer8WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer9Ticks == -1
		Timer9Ticks = seconds
		Timer9WidgetID = WidgetID
		CheckTimer()
		return
	elseif Timer10Ticks == -1
		Timer10Ticks = seconds
		Timer10WidgetID = WidgetID
		CheckTimer()
		return
	endif
	
	;this should only be reached if all 10 timers are active.
	Libs.Log("StartDestroyTimer 10 timers are already active. Distroying widget to prevent it getting stuck on screen", level=2)
	Destroy(WidgetID)
endFunction

Function CheckTimer()
	if !TimerIsTicking
		RegisterForSingleUpdate(1)
		TimerIsTicking = true
	endif
endFunction

Event OnUpdate()	
	if Timer1Ticks != -1
		Timer1Ticks = Timer1Ticks - 1
		if Timer1Ticks == 0
			destroy(Timer1WidgetID)
			Timer1Ticks = -1
			Timer1WidgetID = -1
		endif
	elseif Timer2Ticks != -1
		Timer2Ticks = Timer2Ticks - 1
		if Timer2Ticks == 0
			destroy(Timer2WidgetID)
			Timer2Ticks = -1
			Timer2WidgetID = -1
		endif
	elseif Timer3Ticks != -1
		Timer3Ticks = Timer3Ticks - 1
		if Timer3Ticks == 0
			destroy(Timer3WidgetID)
			Timer3Ticks = -1
			Timer3WidgetID = -1
		endif
	elseif Timer4Ticks != -1
		Timer4Ticks = Timer4Ticks - 1
		if Timer4Ticks == 0
			destroy(Timer4WidgetID)
			Timer4Ticks = -1
			Timer4WidgetID = -1
		endif
	elseif Timer5Ticks != -1
		Timer5Ticks = Timer5Ticks - 1
		if Timer5Ticks == 0
			destroy(Timer5WidgetID)
			Timer5Ticks = -1
			Timer5WidgetID = -1
		endif
	elseif Timer6Ticks != -1
		Timer6Ticks = Timer6Ticks - 1
		if Timer6Ticks == 0
			destroy(Timer6WidgetID)
			Timer6Ticks = -1
			Timer6WidgetID = -1
		endif
	elseif Timer7Ticks != -1
		Timer7Ticks = Timer7Ticks - 1
		if Timer7Ticks == 0
			destroy(Timer7WidgetID)
			Timer7Ticks = -1
			Timer7WidgetID = -1
		endif
	elseif Timer8Ticks != -1
		Timer8Ticks = Timer8Ticks - 1
		if Timer8Ticks == 0
			destroy(Timer8WidgetID)
			Timer8Ticks = -1
			Timer8WidgetID = -1
		endif
	elseif Timer9Ticks != -1
		Timer9Ticks = Timer9Ticks - 1
		if Timer9Ticks == 0
			destroy(Timer9WidgetID)
			Timer9Ticks = -1
			Timer9WidgetID = -1
		endif
	elseif Timer10Ticks != -1
		Timer10Ticks = Timer10Ticks - 1
		if Timer10Ticks == 0
			destroy(Timer10WidgetID)
			Timer10Ticks = -1
			Timer10WidgetID = -1
		endif
	endif	
	
	;only re-register for an update if any timers are still active
	if Timer1Ticks != -1 && Timer2Ticks != -1 && Timer3Ticks != -1 && Timer4Ticks != -1 && Timer5Ticks != -1 && Timer6Ticks != -1 && Timer7Ticks != -1 && Timer8Ticks != -1 && Timer9Ticks != -1 && Timer10Ticks != -1
		RegisterForSingleUpdate(1)
	else
		TimerIsTicking = false
	endif
EndEvent

;/---------------- Display modes -----------------------

Modes determine when the widgets are visible. 
'all' is the default game hud, without any menus open. But if 'DialogueMode' is not added, all displayed widgets will be invisible when the PC initiates dialogue
Most are straitforward, but there are a few exceptions.

The Lockpick menu on doors and containers is linked to 'InventoryMode', so this overlaps with the generic inventory menu.
JournalMode is the main menu. use with caution
VATSPlayback is referenced in the code but seems obsolete?

This allows for more control in scenes and activities. But keep in mind the widgets can clip into other HUD elemets. So use with care.
The default mode is recommended for normal, non-controlled situations.

If you want to check what mode is active. Listen for this event and when the mode changes, get the name in the "strArg" on the response Event 
RegisterForModEvent("SKIWF_hudModeChanged", "OnhudModeChanged")
event OnhudModeChanged(string eventName, string strArg, float numArg, Form sender)
/;

Function SetDefaultMode()
	if WidgetMode == 1
		SetBasicModes()
	elseif WidgetMode == 2
		SetMovementModes()
	elseif WidgetMode == 3
		SetInventoryModes()
	elseif WidgetMode == 4
		SetAllModes()
	else
		Libs.Log("SetDefaultMode got an illegal mode ID", level=2)
		return
	endif
endFunction

Function SetBasicModes()
	string[] hudModes = new string[6]
	hudModes[0] = "All"
	hudModes[1] = "StealthMode"
	hudModes[2] = "Favor"
	hudModes[3] = "Swimming"
	hudModes[4] = "HorseMode"
	hudModes[5] = "WarHorseMode"
	Modes = hudModes
	
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".setModes", Modes)
	
	WidgetMode = 1
	
	;UI.Invoke(HUD_MENU, WidgetRoot + ".initCommit")
endFunction

Function SetMovementModes()
	string[] hudModes = new string[7]
	hudModes[0] = "All"
	hudModes[1] = "StealthMode"
	hudModes[2] = "Favor"
	hudModes[3] = "Swimming"
	hudModes[4] = "HorseMode"
	hudModes[5] = "WarHorseMode"
	hudModes[6] = "MovementDisabled"
	Modes = hudModes
	
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".setModes", Modes)
	
	WidgetMode = 2
endFunction

Function SetInventoryModes()
	string[] hudModes = new string[8]
	hudModes[0] = "All"
	hudModes[1] = "StealthMode"
	hudModes[2] = "Favor"
	hudModes[3] = "Swimming"
	hudModes[4] = "HorseMode"
	hudModes[5] = "WarHorseMode"
	hudModes[6] = "MovementDisabled"
	hudModes[7] = "InventoryMode"
	Modes = hudModes
	
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".setModes", Modes)
	
	WidgetMode = 3
endFunction

Function SetAllModes()
	string[] hudModes = new string[15]
	hudModes[0] = "All"
	hudModes[1] = "StealthMode"
	hudModes[2] = "Favor"
	hudModes[3] = "Swimming"
	hudModes[4] = "HorseMode"
	hudModes[5] = "WarHorseMode"
	hudModes[6] = "MovementDisabled"
	hudModes[7] = "InventoryMode"
	hudModes[8] = "BookMode"
	hudModes[9] = "DialogueMode"
	hudModes[10] = "BarterMode"
	hudModes[11] = "TweenMode"
	hudModes[12] = "WorldMapMode"
	hudModes[13] = "CartMode"
	hudModes[14] = "SleepWaitMode"
	;hudModes[15] = "JournalMode"
	;hudModes[16] = "VATSPlayback"
	Modes = hudModes
	
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".setModes", Modes)
	
	WidgetMode = 4
endFunction

int Function GetWidgetMode()
	return WidgetMode
Endfunction

;--------------------------------------------------
;------------ Iwant Widgets code ------------------
;--------------------------------------------------

String PARAMETER_DEMARC = "|" ; Must match ActionScript code, used to pass strings as arrays, ideally the most unused character possible, really obscure values got messy with Unicode
Bool loadInProgress = False

Int Function loadWidget(String filename, Int xpos = 10000, Int ypos = 10000, Bool visible = False)
	String[] value
	String s
	value = Utility.CreateStringArray(4, "")
	value[0] = filename
	value[1] = xpos As String
	value[2] = ypos As String
	value[3] = (visible As Int) As String
	s = _serializeArray(value)

	Int id
	
	_waitForReadyToLoad()
	loadInProgress = True
	UI.InvokeString(HUD_MENU, WidgetRoot + ".loadWidget", s)
	id = (_getMessageFromFlash()) As Int
	loadInProgress = False

	Return(id)	
EndFunction

Int Function loadLibraryWidget(String filename, Int xpos = 10000, Int ypos = 10000, Bool visible = False)
	String libraryPrefix = "widgets/iwantDD/library/"
	String path
	Int id
	
	path = libraryPrefix + filename + ".dds"
	id = loadWidget(path, xpos, ypos, visible)
	
	Return(id)
EndFunction

Int Function loadText(String displayString, String font = "$EverywhereFont", Int size = 24, Int xpos = 10000, Int ypos = 10000, Bool visible = False)
	String[] value
	String s
	value = Utility.CreateStringArray(6, "")
	value[0] = displayString
	value[1] = font
	value[2] = size As String
	value[3] = xpos As String
	value[4] = ypos As String
	value[5] = (visible As Int) As String
	s = _serializeArray(value)

	Int id
	Bool loading
	Bool msgReady
	
	_waitForReadyToLoad()
	loadInProgress = True
	UI.InvokeString(HUD_MENU, WidgetRoot + ".loadText", s)
	id = (_getMessageFromFlash()) As Int
	loadInProgress = False

	Return(id)	
EndFunction

Int Function loadMeter(Int xpos = 10000, Int ypos = 10000, Bool visible = False)
	String[] value
	String s
	value = Utility.CreateStringArray(3, "")
	value[0] = xpos As String
	value[1] = ypos As String
	value[2] = (visible As Int) As String
	s = _serializeArray(value)

	Int id
	Bool loading
	Bool msgReady
	String inputString = ""
	
	_waitForReadyToLoad()
	loadInProgress = True
	UI.InvokeString(HUD_MENU, WidgetRoot + ".loadMeter", s)
	id = (_getMessageFromFlash()) As Int
	loadInProgress = False

	Return(id)
EndFunction

Function _waitForReadyToLoad()
	int breakout = 0

	; Make sure we have a valid SkyUI widget
	While (WidgetRoot == "")
		Utility.Wait(1.0)
	EndWhile

	; Make sure SkyUI say we're Ready
	While (!Ready)
		Utility.Wait(1.0)
	EndWhile


	; Make sure another loading call is not underway
	While loadInProgress
		Utility.Wait(0.1)

		; Seems like there's a race condition in how this check gets executed (funny since it was made to avoid a different race condition)
		; Based on reports from users, it seems there is a way for parallel changes to loadInProgress to happen
		;  resulting in a corruption of the variable and a permanent true state
		; This new breakout counter code adds a sanity check, arbitrarily I've added logic that loading shouldn't take more than 5 seconds
		; After this arbitrary timer, break out of the loop regardless.  Hopefully the odds of this being incorrect are so low
		;  they will not impact any game in actual practice and forcing the breakout clears the problems users have seen.
		breakout += 1
		If breakout > 50
			loadInProgress = False
		EndIf

	EndWhile
EndFunction

String Function _getMessageFromFlash()
	Bool msgReady
	String msg
	; Wait for widget ID to be ready
	msgReady = UI.GetBool(HUD_MENU, WidgetRoot + ".outputReady")
	While !msgReady
		msgReady = UI.GetBool(HUD_MENU, WidgetRoot + ".outputReady")
		Utility.Wait(0.1)
	EndWhile
	
	msg = UI.GetString(HUD_MENU, WidgetRoot + ".outputMessage")

	; Restore Flash message variables back to safe state
	UI.SetString(HUD_MENU, WidgetRoot + ".outputMessage","")
	UI.SetBool(HUD_MENU, WidgetRoot + ".outputReady",false)
	
	Return(msg)
EndFunction

Function setMeterPercent(Int id, Int percent)
	String s
	String[] value
	
	value = new String[2]
	value[0] = id As String
	value[1] = percent As String

	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setMeterPercent", s)
EndFunction

Function setMeterFillDirection(Int id, String direction)
	String s
	String[] value
	
	value = new String[2]
	value[0] = id As String
	value[1] = direction

	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setMeterFillDirection", s)
EndFunction

Function sendToBack(Int id)
	String s
	String[] value
	
	value = new String[2]
	value[0] = id As String

	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".sendToBack", s)
EndFunction

Function sendToFront(Int id)
	String s
	String[] value
	
	value = new String[2]
	value[0] = id As String

	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".sendToFront", s)
EndFunction

Function doMeterFlash(Int id)
	String[] value
	String s

	value = Utility.CreateStringArray(1, "")
	value[0] = id As String
	s = _serializeArray(value)

	UI.InvokeString(HUD_MENU, WidgetRoot + ".doMeterFlash", s)
EndFunction

Function setMeterRGB(Int id, Int lightR = 255, Int lightG = 255, Int lightB = 255, Int darkR = 0, Int darkG = 0, Int darkB = 0, Int flashR = 127, Int flashG = 127, Int flashB = 127)
	String s
	String[] value
	
	value = Utility.CreateStringArray(4, "")
	value[0] = id As String
	value[1] = ((lightR * 256 * 256) + (lightG * 256) + lightB) As String
	value[2] = ((darkR * 256 * 256) + (darkG * 256) + darkB) As String
	value[3] = ((flashR * 256 * 256) + (flashG * 256) + flashB) As String

	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setMeterColors", s)
EndFunction

Function setText(Int id, String displayString)
	String s
	String[] value
	
	value = Utility.CreateStringArray(2, "")
	value[0] = id As String
	value[1] = displayString

	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setText", s)
EndFunction

Function appendText(Int id, String displayString)
	String s
	String[] value

	value = Utility.CreateStringArray(2, "")
	value[0] = id As String
	value[1] = displayString
	
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".appendText", s)
EndFunction

Function swapDepths(Int id1, Int id2)
	String s
	String[] value
	
	value = new String[2]
	value[0] = id1 As String
	value[1] = id2 As String

	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".swapDepths", s)
EndFunction

Function setPos(Int id, Int xpos, Int ypos)
	String[] value
	String s

	value = Utility.CreateStringArray(2, "")
	value[0] = id As String

	value[1] = xpos As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setXPos", s)

	value[1] = ypos As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setYPos", s)
EndFunction

Function setSize(Int id, Int h, Int w)
	String[] value
	String s

	value = Utility.CreateStringArray(2, "")
	value[0] = id As String

	value[1] = h As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setHeight", s)

	value[1] = w As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setWidth", s)
EndFunction

Int Function getXsize(Int id)
	String[] value
	String s
	
	Int size

	value = Utility.CreateStringArray(1, "")
	value[0] = id As String
	s = _serializeArray(value)

	_waitForReadyToLoad()
	loadInProgress = True
	UI.InvokeString(HUD_MENU, WidgetRoot + ".getXsize", s)
	size = (_getMessageFromFlash()) As Int
	loadInProgress = False

	Return(size)
EndFunction

Int Function getYsize(Int id)
	String[] value
	String s
	
	Int size

	value = Utility.CreateStringArray(1, "")
	value[0] = id As String
	s = _serializeArray(value)

	_waitForReadyToLoad()
	loadInProgress = True
	UI.InvokeString(HUD_MENU, WidgetRoot + ".getYsize", s)
	size = (_getMessageFromFlash()) As Int
	loadInProgress = False

	Return(size)
EndFunction

Function setZoom(Int id, Int xscale, Int yscale)
	String[] value
	String s
	
	value = Utility.CreateStringArray(2, "")
	value[0] = id As String
	
	value[1] = xscale As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setXScale", s)

	value[1] = yscale As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setYScale", s)
EndFunction

Function setVisible(Int id, Int visible = 1)
	String[] value
	String s
	
	value = Utility.CreateStringArray(2, "")
	value[0] = id As String
	
	value[1] = visible As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setVisible", s)
EndFunction

Function setRotation(Int id, Int rotation)
	String[] value
	String s
	
	value = Utility.CreateStringArray(2, "")
	value[0] = id As String
	
	value[1] = rotation As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setRotation", s)
EndFunction

Function setTransparency(Int id, Int a)
	String[] value
	String s
	
	value = Utility.CreateStringArray(2, "")
	value[0] = id As String
	
	value[1] = a As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setAlpha", s)
EndFunction

Function setRGB(Int id, Int r, Int g, Int b)
	String[] value
	String s

	Int color = (r * 65536) + (g * 256) + b
	
	value = Utility.CreateStringArray(2, "")
	value[0] = id As String
	value[1] = color As String
	s = _serializeArray(value)

	UI.InvokeString(HUD_MENU, WidgetRoot + ".setColor", s)
EndFunction

Function destroy(Int id)
	String[] value
	String s

	value = Utility.CreateStringArray(1, "")
	value[0] = id As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".destroy", s)
EndFunction

Function drawShapeLine(Int[] list, Int XPos = 639, Int YPos = 359, Int XChange = 25, Int YChange = 25, Bool skipInvisible = True, Bool skipAlpha0 = True)
	String[] value
	String s
	Int i = 0
	
	value = Utility.CreateStringArray((list.Length + 6), "")
	value[0] = XPos As String
	value[1] = YPos As String
	value[2] = XChange As String
	value[3] = YChange As String
	value[4] = (skipInvisible As Int) As String
	value[5] = (skipAlpha0 As Int) As String
	While i < list.Length
		value[(i + 6)] = list[i]
		i += 1
	EndWhile
	
	s = _serializeArray(value)

	UI.InvokeString(HUD_MENU, WidgetRoot + ".drawLine", s)
EndFunction

Function drawShapeCircle(Int[] list, Int XPos = 639, Int YPos = 359, Int radius = 50, Int startAngle = 0, Int degreeChange = 45, Bool skipInvisible = True, Bool skipAlpha0 = True, Bool autoSpace = False)
	String[] value
	String s
	Int i = 0
	
	value = Utility.CreateStringArray((list.Length + 8), "")
	value[0] = XPos As String
	value[1] = YPos As String
	value[2] = radius As String
	value[3] = startAngle As String
	value[4] = degreeChange As String
	value[5] = (skipInvisible As Int) As String
	value[6] = (skipAlpha0 As Int) As String
	value[7] = (autoSpace As Int) As String
	While i < list.Length
		value[(i + 8)] = list[i]
		i += 1
	EndWhile
	
	s = _serializeArray(value)

	UI.InvokeString(HUD_MENU, WidgetRoot + ".drawCircle", s)
EndFunction

Function drawShapeOrbit(Int[] list, Int XPos = 639, Int YPos = 359, Int radius = 50, Int startAngle = 0, Int degreeChange = 45, Bool skipInvisible = True, Bool skipAlpha0 = True, Bool autoSpace = False)
	String[] value
	String s
	Int i = 0
	
	value = Utility.CreateStringArray((list.Length + 8), "")
	value[0] = XPos As String
	value[1] = YPos As String
	value[2] = radius As String
	value[3] = startAngle As String
	value[4] = degreeChange As String
	value[5] = (skipInvisible As Int) As String
	value[6] = (skipAlpha0 As Int) As String
	value[7] = (autoSpace As Int) As String
	While i < list.Length
		value[(i + 8)] = list[i]
		i += 1
	EndWhile
	
	s = _serializeArray(value)

	UI.InvokeString(HUD_MENU, WidgetRoot + ".drawOrbit", s)
EndFunction

Function doTransition(Int id, Int targetValue, Int frames = 60, String targetAttribute = "alpha", String easingClass = "none", String easingMethod = "none", Int delay = 0)
	doTransitionByFrames(id, targetValue, frames, targetAttribute, easingClass, easingMethod, delay, fps = 30)
EndFunction

Function doTransitionByFrames(Int id, Int targetValue, Int frames = 120, String targetAttribute = "alpha", String easingClass = "none", String easingMethod = "none", Int delay = 0, Int fps = 60)
	String[] value
	String s
	Int i = 0
	Float seconds
	Float delaySeconds

	seconds = (frames As Float) / (fps As Float)
	delaySeconds = (delay As Float) / (fps As Float)

	doTransitionByTime(id, targetValue, seconds, targetAttribute, easingClass, easingMethod, delaySeconds)
EndFunction

Function doTransitionByTime(Int id, Int targetValue, Float seconds = 2.0, String targetAttribute = "alpha", String easingClass = "none", String easingMethod = "none", Float delay = 0.0)
	String[] value
	String s
	Int i = 0

	value = Utility.CreateStringArray(7, "")
	value[0] = id As String
	value[1] = targetValue As String
	value[2] = seconds As String

	If (targetAttribute == "x" || targetAttribute == "y" || targetAttribute == "xscale" || targetAttribute == "yscale" || targetAttribute == "rotation")
		value[3] = "_"+targetAttribute
	ElseIf targetAttribute == "meterpercent"
		value[1] = (targetValue / 100.0) as String
		value[3] = "percent"
	Else
		; Default to alpha
		value[3] = "_alpha"
	EndIf
	
	If (easingClass == "regular" || easingClass == "bounce" || easingClass == "back" || easingClass == "elastic" || easingClass == "strong")
		value[4] = easingClass
	Else
		; Default to no easing
		value[4] = "none"
	EndIf
	
	If (easingMethod == "in")
		value[5] = "easeIn"
	ElseIf easingMethod == "out"
		value[5] = "easeOut"
	ElseIf easingMethod == "inout"
		value[5] = "easeInOut"
	Else
		; If a valid easing method is not defined, revert to no easing
		value[4] = "none"
		value[5] = ""
	EndIf
	
	value[6] = delay As String

	s = _serializeArray(value)

	UI.InvokeString(HUD_MENU, WidgetRoot + ".doTransition", s)
EndFunction

Function setAllVisible(Bool visible = True)
	UI.InvokeBool(HUD_MENU, WidgetRoot + ".setAllVisible", visible)
EndFunction

String Function _serializeArray(String[] a)
	Int i;
	String s = "";
	
	; Avoid demarc after last value
	While (i < (a.Length - 1))
		s += a[i]+PARAMETER_DEMARC
		i += 1
	EndWhile
	
	s += a[a.Length - 1]
	
	Return (s)
EndFunction

Function logWidgetData(Int id)
	String[] value
	String s

	value = Utility.CreateStringArray(1, "")
	value[0] = id As String
	s = _serializeArray(value)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".loadWidgetData", s)
	
	Libs.Log("======logWidgetData Start=======")

	Debug.Trace("Calculated Name: "+UI.GetString(HUD_MENU, WidgetRoot + ".widget_namecalc"))
	Debug.Trace("Object Name: "+UI.GetString(HUD_MENU, WidgetRoot + ".widget_name"))
	Debug.Trace("X: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_x"))
	Debug.Trace("Y: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_y"))
	Debug.Trace("Height: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_height"))
	Debug.Trace("Width: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_width"))
	Debug.Trace("Xscale: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_xscale"))
	Debug.Trace("Yscale: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_yscale"))
	Debug.Trace("Rotation: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_rotation"))
	Debug.Trace("Alpha: "+UI.GetInt(HUD_MENU, WidgetRoot + ".widget_alpha"))
	Debug.Trace("Visible: "+UI.GetBool(HUD_MENU, WidgetRoot + ".widget_visible"))

	Libs.Log("=======logWidgetData End========")

EndFunction

Function triggerReset()
	Libs.Log("iWantDD Widgets: ***LIBRARY RESET***")
	UI.Invoke(HUD_MENU, WidgetRoot + "._reset")
	RegisterForModEvent("iWantWidgetsDDReset", "OniWantWidgetsDDReset")
	SendModEvent("iWantWidgetsDDReset")
EndFunction

Event OniWantWidgetsDDReset(String eventName, String strArg, Float numArg, Form sender)
	Libs.Log("iWantDD Widgets: iWant Widgets Reset Event Fired")
EndEvent

Function setSkyrimTemperature(Int level)
	;0 = Neutral
	;1 = Fire
	;2 = Warm
	;3 = Cold
	;4 = Freezing

	UI.InvokeInt("HUD Menu", "_root.HUDMovieBaseInstance.SetCompassTemperature", level)
	UI.Invoke   ("HUD Menu", "_root.HUDMovieBaseInstance.TemperatureMeterAnim")
EndFunction

Function setSkyrimHealthMeterPercent(Int percent)
	UI.InvokeInt("HUD Menu", "_root.HUDMovieBaseInstance.SetHealthMeterPercent", percent)
EndFunction

Function setSkyrimStaminaMeterPercent(Int percent)
	UI.InvokeInt("HUD Menu", "_root.HUDMovieBaseInstance.SetStaminaMeterPercent", percent)
EndFunction

Function setSkyrimMagickaMeterPercent(Int percent)
	UI.InvokeInt("HUD Menu", "_root.HUDMovieBaseInstance.SetMagickaMeterPercent", percent)
EndFunction

String Function _getSkyrimTargetBase(String element)
	String targetBase = ""
	
	If element == "health"
		targetBase = "_root.HUDMovieBaseInstance.Health."
	ElseIf element == "magicka"
		targetBase = "_root.HUDMovieBaseInstance.Magica."
	ElseIf element == "stamina"
		targetBase = "_root.HUDMovieBaseInstance.Stamina."
	ElseIf element == "enemyhealth"
		targetBase = "_root.HUDMovieBaseInstance.EnemyHealth."
	ElseIf element == "crosshair"
		targetBase = "_root.HUDMovieBaseInstance.CrosshairInstance."
	ElseIf element == "crosshairalert"
		targetBase = "_root.HUDMovieBaseInstance.CrosshairAlert."
	ElseIf element == "stealthmeter"
		targetBase = "_root.HUDMovieBaseInstance.StealthMeterInstance."
	ElseIf element == "questmarker"
		targetBase = "_root.HUDMovieBaseInstance.FloatingQuestMarker."
	ElseIf element == "compass"
		targetBase = "_root.HUDMovieBaseInstance.CompassShoutMeterHolder."
	EndIf
	
	Return(targetBase)
EndFunction

Function setSkyrimTransparency(String element, Int a = 100)
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_alpha"
	
	If targetBase != ""
		UI.SetInt(HUD_MENU, (targetBase + attribute), a)
	EndIf
EndFunction

Function setSkyrimZoom(String element, Int xscale = 100, Int yscale = 100)
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_xscale"
	
	If targetBase != ""
		UI.SetInt(HUD_MENU, (targetBase + attribute), xscale)
		attribute = "_yscale"
		UI.SetInt(HUD_MENU, (targetBase + attribute), yscale)
	EndIf
EndFunction

Function setSkyrimVisible(String element, Int visible = 1)
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_visible"
	
	If targetBase != ""
		UI.SetInt(HUD_MENU, (targetBase + attribute), visible)
	EndIf
EndFunction

Function _setSkyrimPos(String element, Int xpos = 0, Int ypos = 0)
	; This function is undocumented and included for experimentation only
	; Do not expect it to be available in all future releases
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_x"
	
	If targetBase != ""
		UI.SetInt(HUD_MENU, (targetBase + attribute), xpos)
		attribute = "_y"
		UI.SetInt(HUD_MENU, (targetBase + attribute), ypos)
	EndIf
EndFunction

Int Function _getSkyrimXPos(String element)
	; This function is undocumented and included for experimentation only
	; Do not expect it to be available in all future releases
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_x"
	
	If targetBase != ""
		Return(UI.GetInt(HUD_MENU, (targetBase + attribute)))
	EndIf
EndFunction

Int Function _getSkyrimYPos(String element)
	; This function is undocumented and included for experimentation only
	; Do not expect it to be available in all future releases
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_y"
	
	If targetBase != ""
		Return(UI.GetInt(HUD_MENU, (targetBase + attribute)))
	EndIf
EndFunction

Function _setSkyrimSize(String element, Int h, Int w)
	; This function is undocumented and included for experimentation only
	; Do not expect it to be available in all future releases
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_height"
	
	If targetBase != ""
		UI.SetInt(HUD_MENU, (targetBase + attribute), h)
		attribute = "_width"
		UI.SetInt(HUD_MENU, (targetBase + attribute), w)
	EndIf
EndFunction

Function _setSkyrimRotation(String element, Int rot = 0)
	; This function is undocumented and included for experimentation only
	; Do not expect it to be available in all future releases
	String targetBase = _getSkyrimTargetBase(element)
	String attribute = "_rotation"
	
	If targetBase != ""
		UI.SetInt(HUD_MENU, (targetBase + attribute), rot)
	EndIf
EndFunction

Event OnWidgetReset()
	; Overrides SKI_WidgetBase
	Parent.OnWidgetReset()
	
	SetDefaultMode()
	
	triggerReset()
EndEvent

String Function GetWidgetSource()
	; Overrides SKI_WidgetBase
	Return("iwantDD/iWantWidgetsDD.swf")
EndFunction

String Function GetWidgetType()
	; Overrides SKI_WidgetBase
	; Must be the same as script name
	Return "zadWidgets"
endFunction
