#include "LibFunctions.h"
#include "InventoryFilter.h"

SINGLETONBODY(DeviousDevices::LibFunctions)

using DeviousDevices::BondageState;

void DeviousDevices::LibFunctions::Setup()
{
    if (!_installed)
    {
        RE::TESDataHandler* loc_datahandler = RE::TESDataHandler::GetSingleton();

        if (loc_datahandler == nullptr) 
        {
            ERROR("LibFunctions::Setup() - loc_datahandler = NULL -> cant setup!")
            return;
        }

        auto loc_kwid = static_cast<RE::BGSKeyword*>(loc_datahandler->LookupForm(0x02B5F0,"Devious Devices - Integration.esm"));
        if (loc_kwid != nullptr) _idkw.push_back(loc_kwid);


        auto loc_kwlockable = static_cast<RE::BGSKeyword*>(loc_datahandler->LookupForm(0x003894,"Devious Devices - Assets.esm"));
        auto loc_kwplug     = static_cast<RE::BGSKeyword*>(loc_datahandler->LookupForm(0x003331,"Devious Devices - Assets.esm"));

        if (loc_kwlockable  != nullptr) _rdkw.push_back(loc_kwlockable);
        if (loc_kwplug      != nullptr) _rdkw.push_back(loc_kwplug);

        _hbkw = static_cast<RE::BGSKeyword*>(loc_datahandler->LookupForm(0x05226C,"Devious Devices - Integration.esm"));  //zad_DeviousHeavyBondage

        auto loc_ddanimationfaction = static_cast<RE::TESFaction*>(loc_datahandler->LookupForm(0x029567,"Devious Devices - Integration.esm"));  //dd animation faction
        auto loc_slanimationfaction = static_cast<RE::TESFaction*>(loc_datahandler->LookupForm(0x00E50F,"SexLab.esm"));  //sexlab animation faction

        if (loc_ddanimationfaction != nullptr) _animationfactions.push_back(loc_ddanimationfaction);
        if (loc_slanimationfaction != nullptr) _animationfactions.push_back(loc_slanimationfaction);

        _gagpanelfaction = static_cast<RE::TESFaction*>(loc_datahandler->LookupForm(0x030C3C,"Devious Devices - Integration.esm"));

        DEBUG("LibFunctions::Setup() - Installed")
        _installed = true;
    }

}

std::vector<RE::TESObjectARMO*> DeviousDevices::LibFunctions::GetDevices(RE::Actor* a_actor, int a_mode, bool a_worn)
{
    std::vector<RE::TESObjectARMO*> loc_res;
    if (a_actor == nullptr) return loc_res;

    RE::Actor::InventoryItemMap loc_inv = a_actor->GetInventory([this,a_mode](RE::TESBoundObject& a_obj)
    {
        switch (a_mode)
        {
        case 0: //inventory devices
            return a_obj.IsArmor() && a_obj.HasKeywordInArray(_idkw,false); 
        case 1: //render devices
            return a_obj.IsArmor() && a_obj.HasKeywordInArray(_rdkw,false);
        default:  //error mode
            return false;
        }
    });

    for (auto&& [i_obj, i_item] : loc_inv)
    {
        if (i_obj != nullptr && ((!a_worn) || ((i_item.second != nullptr) && (i_item.second->IsWorn()))))
        {
            if ((i_obj->As<RE::TESObjectARMO>() != nullptr))
            {
                if (a_mode == 0) loc_res.push_back(i_obj->As<RE::TESObjectARMO>());
                else loc_res.push_back(i_obj->As<RE::TESObjectARMO>());
            }
        }
    }

    return loc_res;
}

