Scriptname zadcAnims extends sslAnimationFactory

SexlabFramework Property Sexlab Auto
zadLibs Property libs Auto
zadclibs Property clib Auto

function LoadAnimations()
	libs.log("Devious Devices Contraptions is now creating sex animations.")
	SexLab = SexLabUtil.GetAPI()
	If SexLab == None
		libs.Error("Animation registration failed: SexLab is none.")
	EndIf
	if clib == None
		libs.Error("Animation registration failed: Quest is none.")
	EndIf

	;-------------------
	; PILLORY ANIMATIONS
	;-------------------
	SexLab.GetSetAnimationObject("DDC_B_CPill_Behind1", "CreateDDC_B_CPill_Behind1", clib)
	SexLab.GetSetAnimationObject("DDC_Billyy_PilloryFuck1", "CreateDDC_Billyy_PilloryFuck1", clib)
	SexLab.GetSetAnimationObject("DDC_Babo_ZazPillory01", "CreateDDC_Babo_ZazPillory01", clib)
	SexLab.GetSetAnimationObject("DDC_NibblesPillory", "CreateDDC_NibblesPillory", clib)
	SexLab.GetSetAnimationObject("DDC_Leito_Pillory_Doggy", "CreateDDC_Leito_Pillory_Doggy", clib)
	SexLab.GetSetAnimationObject("DDC_PsychePillory", "CreateDDC_PsychePillory", clib)

	;-----------------
	; XCROSS ANIMATIONS
	;-----------------
	SexLab.GetSetAnimationObject("DDC_B_CXCross_Face", "CreateDDC_B_CXCross_Face", clib)
	SexLab.GetSetAnimationObject("DDC_Billyy_XCrossFuck", "CreateDDC_Billyy_XCrossFuck", clib)
	SexLab.GetSetAnimationObject("DDC_Billyy_XCrossFuck2", "CreateDDC_Billyy_XCrossFuck2", clib)
	SexLab.GetSetAnimationObject("DDC_Billyy_XCrossReverseAnal", "CreateDDC_Billyy_XCrossReverseAnal", clib)
	SexLab.GetSetAnimationObject("DDC_PsycheRestrictRape3", "CreateDDC_PsycheRestrictRape3", clib)

	;------------------------
	; GALLOWS POLE ANIMATIONS
	;------------------------
	SexLab.GetSetAnimationObject("DDC_B_GallPDown_HangBJ", "CreateDDC_B_GallPDown_HangBJ", clib)
	SexLab.GetSetAnimationObject("DDC_B_GallPDown_HangFF", "CreateDDC_B_GallPDown_HangFF", clib)
	SexLab.GetSetAnimationObject("DDC_B_GallPDown_HangFacial", "CreateDDC_B_GallPDown_HangFacial", clib)
	SexLab.GetSetAnimationObject("DDC_B_GallPHorse_ForGrind", "CreateDDC_B_GallPHorse_ForGrind", clib)
	SexLab.GetSetAnimationObject("DDC_B_GallPOH_Holding", "CreateDDC_B_GallPOH_Holding", clib)
	SexLab.GetSetAnimationObject("DDC_B_GallPStrap_BentOver", "CreateDDC_B_GallPStrap_BentOver", clib)

	;------------------------
	; TILTED WHEEL ANIMATIONS
	;------------------------
	SexLab.GetSetAnimationObject("DDC_B_TiltWMiss", "CreateDDC_B_TiltWMiss", clib)
	SexLab.GetSetAnimationObject("DDC_B_TiltWSide", "CreateDDC_B_TiltWSide", clib)
	SexLab.GetSetAnimationObject("DDC_B_TiltWFist", "CreateDDC_B_TiltWFist", clib)
	SexLab.GetSetAnimationObject("DDC_B_TiltWFF", "CreateDDC_B_TiltWFF", clib)
	SexLab.GetSetAnimationObject("DDC_B_TiltWFF2", "CreateDDC_B_TiltWFF2", clib)

	;-----------------------------
	; VERTICAL STOCKADE ANIMATIONS
	;-----------------------------
	SexLab.GetSetAnimationObject("DDC_Billyy_StockadeFuckMachine", "CreateDDC_Billyy_StockadeFuckMachine", clib)

	;------------------------
	; WOODEN HORSE ANIMATIONS
	;------------------------
	SexLab.GetSetAnimationObject("DDC_PsycheWoodenHorse", "CreateDDC_PsycheWoodenHorse", clib)

	;------------------------
	; BONDAGE POST ANIMATIONS
	;------------------------
	SexLab.GetSetAnimationObject("DDC_NibblesBondagePost", "CreateDDC_NibblesBondagePost", clib)
	SexLab.GetSetAnimationObject("DDC_NibblesBondagePostTOY", "CreateDDC_NibblesBondagePostTOY", clib)
	SexLab.GetSetAnimationObject("DDC_PsycheRestrictRape8", "CreateDDC_PsycheRestrictRape8", clib)

	;------------------------
	; TORTURE POLE ANIMATIONS
	;------------------------
	SexLab.GetSetAnimationObject("DDC_PsycheFingerFucking", "CreateDDC_PsycheFingerFucking", clib)
	SexLab.GetSetAnimationObject("DDC_PsycheRestrictRape", "CreateDDC_PsycheRestrictRape", clib)

