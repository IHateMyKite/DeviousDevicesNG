scriptname zadexpressionlibs extends Quest

import sslBaseExpression
import PapyrusUtil
import zadprebuildedexpressions

Faction         Property BlockExpressionFaction                             auto
zadlibs         Property libs                                               auto
bool            Property Ready                              = false         auto hidden

;Gag faction lists
Faction[]       Property PhonemeModifierFactions                            auto ;000801-000810
Faction[]       Property PhonemeModifierFactions_Large                      auto ;000901-000910
Faction[]       Property PhonemeModifierFactions_Ring                       auto ;000A01-000A10
Faction[]       Property PhonemeModifierFactions_Bit                        auto ;000B01-000B10
Faction[]       Property PhonemeModifierFactions_Panel                      auto ;000C01-000C10

;Default expressions
int[]           Property DefaultGagExpression_Simple                        auto
int[]           Property DefaultGagExpression_Large                         auto
int[]           Property DefaultGagExpression_Ring                          auto
int[]           Property DefaultGagExpression_Bit                           auto
int[]           Property DefaultGagExpression_Panel                         auto

;New gag keywords, they are not filled yet, as more works will be required before they can be used
Keyword         Property GagKeyword_Ring                                    auto
Keyword         Property GagKeyword_Bit                                     auto


;==============================================================================================================================
;                                           Sexlab Expression Construct Documantation
;==============================================================================================================================
;All number are floats in range 0.0-1.0
;Only exception is expression[30] where it needs whole number in range 0-16
;
;    =====================Phonems=====================
;    
;    expression[ 0] = Aah       [ 0.0 , 1.0 ]
;    expression[ 1] = BigAah    [ 0.0 , 1.0 ]
;    expression[ 2] = BMP       [ 0.0 , 1.0 ]
;    expression[ 3] = ChJSh     [ 0.0 , 1.0 ]
;    expression[ 4] = DST       [ 0.0 , 1.0 ]
;    expression[ 5] = Eee       [ 0.0 , 1.0 ]
;    expression[ 6] = Eh        [ 0.0 , 1.0 ]
;    expression[ 7] = FV        [ 0.0 , 1.0 ]
;    expression[ 8] = I         [ 0.0 , 1.0 ]
;    expression[ 9] = K         [ 0.0 , 1.0 ]
;    expression[10] = N         [ 0.0 , 1.0 ]
;    expression[11] = Oh        [ 0.0 , 1.0 ]
;    expression[12] = OohQ      [ 0.0 , 1.0 ]
;    expression[13] = R         [ 0.0 , 1.0 ]
;    expression[14] = Th        [ 0.0 , 1.0 ]
;    expression[15] = W         [ 0.0 , 1.0 ]
;    
;    =====================Modifiers=====================
;    
;    expression[16] = BlinkLeft      [ 0.0 , 1.0 ]     !Warning, using this will prevent the eye from blinking! 
;    expression[17] = BlinkRight     [ 0.0 , 1.0 ]     !Warning, using this will prevent the eye from blinking! 
;    expression[18] = BrowDownLeft   [ 0.0 , 1.0 ]
;    expression[19] = BrowDownRight  [ 0.0 , 1.0 ]
;    expression[20] = BrowInLeft     [ 0.0 , 1.0 ]
;    expression[21] = BrowInRight    [ 0.0 , 1.0 ]
;    expression[22] = BrowUpLeft     [ 0.0 , 1.0 ]
;    expression[23] = BrowUpRight    [ 0.0 , 1.0 ]
;    expression[24] = LookDown       [ 0.0 , 1.0 ]
;    expression[25] = LookLeft       [ 0.0 , 1.0 ]
;    expression[26] = LookRight      [ 0.0 , 1.0 ]
;    expression[27] = LookUp         [ 0.0 , 1.0 ]
;    expression[28] = SquintLeft     [ 0.0 , 1.0 ]
;    expression[29] = SquintRight    [ 0.0 , 1.0 ]
;    
;    =====================Expression=====================
;    
;    expression[30] =        X: Selected expression, see below [ 0 , 16 ]
;                         0: Dialogue Anger
;                         1: Dialogue Fear
;                         2: Dialogue Happy
;                         3: Dialogue Sad
;                         4: Dialogue Surprise
;                         5: Dialogue Puzzled
;                         6: Dialogue Disgusted
;                         7: Mood Neutral
;                         8: Mood Anger
;                         9: Mood Fear
;                        10: Mood Happy
;                        11: Mood Sad
;                        12: Mood Surprise
;                        13: Mood Puzzled
;                        14: Mood Disgusted
;                        15: Combat Anger
;                        16: Combat Shout - this opens mouth like phoneme, try to not use this unless you have good reason
;    expression[31] = Strength of choosen expression (expression[30]) [ 0.0 , 1.0 ]
;==============================================================================================================================
;==============================================================================================================================