RE::TESObjectARMO* DeviousDevices::LibFunctions::GetWornDevice(RE::Actor* a_actor, RE::BGSKeyword* a_kw, bool a_fuzzy) {
    if ((a_actor == nullptr) || (a_kw == nullptr)) return nullptr;

    //LOG("LibFunctions::GetWornDevice({},{},{}) called",a_actor->GetName(),a_kw->GetFormEditorID(),a_fuzzy)

    RE::TESObjectARMO* loc_res = nullptr;
    auto loc_visitor = WornVisitor([this,&loc_res,a_kw,a_fuzzy](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        //LOG("LibFunctions::GetWornDevice() - Visited = {} {:08X}",a_entry->GetDisplayName(),a_entry->GetObject()->GetFormID())

        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor())
        {
            loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);
        }

        if (loc_armor != nullptr && loc_armor->HasKeywordInArray(_rdkw,false))
        {
            auto loc_device = DeviceReader::GetSingleton()->LookupDeviceByRendered(loc_armor);
            if (loc_device && ((!a_fuzzy && loc_device->kwd == a_kw) || (a_fuzzy && loc_armor->HasKeyword(a_kw))))
            {
                loc_res = loc_device->deviceInventory;
                //LOG("LibFunctions::GetWornDevice - Worn device found, res = {} {:08X}",loc_device->GetName(),loc_device->GetFormID())
                return RE::BSContainer::ForEachResult::kStop;
            }
            else if (loc_device == nullptr)
            {
                WARN("Could not find device unit for device {:08X} because of db error, or because device is of legacy type",loc_armor->GetFormID())
                return RE::BSContainer::ForEachResult::kStop;
            }
            else
            {
                return RE::BSContainer::ForEachResult::kContinue;
            }
        }
        else
        {
            return RE::BSContainer::ForEachResult::kContinue;
        }
    });

    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());

    return loc_res;
}

std::vector<RE::TESObjectARMO*> DeviousDevices::LibFunctions::GetWornDevices(RE::Actor* a_actor) const
{
    if ((a_actor == nullptr)) return std::vector<RE::TESObjectARMO*>();

    LOG("LibFunctions::GetWornDevices({}) called",a_actor->GetName())

    std::vector<RE::TESObjectARMO*> loc_res;
    auto loc_visitor = WornVisitor([this,&loc_res](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject

        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor())
        {
            loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);
        }

        if (loc_armor != nullptr && loc_armor->HasKeywordInArray(_rdkw,false))
        {
            loc_res.push_back(loc_armor);
            return RE::BSContainer::ForEachResult::kContinue;
        }
        else
        {
            return RE::BSContainer::ForEachResult::kContinue;
        }
    });

    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());

    return loc_res;
}

RE::TESObjectARMO* DeviousDevices::LibFunctions::GetHandRestrain(RE::Actor* a_actor)
{
    return GetWornDevice(a_actor,_hbkw,true);
}

bool DeviousDevices::LibFunctions::IsBound(RE::Actor* a_actor) const
{
    return WornHasKeyword(a_actor,_hbkw);
}

BondageState DeviousDevices::LibFunctions::GetBondageState(RE::Actor* a_actor) const
{
    if (a_actor == nullptr) return sNone;

    const auto loc_devices = GetWornDevices(a_actor);

    if (loc_devices.size() == 0) return sNone;

    uint32_t loc_res = sNone;

    for (auto&& it : loc_devices) 
    {
        if (it == nullptr) continue;

        if (it->HasKeywordString("zad_DeviousHeavyBondage"))
        {
            loc_res |= sHandsBound;
            if (it->HasKeywordString("zad_DeviousStraitJacket")) loc_res |= sHandsBoundNoAnim;
        }

        if (it->HasKeywordString("zad_DeviousBelt"))
        {
            if (!it->HasKeywordString("zad_PermitVaginal"))     loc_res |= sChastifiedGenital;
            if (!it->HasKeywordString("zad_PermitAnal"))        loc_res |= sChastifiedAnal;
        }

        if (ActorHasBlockingGag(a_actor,it))                    loc_res |= sGaggedBlocking;
        if (it->HasKeywordString("zad_DeviousBlindfold"))       loc_res |= sBlindfolded;
        if (it->HasKeywordString("zad_DeviousBoots"))           loc_res |= sBoots;
        if (it->HasKeywordString("zad_DeviousBondageMittens"))  loc_res |= sMittens;
        if (it->HasKeywordString("zad_DeviousBra"))             loc_res |= sChastifiedBreasts;
    }

    return (BondageState)loc_res;
}

bool DeviousDevices::LibFunctions::WornHasKeyword(RE::Actor* a_actor, RE::BGSKeyword* a_kw) const
{
    if ((a_actor == nullptr) || (a_kw == nullptr)) return false;

    //LOG("LibFunctions::WornHasKeyword({},{}) called",a_actor->GetName(),a_kw->GetFormEditorID())

    bool loc_res = false;
    auto loc_visitor = WornVisitor([this,&loc_res,a_kw](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor()) loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);

        if (loc_armor != nullptr && loc_armor->HasKeyword(a_kw))
        {
            loc_res = true;
            return RE::BSContainer::ForEachResult::kStop;
        }
        else return RE::BSContainer::ForEachResult::kContinue;
    });
    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());
    return loc_res;
}

