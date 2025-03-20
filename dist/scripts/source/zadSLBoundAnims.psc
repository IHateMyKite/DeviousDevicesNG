Scriptname zadSLBoundAnims extends sslAnimationFactory

SexlabFramework Property Sexlab Auto
zadLibs Property libs Auto
zadBQ00 Property filterQuest Auto

;This sets up bound animations for private use.
;They will not populate the general sexlab list and must be called specifically.

;Define animation prefixes for each actor (must correspond to names in FNIS), add more if necessary

function LoadAnimations()
	libs.log("Devious Devices is now creating bound animations.")
	SexLab = SexLabUtil.GetAPI()
	If SexLab == None
		libs.Error("Animation registration failed: SexLab is none.")
	EndIf
	if filterQuest == None
		libs.Error("Animation registration failed: FilterQuest is none.")
	EndIf
	;-------------------
	;PET SUIT ANIMATIONS - the only restraint category that still needs dedicated animations registered
	;-------------------
	;blowjob
	SexLab.GetSetAnimationObject("DD_B_PS_DT", "CreateDD_B_PS_DT", filterQuest)
	;vaginal
	SexLab.GetSetAnimationObject("DD_B_PS_Doggy", "CreateDD_B_PS_Doggy", filterQuest)
	SexLab.GetSetAnimationObject("DD_B_PS_Miss", "CreateDD_B_PS_Miss", filterQuest)
	;anal
	SexLab.GetSetAnimationObject("DD_B_PS_DoggyA", "CreateDD_B_PS_DoggyA", filterQuest)
EndFunction

;========================
;PET SUIT
;========================

;animations by Billyy

Function CreateDD_B_PS_Doggy(int id)
	String asAnim1 = "DD_B_PS_Doggy"

	libs.Log("Creating DD_B_PS_Doggy")
	sslBaseAnimation Anim = SexLab.GetAnimationObject("DD_B_PS_Doggy")
	if Anim != none && Anim.Name != "DD_B_PS_Doggy"
		Anim.Name = "DD_B_PS_Doggy"
		Anim.SoundFX = Squishing

		Int a1 = Anim.AddPosition(Female, addCum = Vaginal)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S5")
		
		Int a2 = Anim.AddPosition(Male)
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S5")
		
		Anim.AddTag("Laying")
		Anim.AddTag("Vaginal")		
		Anim.AddTag("Aggressive")

		Anim.AddTag("Sex")
		Anim.AddTag("MF")

		Anim.AddTag("DomSub")
		Anim.AddTag("PetSuit")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
		filterQuest.PetsuitVaginal = PapyrusUtil.PushString(filterQuest.PetsuitVaginal, Anim.Name)
	EndIf
EndFunction

Function CreateDD_B_PS_DoggyA(int id)
	String asAnim1 = "DD_B_PS_DoggyA"

	libs.Log("Creating DD_B_PS_DoggyA")
	sslBaseAnimation Anim = SexLab.GetAnimationObject("DD_B_PS_DoggyA")
	if Anim != none && Anim.Name != "DD_B_PS_DoggyA"
		Anim.Name = "DD_B_PS_DoggyA"
		Anim.SoundFX = Squishing

		Int a1 = Anim.AddPosition(Female, addCum = Anal)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S5")
		
		Int a2 = Anim.AddPosition(Male)
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S5")
		
		Anim.AddTag("Laying")
		Anim.AddTag("Anal")	
		Anim.AddTag("Aggressive")

		Anim.AddTag("Sex")
		Anim.AddTag("MF")

		Anim.AddTag("DomSub")
		Anim.AddTag("PetSuit")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
		filterQuest.PetSuitAnal = PapyrusUtil.PushString(filterQuest.PetSuitAnal, Anim.Name)
	EndIf
EndFunction

Function CreateDD_B_PS_DT(int id)
	String asAnim1 = "DD_B_PS_DT"

	libs.Log("Creating DD_B_PS_DT")
	sslBaseAnimation Anim = SexLab.GetAnimationObject("DD_B_PS_DT")
	if Anim != none && Anim.Name != "DD_B_PS_DT"
		Anim.Name = "DD_B_PS_DT"
		Anim.SoundFX = Sucking

		Int a1 = Anim.AddPosition(Female, addCum = Oral)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S1", silent = True, openMouth = True)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S2", silent = True, openMouth = True)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S3", silent = True, openMouth = True)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S4", silent = True, openMouth = True)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S5", silent = True, openMouth = True)
		
		Int a2 = Anim.AddPosition(Male)
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S5")
		
		Anim.SetStageSoundFX(1, None)
		
		Anim.AddTag("Laying")
		Anim.AddTag("Blowjob")	
		Anim.AddTag("Oral")
		Anim.AddTag("Aggressive")

		Anim.AddTag("Sex")
		Anim.AddTag("MF")

		Anim.AddTag("DomSub")
		Anim.AddTag("PetSuit")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
		filterQuest.PetSuitBlowjob = PapyrusUtil.PushString(filterQuest.PetSuitBlowjob, Anim.Name)
	EndIf
EndFunction

Function CreateDD_B_PS_Miss(int id)
	String asAnim1 = "DD_B_PS_Miss"

	libs.Log("Creating DD_B_PS_Miss")
	sslBaseAnimation Anim = SexLab.GetAnimationObject("DD_B_PS_Miss")
	if Anim != none && Anim.Name != "DD_B_PS_Miss"
		Anim.Name = "DD_B_PS_Miss"
		Anim.SoundFX = Squishing

		Int a1 = Anim.AddPosition(Female, addCum = Vaginal)
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S1")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S2")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S3")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S4")
		Anim.AddPositionStage(a1, asAnim1 + "_A1_S5")
		
		Int a2 = Anim.AddPosition(Male)
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S1")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S2")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S3")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S4")
		Anim.AddPositionStage(a2, asAnim1 + "_A2_S5")
		
		Anim.AddTag("Laying")
		Anim.AddTag("Vaginal")		
		Anim.AddTag("Aggressive")

		Anim.AddTag("Sex")
		Anim.AddTag("MF")

		Anim.AddTag("DomSub")
		Anim.AddTag("PetSuit")
		Anim.AddTag("DeviousDevice")
		Anim.AddTag("NoSwap")

		Anim.Save(-1)
		filterQuest.PetSuitVaginal = PapyrusUtil.PushString(filterQuest.PetSuitVaginal, Anim.Name)
	EndIf
EndFunction