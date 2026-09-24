#include "InventoryFilter.h"

#include "LibFunctions.h"
#include "Settings.h"
#include "UI.h"

SINGLETONBODY(DeviousDevices::InventoryFilter)

RE::TESObjectARMO* DeviousDevices::InventoryFilter::GetWornWithDeviousKeyword(RE::Actor* a_actor, RE::BGSKeyword* kwd) {
    const int loc_slot = GetMaskForKeyword(a_actor, kwd);

    if (loc_slot < 0) return nullptr;

    const auto loc_armor = LibFunctions::GetSingleton()->GetWornArmor(a_actor, loc_slot);
    // const auto loc_armor = a_actor->GetWornArmor(static_cast<RE::BIPED_MODEL::BipedObjectSlot>(loc_slot));

    if (loc_armor != nullptr && loc_armor->HasKeyword(kwd)) {
        return loc_armor;
    }

    return nullptr;
}

bool DeviousDevices::InventoryFilter::TakeFilter(RE::Actor* a_actor, RE::TESBoundObject* obj) {
    if (!Settings::GetSingleton().GetSetting<bool>("mittensDropToggle") || obj == nullptr || obj->GetName() == "" ||
        a_actor->GetFormID() != 20 || UI::GetMenu<RE::BarterMenu>().get())
        return false;

    if (!obj->Is(RE::FormType::Weapon) && !obj->Is(RE::FormType::KeyMaster) &&
        (!obj->Is(RE::FormType::Armor) || LibFunctions::GetSingleton()->IsDevice(obj->As<RE::TESObjectARMO>())))
        return false;

    if (!GetWornWithDeviousKeyword(a_actor, _deviousBondageMittensKwd)) return false;

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> distr(0.0f, 100.0f);

    bool loc_rollFailure = distr(gen) < 80.0f;

    if (loc_rollFailure) {
        RE::SendHUDMessage::ShowHUDMessage("Locked in bondage mittens, you cannot pick up the item.");
    } else {
        RE::SendHUDMessage::ShowHUDMessage("Despite wearing bondage mittens, you manage to pick up the item.");
    }

    return loc_rollFailure;
}