;==============================================================================================================================
;==============================================================================================================================
;                                                            API                                                               
;==============================================================================================================================
;==============================================================================================================================

;    Int      Round(Float afValue)                                                                                global
;    float[]  CreateEmptyExpression()                                                                             global
;    float[]  GetCurrentExpression(Actor akActor)                                                                 global
;
;    bool     ApplyExpression(Actor akActor, sslBaseExpression akExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
;    bool     ApplyExpressionRaw(Actor akActor, float[] apExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
;    bool     ResetExpression(actor akActor, sslBaseExpression akExpression,int aiPriority = 0)
;    bool     ResetExpressionRaw(actor akActor, int aiPriority = 0)
;
;             SetExpressionPhonems(float[] apExpression,float[] apPhonems)                                        global
;             ResetExpressionPhonems(float[] apExpression)                                                        global
;             SetExpressionModifiers(float[] apExpression,float[] apModifiers)                                    global
;             SetExpressionExpression(float[] apExpression,int aiExpression_type,int aiExpression_strength)       global
;    Float[]  CreateRandomExpression()                                                                            global
;             ApplyGagEffect(actor akActor)
;             RemoveGagEffect(actor akActor)

string property DefaultGagExpFile hidden
    string function get()
        return "../DD/GagExpressions/DefaultExp.json"
    endFunction
endProperty

;round float number and returns int
Int Function Round(Float afValue) global
    return Math.Floor(afValue + 0.5)
EndFunction

;returns empty expression float array
float[] Function CreateEmptyExpression() global
    return new float[32]
EndFunction

;returns current actor expression, it is only wrapper for sexlab function GetCurrentMFG
float[] Function GetCurrentExpression(Actor akActor) global
    return GetCurrentMFG(akActor)
EndFunction

;API function for applying expression on actor
;        =Arguments=
;akActor            = actor to process
;akExpression       = sexlab expression which will be applied
;aiStrength         = strength which will be used to modify expression. Range 1-100
;abOpenMouth        = if true, will edit phonems to open mouth little
;aiPriority         = expression priority. This needs to be bigger that already applied expression, otherwise expression will not applied
;        =Return value=
;Return true in case that expression was successfully applied
bool Function ApplyExpression(Actor akActor, sslBaseExpression akExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
    if !akExpression
        libs.Log("ApplyExpressionPatched(): Expression is none.")
        return false
    EndIf
    int loc_gender = (akActor.GetBaseObject() as ActorBase).GetSex()
    float[] loc_exp = akExpression.GenderPhase(akExpression.CalcPhase(aiStrength, loc_gender), loc_gender)
    return zadNativeFunctions.ApplyExpression(akActor,loc_exp,aiStrength,abOpenMouth,aiPriority)
EndFunction

;API function for applying expression on actor
;        =Arguments=
;akActor            = actor to process
;apExpression       = raw expression construct. See documantation at the top of this script. You can also use prebuilded expressions from zadprebuildedexpressions
;aiStrength         = strength which will be used to modify expression. Range 1-100
;abOpenMouth        = if true, will edit phonems to open mouth little
;aiPriority         = expression priority. This needs to be bigger that already applied expression, otherwise expression will not applied
;        =Return value=
;Return true in case that expression was successfully applied
bool Function ApplyExpressionRaw(Actor akActor, float[] apExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
    return zadNativeFunctions.ApplyExpression(akActor,apExpression,aiStrength,abOpenMouth,aiPriority)
EndFunction

;API function for reseting expression on actor
;        =Arguments=
;akActor           = actor to process
;akExpression      = UNUSED. Pass in none or call ResetExpressionRaw()
;aiPriority        = expression priority. This needs to be bigger that already applied expression, otherwise expression will not removed
;        =Return value=
;Return true in case that expression was successfully removed
bool Function ResetExpression(actor akActor, sslBaseExpression akExpression,int aiPriority = 0)
    return zadNativeFunctions.ResetExpression(akActor,aiPriority)
EndFunction

;API function for reseting expression on actor
;        =Arguments=
;akActor           = actor to process
;aiPriority        = expression priority. This needs to be bigger that already applied expression, otherwise expression will not removed
;        =Return value=
;Return true in case that expression was successfully removed
bool Function ResetExpressionRaw(actor akActor, int aiPriority = 0)
    return zadNativeFunctions.ResetExpression(akActor,aiPriority)
EndFunction

;edits passed apExpression phonems with apPhonems
Function SetExpressionPhonems(float[] apExpression,float[] apPhonems) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    if apPhonems.length != 16
        return ;phonems can only have length 16!
    endif
    int loc_i = 0
    while loc_i < 16
        apExpression[loc_i] = ClampFloat(apPhonems[loc_i],0.0,1.0)
        loc_i += 1
    endWhile
EndFunction

;resets phonems from passed apExpression
Function ResetExpressionPhonems(float[] apExpression) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    int loc_i = 0
    while loc_i < 16
        apExpression[loc_i] = 0.0
        loc_i += 1
    endWhile
EndFunction

;edits passed apExpression modifiers with apModifiers
Function SetExpressionModifiers(float[] apExpression,float[] apModifiers) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    if apModifiers.length != 14
        return ;modifiers can only have length 14!
    endif
    int loc_i = 16
    int loc_x = 0
    while loc_i < 30
        apExpression[loc_i] = ClampFloat(apModifiers[loc_x],0.0,1.0)
        loc_i += 1
        loc_x += 1
    endWhile
EndFunction

;edits passed apExpression expression with aiExpression_type and aiExpression_strength
Function SetExpressionExpression(float[] apExpression,int aiExpression_type,int aiExpression_strength) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    apExpression[30] = ClampInt(aiExpression_type,0,16)
    apExpression[31] = ClampFloat(aiExpression_strength,0.0,1.0)
EndFunction

;returns randomly created expression
;sometimes look stupid, other times look good. Depends on luck :)
Float[] Function CreateRandomExpression() global
    float[] loc_expression      = CreateEmptyExpression()
    int     loc_i               = 0

    while loc_i < loc_expression.length - 2
        loc_expression[loc_i] = Utility.randomFloat(0.0,0.3)*Utility.randomInt(0,1)
        loc_i += 1
    endwhile

    loc_expression[loc_expression.length - 2] = Utility.randomInt(0,15) ;don't choose Combat shout, it looks stoopid
    loc_expression[loc_expression.length - 1] = Utility.randomFloat(0.0,1.0)

    return loc_expression
EndFunction

;check current gag state and update phonems 
Function ApplyGagEffect(actor akActor)
    if akActor.Is3DLoaded() || akActor == libs.PlayerRef
        ;Check custom gag expressions first before mutex is applied
        If akActor.WornHasKeyword(libs.zad_GagCustomExpression)
            libs.SendGagEffectEvent(akActor, false)
            return
        endif
        zadNativeFunctions.UpdateGagExpression(akActor)
    endif
EndFunction

;check current gag state and remove phonems
Function RemoveGagEffect(actor akActor)
    If akActor.WornHasKeyword(libs.zad_GagCustomExpression)
        libs.SendGagEffectEvent(akActor, false)
        Return
    EndIf
    zadNativeFunctions.ResetGagExpression(akActor)
EndFunction

;==============================================================================================================================
;==============================================================================================================================
;                                               INTERNAL FUNCTIONS, DO NOT USE
;==============================================================================================================================
;==============================================================================================================================

Event OnInit()
    Ready = true
EndEvent

Function Maintenance()
    GagKeyword_Ring = Keyword.GetKeyword("zad_DeviousGagRing")
    GagKeyword_Bit = Keyword.GetKeyword("zad_DeviousGagBit")

    zadNativeFunctions.RegisterGagType(libs.zad_GagNoOpenMouth,new Faction[1],new Int[16])
    zadNativeFunctions.RegisterGagType(libs.zad_DeviousGagLarge,PhonemeModifierFactions_Large,DefaultGagExpression_Large)
    zadNativeFunctions.RegisterGagType(libs.zad_DeviousGagPanel,PhonemeModifierFactions_Panel,DefaultGagExpression_Panel)
    zadNativeFunctions.RegisterGagType(GagKeyword_Ring,PhonemeModifierFactions_Ring,DefaultGagExpression_Ring)
    zadNativeFunctions.RegisterGagType(GagKeyword_Bit,PhonemeModifierFactions_Bit,DefaultGagExpression_Bit)
    zadNativeFunctions.RegisterDefaultGagType(PhonemeModifierFactions,DefaultGagExpression_Simple)
EndFunction

Int[] Function LoadGagExpFromJSON(String asFilePath,string asFlag = "DefaultGagExpression")
    if JsonUtil.IntListCount(asFilePath, asFlag) == 16
        return JsonUtil.IntListToArray(asFilePath, asFlag)
    endIf
    return new Int[16]
EndFunction