EndFunction


;animations by Billyy

Function CreateDDC_B_CPill_Behind1(int id)
	String asAnim1 = "DDC_B_CPill_Behind1"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_CPill_Behind1")
	if Anim != none && Anim.Name != "DDC_B_CPill_Behind1"
		Anim.Name = "DDC_B_CPill_Behind1"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = -1)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", sos = 1)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", sos = 1)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 2)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 2)

		Anim.AddTag("Pillory")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_Billyy_PilloryFuck1(int id)
	String asAnim1 = "DDC_Billyy_PilloryFuck1"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_Billyy_PilloryFuck1")
	if Anim != none && Anim.Name != "DDC_Billyy_PilloryFuck1"
		Anim.Name = "DDC_Billyy_PilloryFuck1"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", forward = 45.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", forward = 45.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", forward = 45.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", forward = 45.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", forward = 45.0)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", forward = 45.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", forward = 45.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", forward = 45.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", forward = 45.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", forward = 45.0)

		Anim.AddTag("Pillory")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_Billyy_XCrossFuck(int id)
	String asAnim1 = "DDC_Billyy_XCrossFuck"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_Billyy_XCrossFuck")
	if Anim != none && Anim.Name != "DDC_Billyy_XCrossFuck"
		Anim.Name = "DDC_Billyy_XCrossFuck"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", silent = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", forward = 4.5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", forward = 4.5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", forward = 4.5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", forward = 4.5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", forward = 4.5)

		Anim.AddTag("Xcross")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_Billyy_XCrossFuck2(int id)
	String asAnim1 = "DDC_Billyy_XCrossFuck2"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_Billyy_XCrossFuck2")
	if Anim != none && Anim.Name != "DDC_Billyy_XCrossFuck2"
		Anim.Name = "DDC_Billyy_XCrossFuck2"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", forward = 5.0, silent = True)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", forward = 5.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", forward = 5.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", forward = 5.0, sos = 5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", forward = 5.0)

		Anim.AddTag("Xcross")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_Billyy_XCrossReverseAnal(int id)
	String asAnim1 = "DDC_Billyy_XCrossReverseAnal"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_Billyy_XCrossReverseAnal")
	if Anim != none && Anim.Name != "DDC_Billyy_XCrossReverseAnal"
		Anim.Name = "DDC_Billyy_XCrossReverseAnal"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", rotate = 180.0)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", forward = 8.5, up = -2.5, sos = 9)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", forward = 8.5, up = -2.5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", forward = 8.5, up = -2.5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", forward = 8.5, up = -2.5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", forward = 8.5, up = -2.5)

		Anim.AddTag("Xcross")
		Anim.AddTag("Anal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_CXCross_Face(int id)
	String asAnim1 = "DDC_B_CXCross_Face"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_CXCross_Face")
	if Anim != none && Anim.Name != "DDC_B_CXCross_Face"
		Anim.Name = "DDC_B_CXCross_Face"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", silent = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = 7)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", sos = 8)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", sos = 8)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 4)

		Anim.AddTag("Xcross")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_GallPDown_HangBJ(int id)
	String asAnim1 = "DDC_B_GallPDown_HangBJ"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_GallPDown_HangBJ")
	if Anim != none && Anim.Name != "DDC_B_GallPDown_HangBJ"
		Anim.Name = "DDC_B_GallPDown_HangBJ"
		Anim.SoundFX = Sucking

		Int B = Anim.AddPosition(Female, AddCum = Oral)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", openmouth = True)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = -5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("GallowsUpsidedown")
		Anim.AddTag("Oral")
		Anim.AddTag("Blowjob")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_GallPDown_HangFF(int id)
	String asAnim1 = "DDC_B_GallPDown_HangFF"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_GallPDown_HangFF")
	if Anim != none && Anim.Name != "DDC_B_GallPDown_HangFF"
		Anim.Name = "DDC_B_GallPDown_HangFF"
		Anim.SoundFX = Sucking

		Int B = Anim.AddPosition(Female, AddCum = Oral)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", openmouth = True)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = -3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", sos = -3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", sos = -2)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 5) 
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 7) 

		Anim.AddTag("GallowsUpsidedown")
		Anim.AddTag("Oral")
		Anim.AddTag("Blowjob")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_GallPDown_HangFacial(int id)
	String asAnim1 = "DDC_B_GallPDown_HangFacial"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_GallPDown_HangFacial")
	if Anim != none && Anim.Name != "DDC_B_GallPDown_HangFacial"
		Anim.Name = "DDC_B_GallPDown_HangFacial"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Oral)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", sos = 8)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", openmouth = True)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("GallowsUpsidedown")
		Anim.AddTag("Facial")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_TiltWMiss(int id)
	String asAnim1 = "DDC_B_TiltWMiss"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_TiltWMiss")
	if Anim != none && Anim.Name != "DDC_B_TiltWMiss"
		Anim.Name = "DDC_B_TiltWMiss"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 2)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 2)

		Anim.AddTag("TiltedWHeel")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_TiltWSide(int id)
	String asAnim1 = "DDC_B_TiltWSide"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_TiltWSide")
	if Anim != none && Anim.Name != "DDC_B_TiltWSide"
		Anim.Name = "DDC_B_TiltWSide"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = -7)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 4)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 1)

		Anim.AddTag("TiltedWHeel")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_TiltWFist(int id)
	String asAnim1 = "DDC_B_TiltWFist"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_TiltWFist")
	if Anim != none && Anim.Name != "DDC_B_TiltWFist"
		Anim.Name = "DDC_B_TiltWFist"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", strapOn = False, sos = -5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", strapOn = False, sos = 2)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", strapOn = False, sos = 6)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", strapOn = False, sos = 5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", strapOn = False, sos = 1)

		Anim.AddTag("TiltedWHeel")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Fisting")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_TiltWFF(int id)
	String asAnim1 = "DDC_B_TiltWFF"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_TiltWFF")
	if Anim != none && Anim.Name != "DDC_B_TiltWFF"
		Anim.Name = "DDC_B_TiltWFF"
		Anim.SoundFX = Sucking

		Int B = Anim.AddPosition(Female, AddCum = Oral)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", silent = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", openmouth = True)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = -5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("TiltedWHeel")
		Anim.AddTag("Oral")
		Anim.AddTag("Blowjob")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_TiltWFF2(int id)
	String asAnim1 = "DDC_B_TiltWFF2"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_TiltWFF2")
	if Anim != none && Anim.Name != "DDC_B_TiltWFF2"
		Anim.Name = "DDC_B_TiltWFF2"
		Anim.SoundFX = Sucking

		Int B = Anim.AddPosition(Female, AddCum = Oral)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", openmouth = True)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", openmouth = True)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 1)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 1)

		Anim.AddTag("TiltedWHeel")
		Anim.AddTag("Oral")
		Anim.AddTag("Blowjob")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_Billyy_StockadeFuckMachine(int id)
	String asAnim1 = "DDC_Billyy_StockadeFuckMachine"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_Billyy_StockadeFuckMachine")
	if Anim != none && Anim.Name != "DDC_Billyy_StockadeFuckMachine"
		Anim.Name = "DDC_Billyy_StockadeFuckMachine"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = -7)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", sos = 0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", sos = 0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 0)
		
		Anim.AddTag("VerticalStockade")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Anal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_GallPHorse_ForGrind(int id)
	String asAnim1 = "DDC_B_GallPHorse_ForGrind"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_GallPHorse_ForGrind")
	if Anim != none && Anim.Name != "DDC_B_GallPHorse_ForGrind"
		Anim.Name = "DDC_B_GallPHorse_ForGrind"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", strapOn = False, sos = 4)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", strapOn = False, sos = 5)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", strapOn = False, sos = 6)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", strapOn = False, sos = 7)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", strapOn = False, sos = 8)

		Anim.AddTag("GallowsWoodenHorse")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Grinding")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_GallPOH_Holding(int id)
	String asAnim1 = "DDC_B_GallPOH_Holding"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_GallPOH_Holding")
	if Anim != none && Anim.Name != "DDC_B_GallPOH_Holding"
		Anim.Name = "DDC_B_GallPOH_Holding"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = 2)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", sos = 2)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", sos = 3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", sos = 2)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", sos = 5)

		Anim.AddTag("GallowsOverhead")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_B_GallPStrap_BentOver(int id)
	String asAnim1 = "DDC_B_GallPStrap_BentOver"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_B_GallPStrap_BentOver")
	if Anim != none && Anim.Name != "DDC_B_GallPStrap_BentOver"
		Anim.Name = "DDC_B_GallPStrap_BentOver"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", sos = 9)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("GallowsStrappado")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction


;animations by BakaFactory

Function CreateDDC_Babo_ZazPillory01(int id)
	String asAnim1 = "DDC_Babo_ZazPillory01"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_Babo_ZazPillory01")
	if Anim != none && Anim.Name != "DDC_Babo_ZazPillory01"
		Anim.Name = "DDC_Babo_ZazPillory01"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", forward = -45.0, sos = 3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", forward = -45.0, sos = 3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", forward = -45.0, sos = 3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", forward = -45.0, sos = 3)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", forward = -45.0, sos = 3)

		Anim.AddTag("Pillory")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction


;animations by Nibbles

Function CreateDDC_NibblesPillory(int id)
	String asAnim1 = "DDC_NibblesPillory"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_NibblesPillory")
	if Anim != none && Anim.Name != "DDC_NibblesPillory"
		Anim.Name = "DDC_NibblesPillory"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("Pillory")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_NibblesBondagePost(int id)
	String asAnim1 = "DDC_NibblesBondagePost"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_NibblesBondagePost")
	if Anim != none && Anim.Name != "DDC_NibblesBondagePost"
		Anim.Name = "DDC_NibblesBondagePost"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("RestraintPost02")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_NibblesBondagePostTOY(int id)
	String asAnim1 = "DDC_NibblesBondagePostTOY"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_NibblesBondagePostTOY")
	if Anim != none && Anim.Name != "DDC_NibblesBondagePostTOY"
		Anim.Name = "DDC_NibblesBondagePostTOY"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", strapon = False)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", strapon = False)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", strapon = False)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", strapon = False)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", strapon = False)

		Anim.AddTag("RestraintPost02")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction


;animations by Leito

Function CreateDDC_Leito_Pillory_Doggy(int id)
	String asAnim1 = "DDC_Leito_Pillory_Doggy"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_Leito_Pillory_Doggy")
	if Anim != none && Anim.Name != "DDC_Leito_Pillory_Doggy"
		Anim.Name = "DDC_Leito_Pillory_Doggy"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("Pillory")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction


;animations by Psyche

Function CreateDDC_PsycheFingerFucking(int id)
	String asAnim1 = "DDC_PsycheFingerFucking"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_PsycheFingerFucking")
	if Anim != none && Anim.Name != "DDC_PsycheFingerFucking"
		Anim.Name = "DDC_PsycheFingerFucking"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", rotate = 180.0)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", rotate = 180.0)

		Anim.AddTag("TorturePole05")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Fingering")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_PsychePillory(int id)
	String asAnim1 = "DDC_PsychePillory"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_PsychePillory")
	if Anim != none && Anim.Name != "DDC_PsychePillory"
		Anim.Name = "DDC_PsychePillory"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("Pillory")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Fisting")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_PsycheRestrictRape(int id)
	String asAnim1 = "DDC_PsycheRestrictRape"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_PsycheRestrictRape")
	if Anim != none && Anim.Name != "DDC_PsycheRestrictRape"
		Anim.Name = "DDC_PsycheRestrictRape"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4", rotate = 180.0)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5", rotate = 180.0)

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", rotate = 180.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", rotate = 180.0)

		Anim.AddTag("TorturePole05")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_PsycheRestrictRape3(int id)
	String asAnim1 = "DDC_PsycheRestrictRape3"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_PsycheRestrictRape3")
	if Anim != none && Anim.Name != "DDC_PsycheRestrictRape3"
		Anim.Name = "DDC_PsycheRestrictRape3"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", forward = 7.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", forward = 7.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", forward = 7.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", forward = 7.0)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5", forward = 7.0)

		Anim.AddTag("Xcross")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Fisting")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_PsycheRestrictRape8(int id)
	String asAnim1 = "DDC_PsycheRestrictRape8"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_PsycheRestrictRape8")
	if Anim != none && Anim.Name != "DDC_PsycheRestrictRape8"
		Anim.Name = "DDC_PsycheRestrictRape8"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female, AddCum = Vaginal)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S5")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(A, asAnim1 + "_A2_S5")

		Anim.AddTag("RestraintPost03")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction

Function CreateDDC_PsycheWoodenHorse(int id)
	String asAnim1 = "DDC_PsycheWoodenHorse"

	sslBaseAnimation Anim = SexLab.GetAnimationObject("DDC_PsycheWoodenHorse")
	if Anim != none && Anim.Name != "DDC_PsycheWoodenHorse"
		Anim.Name = "DDC_PsycheWoodenHorse"
		Anim.SoundFX = Squishing

		Int B = Anim.AddPosition(Female)
		Anim.AddPositionStage(B, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(B, asAnim1 + "_A1_S4")

		Int A = Anim.AddPosition(Male)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S1", strapOn = False)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S2", strapOn = False)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S3", strapOn = False)
		Anim.AddPositionStage(A, asAnim1 + "_A2_S4", strapOn = False)

		Anim.AddTag("WoodenHorse")
		Anim.AddTag("Vaginal")
		Anim.AddTag("Grinding")
		Anim.AddTag("Aggressive")
		Anim.AddTag("Sex")

		Anim.AddTag("DomSub")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")
	
		Anim.Save(-1)
	EndIf
EndFunction