bool DeviousDevices::InventoryFilter::EquipFilter(RE::Actor* a_actor, RE::TESBoundObject* a_item) {
    if ((a_actor == nullptr) || (a_item == nullptr)) return true;

    //DEBUG("EquipFilter({},{})",a_actor->GetName(),a_item->GetName())

    // item have no name -> most likely used internaly by other mod, and not equipped by player -> never filter it out
    // or is SMP object used by 3BA
    if (!CheckWhitelist(a_item)) return false;

    // == Food check
    bool loc_needgagcheck = false;

    if (a_item->Is(RE::FormType::Ingredient))  // filter all ingredients
    {
        loc_needgagcheck = true;
    } else if (a_item->Is(RE::FormType::AlchemyItem))  // filter all food and potions (which are not poisons)
    {
        RE::AlchemyItem* loc_alchitem = a_item->As<RE::AlchemyItem>();
        if (!loc_alchitem->IsPoison()) loc_needgagcheck = true;
    }

    bool loc_checkinventory = false;
    if (loc_needgagcheck) {
        if (!CheckWhitelistFood(a_item)) return false;  // check food filter
        if (ConfigManager::GetSingleton()->GetVariable<bool>("InventoryFilter.bGagFilterModeMenu", false) == 1)
            loc_checkinventory = true;

        // UI can be still not loaded even after save is loaded.
        // Because of that it is important to always check that UI singleton is initiated
        RE::GPtr<RE::InventoryMenu> loc_invMenu = nullptr;
        if (RE::UI::GetSingleton() != nullptr) {
            loc_invMenu = UI::GetMenu<RE::InventoryMenu>();
        } else
            ERROR("Cant check if inventory menu is open because UI singleton is not initiated")

        if ((!loc_checkinventory || loc_invMenu.get()) && LibFunctions::GetSingleton()->ActorHasBlockingGag(a_actor)) {
            RE::SendHUDMessage::ShowHUDMessage("You can't eat or drink while wearing this gag.");
            return true;
        }
    }

    // == Shout check
    if (a_item->Is(RE::FormType::Shout) && LibFunctions::GetSingleton()->ActorHasBlockingGag(a_actor))  // filter all Shouts
    {
        RE::GPtr<RE::MagicMenu> loc_magMenu = nullptr;
        if (RE::UI::GetSingleton() != nullptr) {
            loc_magMenu = UI::GetMenu<RE::MagicMenu>();
        } else
            ERROR("Cant check if inventory menu is open because UI singleton is not initiated")

        if (loc_magMenu.get()) {
            RE::SendHUDMessage::ShowHUDMessage("You can't equip this while wearing this gag!");
        }
        LOG("EquipFilter({},{}) - Prevented equipping shout",a_actor->GetName(),a_item->GetName())
        return true;
    }

    // Prevents from device being unequipped by other armor which is not device
    // This is often caused by Follower mods which constantly force outfits to NPCs by uneqipping the current armor (even if its set to be unequippable)
    if ((a_item->Is(RE::FormType::Armor) && !LibFunctions::GetSingleton()->IsDevice(a_item->As<RE::TESObjectARMO>())))
    {
        RE::TESObjectARMO* loc_armor = reinterpret_cast<RE::TESObjectARMO*>(a_item);
        const auto loc_mask = (int)loc_armor->GetSlotMask().underlying();
        RE::TESObjectARMO* loc_worn = LibFunctions::GetSingleton()->GetWornArmor(a_actor,loc_mask);
        if (loc_worn && LibFunctions::GetSingleton()->IsDevice(loc_worn))
        {
            DEBUG("EquipFilter({},{}) - Prevented equipping armor in slot already used by device",a_actor->GetName(),a_item->GetName())
            return true;
        }
    }

    const bool loc_heavyBondage = GetWornWithDeviousKeyword(a_actor, _deviousHeavyBondageKwd);
    const bool loc_mittens = !loc_heavyBondage && GetWornWithDeviousKeyword(a_actor, _deviousBondageMittensKwd);

    // == Weapon check
    if (a_item->Is(RE::FormType::Weapon) || a_item->Is(RE::FormType::Light)) {
        if (loc_heavyBondage || loc_mittens) {
            if (a_actor->IsPlayerRef())
            {
                const std::string loc_msg = loc_heavyBondage ? "You can't equip this with your hands tied!"
                                                             : "You can't equip this while locked in bondage mittens!";
                RE::SendHUDMessage::ShowHUDMessage(loc_msg.c_str());
            }
            LOG("EquipFilter({},{}) - Prevented equipping weapon/light",a_actor->GetName(),a_item->GetName())
            // Equipping anything should be disabled when bound. Even if menu is closed. 
            // Reason is that otherwise player can easily equip back all weapons/spells by using Favirite menu or hotkeys
            return true;
        }
    }

    // == Equip check
    if ((a_item->Is(RE::FormType::Armor) && !LibFunctions::GetSingleton()->IsDevice(a_item->As<RE::TESObjectARMO>()) && !IsStrapon(a_item))) {
        if (loc_heavyBondage || loc_mittens) {
            const std::string loc_msg = loc_heavyBondage ? "You can't equip this with your hands tied!"
                                                            : "You can't equip this while locked in bondage mittens!";
            // UI can be still not loaded even after save is loaded.
            // Because of that it is important to always check that UI singleton is initiated
            RE::GPtr<RE::InventoryMenu> loc_invMenu = nullptr;
            RE::GPtr<RE::MagicMenu> loc_magMenu = nullptr;
            if (RE::UI::GetSingleton() != nullptr) 
            {
                loc_invMenu = UI::GetMenu<RE::InventoryMenu>();
                loc_magMenu = UI::GetMenu<RE::MagicMenu>();
            } else
                ERROR("Cant check if inventory menu is open because UI singleton is not initiated")

            RE::TESObjectARMO* loc_armor =  reinterpret_cast<RE::TESObjectARMO*>(a_item);
            const bool loc_isshield = (loc_armor && loc_armor->IsShield());

            if ((loc_isshield || (loc_invMenu.get() || loc_magMenu.get())) && a_actor->IsPlayerRef()) 
            {
                RE::SendHUDMessage::ShowHUDMessage(loc_msg.c_str());
                LOG("EquipFilter({},{}) - Prevented equipping armor",a_actor->GetName(),a_item->GetName())
                return true;
            }
            
            if (loc_isshield || (ConfigManager::GetSingleton()->GetVariable<bool>("InventoryFilter.bEquipFilterModeMenu", false) == 0))
            {
                LOG("EquipFilter({},{}) - Prevented equipping armor",a_actor->GetName(),a_item->GetName())
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    // == Spell check
    if ((a_item->Is(RE::FormType::Spell))) {
        if (loc_heavyBondage || loc_mittens) {
            RE::SpellItem* loc_spell = reinterpret_cast<RE::SpellItem*>(a_item);

            bool loc_isspell = false;
            switch (loc_spell->GetSpellType())
            {
            case RE::MagicSystem::SpellType::kSpell:
               loc_isspell = true;
               break;
            default:
                loc_isspell = false;
                break;
            }

            // Only if if spell is trully spell (using hands)
            if (loc_isspell)
            {
                if (a_actor->IsPlayerRef())
                {
                    const std::string loc_msg = loc_heavyBondage ? "You can't equip this with your hands tied!"
                                                                 : "You can't equip this while locked in bondage mittens!";
                    RE::SendHUDMessage::ShowHUDMessage(loc_msg.c_str());
                }
                LOG("EquipFilter({},{}) - Prevented equipping spell",a_actor->GetName(),a_item->GetName())
                // Equipping anything should be disabled when bound. Even if menu is closed. 
                // Reason is that otherwise player can easily equipp back all weapons/spells by using Favirite menu
                return true;
            }
        }
    }


    return false;
}

bool DeviousDevices::InventoryFilter::IsStrapon(RE::TESBoundObject* obj) {
    static std::vector<RE::BGSKeyword*> loc_straponKwds = {_sexlabNoStripKwd, _jewelryKwd};
    return obj->HasKeywordInArray(loc_straponKwds, true);
}

int DeviousDevices::InventoryFilter::GetMaskForKeyword(RE::Actor* a_actor, RE::BGSKeyword* kwd) {
    if (kwd == _deviousArmCuffsKwd)
        return GetMaskForSlot(59);
    else if (kwd == _deviousGagKwd)
        return GetMaskForSlot(44);
    else if (kwd == _deviousHarnessKwd)
        return GetMaskForSlot(58);
    else if (kwd == _deviousCorsetKwd)
        return GetMaskForSlot(58);
    else if (kwd == _deviousCollarKwd)
        return GetMaskForSlot(45);
    else if (kwd == _deviousHeavyBondageKwd) {
        if (auto worn = a_actor->GetWornArmor(RE::BIPED_MODEL::BipedObjectSlot::kBody)) {
            if (worn->HasKeyword(_deviousStraitJacketKwd)) return GetMaskForSlot(32);
        }
        return GetMaskForSlot(46);
    } else if (kwd == _deviousPlugAnalKwd)
        return GetMaskForSlot(48);
    else if (kwd == _deviousBeltKwd)
        return GetMaskForSlot(49);
    else if (kwd == _deviousPiercingsVaginalKwd)
        return GetMaskForSlot(50);
    else if (kwd == _deviousPiercingsNippleKwd)
        return GetMaskForSlot(51);
    else if (kwd == _deviousLegCuffsKwd)
        return GetMaskForSlot(53);
    else if (kwd == _deviousBlindfoldKwd)
        return GetMaskForSlot(55);
    else if (kwd == _deviousBraKwd)
        return GetMaskForSlot(56);
    else if (kwd == _deviousPlugVaginalKwd)
        return GetMaskForSlot(57);
    else if (kwd == _deviousSuitKwd)
        return GetMaskForSlot(32);
    else if (kwd == _deviousGlovesKwd)
        return GetMaskForSlot(33);
    else if (kwd == _deviousHoodKwd)
        return GetMaskForSlot(30);
    else if (kwd == _deviousBootsKwd)
        return GetMaskForSlot(37);
    else if (kwd == _deviousBondageMittensKwd)
        return GetMaskForSlot(33);
    else
        return -1;
}

bool DeviousDevices::InventoryFilter::CheckWhitelist(const RE::TESBoundObject* a_item) const {
    if (a_item == nullptr) return false;
    auto loc_whitelist = ConfigManager::GetSingleton()->GetArray<std::string>("InventoryFilter.asWhitelist");

    if (loc_whitelist.size() == 0) return true;

    std::string loc_name = a_item->GetName();
    std::transform(loc_name.begin(), loc_name.end(), loc_name.begin(), ::tolower);  // to lower case

    if (loc_name == "") return false;

    // check whitelist
    for (auto&& it : loc_whitelist) {
        if ((it != "") && (it != " ") && (loc_name.find(it) != std::string::npos)) return false;
    }

    return true;
}

bool DeviousDevices::InventoryFilter::CheckWhitelistFood(const RE::TESBoundObject* a_item) const {
    if (a_item == nullptr) return false;
    auto loc_whitelist = ConfigManager::GetSingleton()->GetArray<std::string>("InventoryFilter.asWhitelistFood");

    if (loc_whitelist.size() == 0) return true;

    std::string loc_name = a_item->GetName();
    std::transform(loc_name.begin(), loc_name.end(), loc_name.begin(), ::tolower);  // to lower case

    if (loc_name == "") return false;

    // check whitelist
    for (auto&& it : loc_whitelist) {
        if ((it != "") && (it != " ") && (loc_name.find(it) != std::string::npos)) return false;
    }

    return true;
}

void DeviousDevices::InventoryFilter::Setup() {
    if (!_init) {
        _init = true;
        static RE::TESDataHandler* loc_datahandler = RE::TESDataHandler::GetSingleton();

        _sexlabNoStripKwd = loc_datahandler->LookupForm<RE::BGSKeyword>(0x02F16E, "Sexlab.esm");
        _jewelryKwd = loc_datahandler->LookupForm<RE::BGSKeyword>(0x02F16E, "Sexlab.esm");

        _deviousPlugKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousPlug");
        _deviousBeltKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousBelt");
        _deviousBraKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousBra");
        _deviousCollarKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousCollar");
        _deviousArmCuffsKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousArmCuffs");
        _deviousLegCuffsKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousLegCuffs");
        _deviousArmbinderKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousArmbinder");
        _deviousArmbinderElbowKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousArmbinderElbow");
        _deviousHeavyBondageKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousHeavyBondage");
        _deviousHobbleSkirtKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousHobbleSkirt");
        _deviousHobbleSkirtRelaxedKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousHobbleSkirtRelaxed");
        _deviousAnkleShacklesKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousAnkleShackles");
        _deviousStraitJacketKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousStraitJacket");
        _deviousCuffsFrontKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousCuffsFront");
        _deviousPetSuitKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousPetSuit");
        _deviousYokeKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousYoke");
        _deviousYokeBBKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousYokeBB");
        _deviousCorsetKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousCorset");
        _deviousClampsKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousClamps");
        _deviousGlovesKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousGloves");
        _deviousHoodKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousHood");
        _deviousSuitKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousSuit");
        _deviousElbowTieKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousElbowTie");
        _deviousGagKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousGag");
        _deviousGagRingKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousGagRing");
        _deviousGagLargeKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousGagLarge");
        _deviousGagPanelKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousGagPanel");
        _deviousPlugVaginalKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousPlugVaginal");
        _deviousPlugAnalKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousPlugAnal");
        _deviousHarnessKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousHarness");
        _deviousBlindfoldKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousBlindfold");
        _deviousBootsKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousBoots");
        _deviousPiercingsNippleKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousPiercingsNipple");
        _deviousPiercingsVaginalKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousPiercingsVaginal");
        _deviousBondageMittensKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousBondageMittens");
        _deviousPonyGearKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_DeviousPonyGear");

        _permitOralKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_PermitOral");
        _permitAnalKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_PermitAnal");
        _permitVaginalKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_PermitVaginal");

        _lockableKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_Lockable");
        _inventoryDeviceKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_InventoryDevice");

        _PermitOralKwd = RE::TESForm::LookupByEditorID<RE::BGSKeyword>("zad_PermitOral");
    }
}