bool DeviousDevices::LibFunctions::WornHasKeyword(RE::Actor* a_actor, std::string a_kw) const
{
    if ((a_actor == nullptr) || (a_kw == "")) return false;

    //DEBUG("LibFunctions::WornHasKeyword({},{}) called",a_actor->GetName(),a_kw)

    bool loc_res = false;
    auto loc_visitor = WornVisitor([this,&loc_res,a_kw](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor()) loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);

        if (loc_armor != nullptr && loc_armor->HasKeywordString(a_kw))
        {
            loc_res = true;
            return RE::BSContainer::ForEachResult::kStop;
        }
        else return RE::BSContainer::ForEachResult::kContinue;
    });
    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());
    return loc_res;
}

bool DeviousDevices::LibFunctions::WornHasKeywordAll(RE::Actor* a_actor, std::string a_kw) const
{
    if ((a_actor == nullptr) || (a_kw == "")) return false;

    //LOG("LibFunctions::WornHasKeyword({},{}) called",a_actor->GetName(),a_kw->GetFormEditorID())

    bool loc_res = false;
    auto loc_visitor = WornVisitor([this,&loc_res,a_actor,a_kw](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor()) loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);

        if (loc_armor != nullptr)
        {
            // Check if armor have keyword
            if (loc_armor->HasKeywordString(a_kw))
            {
                loc_res = true;
                return RE::BSContainer::ForEachResult::kStop;
            }
            // Check if any of the effects have the same keyword
            if (loc_armor->formEnchanting)
            {
                for (auto&& it : loc_armor->formEnchanting->effects)
                {
                    if (it->conditions.IsTrue(a_actor,a_actor) && it->baseEffect->HasKeywordString(a_kw))
                    {
                        loc_res = true;
                        return RE::BSContainer::ForEachResult::kStop;
                    }
                }
            }
            return RE::BSContainer::ForEachResult::kContinue;
        }
        else return RE::BSContainer::ForEachResult::kContinue;
    });
    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());
    return loc_res;
}

bool DeviousDevices::LibFunctions::WornHasKeywordAll(RE::Actor* a_actor, RE::BGSKeyword* a_kw) const
{
    if ((a_actor == nullptr) || (a_kw == nullptr)) return false;

    //LOG("LibFunctions::WornHasKeyword({},{}) called",a_actor->GetName(),a_kw->GetFormEditorID())

    bool loc_res = false;
    auto loc_visitor = WornVisitor([this,&loc_res,a_actor,a_kw](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor()) loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);

        if (loc_armor != nullptr)
        {
            // Check if armor have keyword
            if (loc_armor->HasKeyword(a_kw))
            {
                loc_res = true;
                return RE::BSContainer::ForEachResult::kStop;
            }
            // Check if any of the effects have the same keyword
            if (loc_armor->formEnchanting)
            {
                for (auto&& it : loc_armor->formEnchanting->effects)
                {
                    if (it->conditions.IsTrue(a_actor,a_actor) && it->baseEffect->HasKeyword(a_kw))
                    {
                        loc_res = true;
                        return RE::BSContainer::ForEachResult::kStop;
                    }
                }
            }
            return RE::BSContainer::ForEachResult::kContinue;
        }
        else return RE::BSContainer::ForEachResult::kContinue;
    });
    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());
    return loc_res;
}

RE::TESObjectARMO* DeviousDevices::LibFunctions::GetWornArmor(RE::Actor* a_actor, int a_mask) const
{
    if (a_actor == nullptr) return nullptr;

    //LOG("LibFunctions::GetWornArmor({},{:08X}) called",a_actor->GetName(),a_mask)

    RE::TESObjectARMO* loc_res = nullptr;
    auto loc_visitor = WornVisitor([this,&loc_res,a_mask](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor()) loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);

        if (loc_armor != nullptr && ((int)loc_armor->GetSlotMask().underlying() & a_mask))
        {
            loc_res = loc_armor;
            return RE::BSContainer::ForEachResult::kStop;
        }
        else return RE::BSContainer::ForEachResult::kContinue;
    });
    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());
    return loc_res;
}

