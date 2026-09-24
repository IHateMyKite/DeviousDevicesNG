#include "Papyrus.h"
#include "Expression.h"
#include "Hider.h"
#include "NodeHider.h"
#include "DeviceReader.h"
#include "LibFunctions.h"
#include <functional>
#include <algorithm>
#undef GetObject
using namespace RE;
using namespace RE::BSScript;
using namespace REL;
using namespace SKSE;
namespace DeviousDevices {
    constexpr std::string_view PapyrusClass = "zadNativeFunctions";
    RE::BSScript::Object* GetInventoryObjectScript(RE::Actor* actor, RE::TESObjectARMO* armor,
                                              RE::BSFixedString scriptClass, RE::BSFixedString p) {
        RE::BSScript::Object* result = nullptr;
        auto VM = RE::BSScript::Internal::VirtualMachine::GetSingleton();
        if (!VM) return result;
        auto BP = VM->GetObjectBindPolicy();
        if (!BP) return result;
        if (!BP->bindInterface) return result;
        if (actor && armor) {
            if (actor->GetInventory().contains(armor)) {
                if (!actor->GetInventoryChanges() || !actor->GetInventoryChanges()->entryList) {
                    return nullptr;
                }

                for (auto& inventoryEntry : *actor->GetInventoryChanges()->entryList) {
                    if (inventoryEntry->object != armor) {
                        continue;
                    }
                    for (auto& extraList : *inventoryEntry->extraLists) {
                        for (auto& extraData : *extraList) {
                            auto extra = &extraData;
                            while (extra) {
                                if (extra->GetType() == RE::ExtraDataType::kUniqueID) {
                                    auto extraID = (RE::ExtraUniqueID*)extra;
                                    if (!VM->attachedScripts.contains(((uint64_t)actor->formID) |
                                                                      ((uint64_t)0x0001000000000000ULL) |
                                                                      (((uint64_t)(extraID->uniqueID)) << 32))) {
                                        continue;
                                    }
                                    auto attached_scripts = VM->attachedScripts.find(
                                        ((uint64_t)actor->formID) | ((uint64_t)0x0001000000000000ULL) |
                                        (((uint64_t)(extraID->uniqueID)) << 32));

                                    auto attached_script_count = attached_scripts->second.size();

                                    for (uint32_t s_i = 0; s_i < attached_script_count; s_i++) {
                                        auto& script = attached_scripts->second[s_i];
                                        if (auto s = script.get()) {
                                            if (scriptClass != RE::BSFixedString("")) {
                                                if (RE::BSFixedString(s->type->name) == scriptClass) {
                                                    result = s;
                                                    return result;
                                                }
                                            } else {
                                                if (s->GetProperty(p)) {
                                                    result = s;
                                                    return result;
                                                }
                                            }
                                        }
                                    }

                                }

                                if (extra == extra->next) {
                                    break;
                                }
                                extra = extra->next;
                            }
                        }
                    }
                }
            }
        }
        return result;
    }
    bool GetInventoryObjectPropertyExists(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                  RE::BSFixedString script, RE::BSFixedString property) 
    {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                return true;
            }
        }
        return false;
    }
    bool SetInventoryObjectPropertyInt(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                  RE::BSFixedString script, RE::BSFixedString property, int value) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                s->GetProperty(property)->SetSInt(value);
                return true;
            }
        }
        return false;
    }

    bool SetInventoryObjectPropertyFloat(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                    RE::BSFixedString script, RE::BSFixedString property, float value) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                s->GetProperty(property)->SetFloat(value);
                return true;
            }
        }
        return false;
    }

    bool SetInventoryObjectPropertyString(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                     RE::BSFixedString script, RE::BSFixedString property, RE::BSFixedString value) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                s->GetProperty(property)->SetString(value);
                return true;
            }
        }
        return false;
    }
    bool SetInventoryObjectPropertyBool(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                   RE::BSFixedString script, RE::BSFixedString property, bool value) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                s->GetProperty(property)->SetBool(value);
                return true;
            }
        }
        return false;
    }
    int GetInventoryObjectPropertyType(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                 RE::BSFixedString script, RE::BSFixedString property) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                return (int)s->GetProperty(property)->GetType().GetRawType();
            }
        }
        return 0;
    }
    RE::TESForm* GetInventoryObjectPropertyObject(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                             RE::BSFixedString script, RE::BSFixedString property) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property) && s->GetProperty(property)->GetObject()) {
                return (RE::TESForm*)s->GetProperty(property)->GetObject()->Resolve(
                    (RE::VMTypeID)RE::TESForm::FORMTYPE);
            }
        }
        return nullptr;
    }
    int GetInventoryObjectPropertyInt(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                 RE::BSFixedString script, RE::BSFixedString property) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                return s->GetProperty(property)->GetSInt();
            }
        }
        return 0;
    }

    float GetInventoryObjectPropertyFloat(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                     RE::BSFixedString script, RE::BSFixedString property) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                return s->GetProperty(property)->GetFloat();
            }
        }
        return 0.0;
    }
    RE::BSFixedString GetInventoryObjectPropertyString(RE::StaticFunctionTag* base, RE::Actor* actor,
                                                  RE::TESObjectARMO* armor, RE::BSFixedString script,
                                                  RE::BSFixedString property) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                return s->GetProperty(property)->GetString();
            }
        }
        return "";
    }
    bool GetInventoryObjectPropertyBool(RE::StaticFunctionTag* base, RE::Actor* actor, RE::TESObjectARMO* armor,
                                   RE::BSFixedString script, RE::BSFixedString property) {
        if (auto s = GetInventoryObjectScript(actor, armor, script,property)) {
            if (s->GetProperty(property)) {
                return s->GetProperty(property)->GetBool();
            }
        }
        return false;
    }
    bool FormHasKeywordString(StaticFunctionTag* base, TESForm* obj, std::string kwd) {
        if (!obj) {
            LOG("FormHasKeywordString received none obj.");
            return false;
        }
               
        BGSKeyword* keyword = TESForm::LookupByEditorID<BGSKeyword>(kwd);

        if (keyword) {
            std::vector<BGSKeyword*> kwdArr;
            kwdArr.push_back(keyword);
            return obj->HasKeywordInArray(kwdArr, true);
        } 

        return false;
    }

    bool FormHasKeyword(StaticFunctionTag* base, TESForm* obj, BGSKeyword* kwd) {
        if (obj && kwd) {
            std::vector<BGSKeyword*> kwdArr;
            kwdArr.push_back(kwd);
            return obj->HasKeywordInArray(kwdArr, true);
        }
        return false;
    }

    bool Print(StaticFunctionTag* base, std::string msg) {
        LOG("Received string: {}", msg);
        return false;
    }

    TESForm* FindMatchingDevice(StaticFunctionTag* base, Actor* obj, BGSKeyword* kwd) {
        if (!obj) {
            LOG("ReEquipExistingDevice received NULL obj.");
            return NULL;
        }
        
        std::map<TESBoundObject*, std::int32_t> inventory = obj->GetInventoryCounts();
        
        for (auto& entry : inventory) {
            if (FormHasKeyword(base, entry.first, kwd)) {
                return entry.first;
            }
        }

        return NULL;
    }

    void CTrace(PAPYRUSFUNCHANDLE, std::string a_msg)
    {
        if (RE::ConsoleLog::GetSingleton() != nullptr)
        {
            RE::ConsoleLog::GetSingleton()->Print((std::string("[DD] ") + a_msg).c_str());
        }
    }

    // === Copied from ConsoleUtilSSE NG https://github.com/VersuchDrei/ConsoleUtilSSE/tree/master
    static inline RE::NiPointer<RE::TESObjectREFR> ConsoleUtil_GetSelectedRef() 
    {
        REL::Relocation<RE::ObjectRefHandle*> selectedRef{ RELOCATION_ID(519394, ((REL::Module::get().version().patch() < 1130) && (REL::Module::get().version().minor() < 7)) ? 405935 : 504099) };
        auto handle = *selectedRef;
        return handle.get();
    }
    static inline void ConsoleUtil_CompileAndRun(RE::Script* script, RE::TESObjectREFR* targetRef, RE::COMPILER_NAME name = RE::COMPILER_NAME::kSystemWindowCompiler)
    {
        RE::ScriptCompiler compiler;
        REL::Relocation<void(RE::Script* script, RE::ScriptCompiler* compiler, RE::COMPILER_NAME name, RE::TESObjectREFR* targetRef)> func{ RELOCATION_ID(21416,((REL::Module::get().version().patch() < 1130) && (REL::Module::get().version().minor() < 7)) ? 21890 : 441582) };
        func(script, &compiler, name, targetRef);
    }
    void ExecuteConsoleCmd(PAPYRUSFUNCHANDLE, std::string a_cmd) 
    {
        const auto scriptFactory = RE::IFormFactory::GetConcreteFormFactoryByType<RE::Script>();
        const auto script = scriptFactory ? scriptFactory->Create() : nullptr;
        if (script) {
            const auto selectedRef = ConsoleUtil_GetSelectedRef();
            script->SetCommand(a_cmd);
            ConsoleUtil_CompileAndRun(script, selectedRef.get());
            delete script;
        }
    }

}

