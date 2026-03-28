ScriptName zadGagNoFoodEffect extends ActiveMagicEffect

; Libraries
zadLibs Property Libs Auto

ObjectReference Property Refrigerator Auto
Keyword Property FoodKeyword Auto
Keyword Property RawFoodKeyword Auto
Keyword Property PotionKeyword Auto
Keyword Property zad_PermitOral Auto

; No longer needed as eating food is prevented natively
;compatibility with existing saves
Event OnPlayerLoadGame()
    if Refrigerator.GetNumItems() > 0
        Refrigerator.RemoveAllItems(libs.PlayerRef, true, false)
    endIf
EndEvent