RE::TESObjectARMO* DeviousDevices::LibFunctions::GetWornArmor(RE::Actor* a_actor, const std::string& a_kw) const
{
    if (a_actor == nullptr) return nullptr;

    //LOG("LibFunctions::GetWornArmor({},{}) called",a_actor->GetName(),a_kw)

    RE::TESObjectARMO* loc_res = nullptr;
    auto loc_visitor = WornVisitor([this,&loc_res,a_kw](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor()) loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);

        if (loc_armor != nullptr && loc_armor->HasKeywordString(a_kw))
        {
            loc_res = loc_armor;
            return RE::BSContainer::ForEachResult::kStop;
        }
        else return RE::BSContainer::ForEachResult::kContinue;
    });
    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());
    return loc_res;
}

RE::TESObjectARMO* DeviousDevices::LibFunctions::GetWornArmor(RE::Actor* a_actor, std::vector<std::string> a_kws, bool a_any) const
{
    if (a_actor == nullptr) return nullptr;

    //LOG("LibFunctions::GetWornArmor({}, multiple keywords) called",a_actor->GetName())

    RE::TESObjectARMO* loc_res = nullptr;
    auto loc_visitor = WornVisitor([this,&loc_res,&a_kws,a_any](RE::InventoryEntryData* a_entry)
    {
        #undef GetObject
        auto loc_object = a_entry->GetObject();
        RE::TESObjectARMO* loc_armor = nullptr;
        if (loc_object != nullptr && loc_object->IsArmor()) loc_armor = static_cast<RE::TESObjectARMO*>(loc_object);

        if (loc_armor != nullptr)
        {
            for (auto&& kw : a_kws) 
            {
                if (loc_armor->HasKeywordString(kw))
                {
                    loc_res = loc_armor;
                    return RE::BSContainer::ForEachResult::kStop;
                }
                else if (!a_any)
                {
                    return RE::BSContainer::ForEachResult::kContinue;
                }
            }
            return RE::BSContainer::ForEachResult::kContinue;

        }
        else return RE::BSContainer::ForEachResult::kContinue;
    });
    a_actor->GetInventoryChanges()->VisitWornItems(loc_visitor.AsNativeVisitor());
    return loc_res;
}

bool DeviousDevices::LibFunctions::IsAnimating(RE::Actor* a_actor)
{
    if (a_actor == nullptr) return false;
    for (auto&& it : _animationfactions)
    {
        if ((it != nullptr) && a_actor->IsInFaction(it)) return true;
    }
    return false;
}

bool DeviousDevices::LibFunctions::PluginInstalled(std::string a_dll)
{
    HINSTANCE dllHandle = LoadLibraryA(a_dll.c_str());
    if (dllHandle != NULL)
    {
        FreeLibrary(dllHandle);
        return true;
    }
    else
    {
        return false;
    }
}

bool DeviousDevices::LibFunctions::ActorHasBlockingGag(RE::Actor* a_actor, RE::TESObjectARMO* a_gag) const
{
    RE::TESObjectARMO* loc_armor = nullptr;
    if (a_gag)
        loc_armor = a_gag;
    else
        loc_armor = LibFunctions::GetSingleton()->GetWornArmor(a_actor, GetMaskForSlot(44));

    if (loc_armor != nullptr) {
        if (loc_armor->HasKeywordString("zad_DeviousGag")) {
            if (loc_armor->HasKeywordString("zad_DeviousGagRing") || loc_armor->HasKeywordString("zad_PermitOral")) {
                return false;                                       // is ring gag, do not remove food
            } else if (loc_armor->HasKeywordString("zad_DeviousGagPanel"))  // is panel gag, additional check needed
            {
                return a_actor->GetFactionRank(_gagpanelfaction, a_actor->IsPlayer()) == 1;
            }
            return true;
        } else {  // check hood
            loc_armor = LibFunctions::GetSingleton()->GetWornArmor(a_actor, GetMaskForSlot(42));
            if (loc_armor && loc_armor->HasKeywordString("zad_DeviousGag")) {
                return true;
            }
        }
    }
    return false;
}

bool DeviousDevices::LibFunctions::IsDevice(RE::TESObjectARMO* a_obj) const
{
    if (a_obj == nullptr) return false;
    return a_obj->HasKeywordInArray(_idkw, false) || a_obj->HasKeywordInArray(_rdkw, false);
}