bool DeviousDevices::RegisterFunctions(IVirtualMachine* vm) {
    //unhookfps means that the function will be unhooked from fps which will make it insanily faster. 
    //Note that not all functions can be unhooked from framerate (like some actor setters, as they are dependant on frame update)
    #if (DD_ALLOWFASTPAPYRUSCALL_S == 1U)
        #define REGISTERPAPYRUSFUNC(name,unhookfps) {vm->RegisterFunction(#name, PapyrusClass, DeviousDevices::name,unhookfps);}
    #else
        #define REGISTERPAPYRUSFUNC(name,unhookfps) {vm->RegisterFunction(#name, PapyrusClass, DeviousDevices::name,false);}
    #endif

    //Papyrus.h
    REGISTERPAPYRUSFUNC(GetInventoryObjectPropertyType, false);
    REGISTERPAPYRUSFUNC(SetInventoryObjectPropertyInt, false);
    REGISTERPAPYRUSFUNC(SetInventoryObjectPropertyFloat, false);
    REGISTERPAPYRUSFUNC(SetInventoryObjectPropertyString, false);
    REGISTERPAPYRUSFUNC(SetInventoryObjectPropertyBool, false);
    REGISTERPAPYRUSFUNC(GetInventoryObjectPropertyInt, false);
    REGISTERPAPYRUSFUNC(GetInventoryObjectPropertyFloat, false);
    REGISTERPAPYRUSFUNC(GetInventoryObjectPropertyString, false);
    REGISTERPAPYRUSFUNC(GetInventoryObjectPropertyBool, false);
    REGISTERPAPYRUSFUNC(GetInventoryObjectPropertyObject, false);
    REGISTERPAPYRUSFUNC(FormHasKeywordString,true);
    REGISTERPAPYRUSFUNC(FindMatchingDevice,true);
    REGISTERPAPYRUSFUNC(CTrace,true);

    //Expression.h
    REGISTERPAPYRUSFUNC(ApplyExpression,true);
    REGISTERPAPYRUSFUNC(GetExpression,true);
    REGISTERPAPYRUSFUNC(ResetExpression,true);
    REGISTERPAPYRUSFUNC(UpdateGagExpression,true);
    REGISTERPAPYRUSFUNC(RegisterGagType,true);
    REGISTERPAPYRUSFUNC(RegisterDefaultGagType,true);
    REGISTERPAPYRUSFUNC(ResetGagExpression,true);

    //hider
    REGISTERPAPYRUSFUNC(SyncSetting,true);
    REGISTERPAPYRUSFUNC(SetActorStripped,true);
    REGISTERPAPYRUSFUNC(IsActorStripped,true);
    REGISTERPAPYRUSFUNC(ShowWeapons, true);
    REGISTERPAPYRUSFUNC(HideWeapons, true);


    //device reader
    REGISTERPAPYRUSFUNC(GetRenderDevice,true);
    REGISTERPAPYRUSFUNC(GetInventoryDevice,true);
    REGISTERPAPYRUSFUNC(GetPropertyForm,true);
    REGISTERPAPYRUSFUNC(GetPropertyInt,true);
    REGISTERPAPYRUSFUNC(GetPropertyFloat,true);
    REGISTERPAPYRUSFUNC(GetPropertyBool,true);
    REGISTERPAPYRUSFUNC(GetPropertyString,true);
    REGISTERPAPYRUSFUNC(GetPropertyFormArray,true);
    REGISTERPAPYRUSFUNC(GetPropertyIntArray,true);
    REGISTERPAPYRUSFUNC(GetPropertyFloatArray,true);
    REGISTERPAPYRUSFUNC(GetPropertyBoolArray,true);
    REGISTERPAPYRUSFUNC(GetPropertyStringArray,true);
    REGISTERPAPYRUSFUNC(GetEditingMods,true);
    REGISTERPAPYRUSFUNC(GetDeviceByName,true);

    REGISTERPAPYRUSFUNC(SetManipulated, true);
    REGISTERPAPYRUSFUNC(GetManipulated, true);

    //LibFunctions
    REGISTERPAPYRUSFUNC(GetDevices, true);
    REGISTERPAPYRUSFUNC(GetWornDevice, true);
    REGISTERPAPYRUSFUNC(PluginInstalled, true);
    REGISTERPAPYRUSFUNC(ExecuteConsoleCmd, false);

    #undef REGISTERPAPYRUSFUNC
    return true;
}
