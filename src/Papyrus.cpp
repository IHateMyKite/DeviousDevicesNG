#include "Papyrus.h"
#include "Expression.h"
#include "Hider.h"
#include "NodeHider.h"
#include "DeviceReader.h"
#include "LibFunctions.h"
#include <functional>
#include <algorithm>

using namespace RE;
using namespace RE::BSScript;
using namespace REL;
using namespace SKSE;
namespace DeviousDevices {
    constexpr std::string_view PapyrusClass = "zadNativeFunctions";

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
        REL::Relocation<RE::ObjectRefHandle*> selectedRef{ RELOCATION_ID(519394, REL::Module::get().version().patch() < 1130 ? 405935 : 504099) };
        auto handle = *selectedRef;
        return handle.get();
    }
    static inline void ConsoleUtil_CompileAndRun(RE::Script* script, RE::TESObjectREFR* targetRef, RE::COMPILER_NAME name = RE::COMPILER_NAME::kSystemWindowCompiler)
    {
        RE::ScriptCompiler compiler;
        REL::Relocation<void(RE::Script* script, RE::ScriptCompiler* compiler, RE::COMPILER_NAME name, RE::TESObjectREFR* targetRef)> func{ RELOCATION_ID(21416, REL::Module::get().version().patch() < 1130 ? 21890 : 441582) };
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
    REGISTERPAPYRUSFUNC(SetDisableUnequip, true);
    REGISTERPAPYRUSFUNC(GetDisableUnequip, true);
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