#pragma once

#include "DeviceReader.h"
#include "HooksVirtual.h"
#include "InventoryFilter.h"
#include <detours/detours.h>
#include "Script.hpp"
#include "MovementManager.h"

namespace DeviousDevices {
    namespace Hooks {
        static bool DDInventoryUnequip = false;
        static std::recursive_mutex unequip_mutex;
        static bool GetNormalUnequipMode() {
            std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
            return DDInventoryUnequip;
        }

        DeviceReader* g_dManager;

        template <class F, class T>
        static void write_vfunc() {
            REL::Relocation<std::uintptr_t> vtbl{F::VTABLE[0]};
            T::func = vtbl.write_vfunc(T::idx, T::thunk);
        }

        struct AddObjectToContainerHook {
            static void thunk(RE::PlayerCharacter* player, RE::TESBoundObject* a_object, RE::ExtraDataList* a_extraList,
                              int32_t a_count, RE::TESObjectREFR* a_fromRefr) {
                if (InventoryFilter::GetSingleton()->TakeFilter(player, a_object)) return;
                func(player, a_object, a_extraList, a_count, a_fromRefr);
            }

            static inline REL::Relocation<decltype(thunk)> func;

            static inline int idx = 0x5A;

            static inline void Install() { write_vfunc<RE::PlayerCharacter, AddObjectToContainerHook>(); }
        };

        struct PickUpObjectHook {
            static void thunk(RE::PlayerCharacter* player, RE::TESObjectREFR* a_item, uint32_t a_count, bool a_arg3,
                              bool a_playSound) {
                if (InventoryFilter::GetSingleton()->TakeFilter(player, a_item->GetBaseObject())) return;
                func(player, a_item, a_count, a_arg3, a_playSound);
            }


            static inline REL::Relocation<decltype(thunk)> func;

            static inline int idx = REL::Module::GetRuntime() != REL::Module::Runtime::VR ? 0xCC : 0xCE;

            static inline void Install() { write_vfunc<RE::PlayerCharacter, PickUpObjectHook>(); }
        };
      
        struct EquipSpellHook {
                    static void thunk(RE::ActorEquipManager* a_manager, RE::Actor* a_actor, RE::TESBoundObject* a_object,
                                        const RE::BGSEquipSlot& a_slot) {
                        if (a_actor && a_object && a_object->Is(RE::FormType::Spell) && 
                            InventoryFilter::GetSingleton()->EquipFilter(a_actor, a_object)) {
                            LOG("EquipSpellHook restricted <{:08X}:{}> for <{:08X}:{}>", a_object->GetFormID(), a_object->GetName(),
                                a_actor->GetFormID(), a_actor->GetName())
                            return;
                        }
                        return func(a_manager, a_actor, a_object, a_slot);
                    }
                    static inline REL::Relocation<decltype(thunk)> func;

                    static inline void Install() {
                        std::array targets{
                            REL::Relocation<std::uintptr_t>(RELOCATION_ID(37939, 38895),            REL::VariantOffset(0x47, 0x47, 0x47)),
                            REL::Relocation<std::uintptr_t>(REL::VariantID(37950, 38906, 0x6415E0), REL::VariantOffset(0xC5, 0xCA, 0xC5)),
                            REL::Relocation<std::uintptr_t>(REL::VariantID(37952, 38908, 0x641A30), REL::VariantOffset(0xD7, 0xD7, 0xD7))};

                        auto& trampoline = SKSE::GetTrampoline();

                        for (const auto& target : targets) {
                            SKSE::AllocTrampoline(14);
                            EquipSpellHook::func = trampoline.write_call<5>(target.address(), EquipSpellHook::thunk);
                        }
                    }
        };

        struct EquipShoutHook {
            static void thunk(RE::ActorEquipManager* a_manager, RE::Actor* a_actor, RE::TESBoundObject* a_object,
                              RE::BGSEquipSlot* a_slot) {
                // not sure if check for formtype is necessary, don't know if other stuff goes through this function
                if (a_actor && a_object && a_object->Is(RE::FormType::Shout) &&
                    InventoryFilter::GetSingleton()->EquipFilter(a_actor, a_object)) {
                    LOG("EquipShoutHook restricted <{:08X}:{}> for <{:08X}:{}>", a_object->GetFormID(), a_object->GetName(),
                        a_actor->GetFormID(), a_actor->GetName())
                    return;
                }
                return func(a_manager, a_actor, a_object, a_slot);
            }
            static inline REL::Relocation<decltype(thunk)> func;

            static inline void Install() {
                std::array targets{
                    REL::Relocation<std::uintptr_t>(RELOCATION_ID(37941, 38897),            REL::VariantOffset(0x21, 0x21, 0x21)),
                    REL::Relocation<std::uintptr_t>(REL::VariantID(37953, 38909, 0x641B30), REL::VariantOffset(0x4B, 0x4B, 0x4B))};

                auto& trampoline = SKSE::GetTrampoline();

                for (const auto& target : targets) {
                    SKSE::AllocTrampoline(14);
                    func = trampoline.write_call<5>(target.address(), thunk);
                }
            }
        };
      
        struct UpdateMovementSpeedHook {
            static float thunk(RE::AIProcess& a1, float a2) 
            {
                if (a1.GetUserData() && a1.GetUserData()->IsPlayerRef())
                {
                    static auto loc_manager = MovementManager::GetSingleton();
                    a2 = (loc_manager->ManageSpeed(a1.GetUserData(),a2));
                }

                return func(a1,a2);
            }
            static inline REL::Relocation<decltype(thunk)> func;

            static inline void Install() 
            {
                // Will be used for NPCs in future

                //const uintptr_t loc_UpdateMovementAddress = RELOCATION_ID(0, 39873).address();
                //func = (decltype(func))loc_UpdateMovementAddress;
                //
                //DetourTransactionBegin();
                //DetourUpdateThread(GetCurrentThread());
                //DetourAttach(&(PVOID&)func, (PBYTE)&thunk);
            }
        };

        struct UpdateAutoMoveHook {
            static bool thunk(RE::PlayerControls* a_pc) 
            {
                static auto loc_manager = MovementManager::GetSingleton();
                bool loc_res = func(a_pc);
                loc_manager->ManageAutoMove(a_pc);
                return loc_res;
            }
            static inline REL::Relocation<decltype(thunk)> func;

            static inline void Install() 
            {
                const uintptr_t loc_UpdatePlayerMovementAddress = REL::VariantID(41291, 42371,0x72df10).address();
                func = (decltype(func))loc_UpdatePlayerMovementAddress;
                
                DetourTransactionBegin();
                DetourUpdateThread(GetCurrentThread());
                DetourAttach(&(PVOID&)func, (PBYTE)&thunk);
            }
        };


        //

        typedef bool(WINAPI* OriginalEquipObject)(  RE::ActorEquipManager* a_1, 
                                                    RE::Actor* a_actor,
                                                    RE::TESBoundObject* a_object, 
                                                    RE::ExtraDataList* a_extraData,
                                                    std::uint32_t a_count, 
                                                    RE::BGSEquipSlot* a_slot, 
                                                    bool a_queueEquip,
                                                    bool a_forceEquip, 
                                                    bool a_playSounds, 
                                                    bool a_applyNow);
        typedef void(WINAPI* OriginalInventoryUIUnequipObject)(uint64_t arg0, uint64_t arg1, uint64_t arg2, uint64_t arg3,
                                                       uint64_t arg4);

        typedef bool(WINAPI* OriginalUnequipObject)(RE::ActorEquipManager* a_1, 
                                                    RE::Actor* a_actor,
                                                    RE::TESBoundObject* a_object,
                                                    std::uint64_t a_extraData, 
                                                    std::uint64_t a_count,
                                                    std::uint64_t a_slot, 
                                                    std::uint64_t a_queueEquip,
                                                    std::uint64_t a_forceEquip, 
                                                    std::uint64_t a_playSounds,
                                                    std::uint64_t a_applyNow, 
                                                    std::uint64_t a_slotToReplace);

        typedef bool(WINAPI* OriginalEquipObject2)(RE::ActorEquipManager* a_1,
                                                       RE::Actor* actor, 
                                                       RE::TESBoundObject* item,
                                                       std::uint64_t a_extradata, 
                                                       std::uint64_t a_unkw);

        inline OriginalEquipObject      _EquipObject;
        inline OriginalUnequipObject    _UnequipObject;
        inline OriginalInventoryUIUnequipObject _InventoryUIUnequipObject;
        inline OriginalEquipObject2     _EquipObject2;

        static bool EquipObject(RE::ActorEquipManager*      a_1,
                                RE::Actor*                  a_actor,
                                RE::TESBoundObject*         a_item,
                                RE::ExtraDataList*          a_extraData,
                                std::uint32_t               a_count,
                                RE::BGSEquipSlot*           a_slot,
                                bool                        a_queueEquip,
                                bool                        a_forceEquip,
                                bool                        a_playSounds,
                                bool                        a_applyNow)
        {
            

            if (DeviceReader::GetSingleton() && a_actor && a_item && a_item->As<RE::TESObjectARMO>()) {
                RE::TESObjectARMO* armor=a_item->As<RE::TESObjectARMO>();
                {
                    auto device = DeviceReader::GetSingleton()->GetDeviceUnit(armor,0);

                    if (device.deviceRendered) {
                        if (device.CanEquip(a_actor)) {
                            if (DDInventoryUnequip == false) {
                                a_playSounds = false;
                            }
                            return _EquipObject(a_1, a_actor, a_item, a_extraData, a_count, a_slot, a_queueEquip, a_forceEquip, a_playSounds,
                                a_applyNow);
                        } else {
                            return false;
                        }
                    }
                }
                {
                    auto device = DeviceReader::GetSingleton()->GetDeviceUnit(armor,1);
                    if (device.deviceRendered) {
                        if (device.CanEquip(a_actor)) {
                            if (DDInventoryUnequip == false) {
                                a_playSounds = false;
                            }
                            return _EquipObject(a_1, a_actor, a_item, a_extraData, a_count, a_slot, a_queueEquip, a_forceEquip,
                                                a_playSounds,
                                a_applyNow);
                        } else {
                            return false;
                        }
                    }
                }
                
            }
            return _EquipObject(a_1, a_actor, a_item, a_extraData, a_count, a_slot, a_queueEquip, a_forceEquip, a_playSounds,
                         a_applyNow);
            
        }
        static void InventoryUIUnequipObject(uint64_t arg0, uint64_t arg1, uint64_t arg2, uint64_t arg3,
            uint64_t arg4)
        {
            {
                std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
                DDInventoryUnequip = true;
            }
            _InventoryUIUnequipObject (arg0,arg1,arg2,arg3,arg4);
            {
                std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
                DDInventoryUnequip = false;
            }
        }
        static bool UnequipObject(RE::ActorEquipManager* a_1, RE::Actor* actor, RE::TESBoundObject* item,
                                  std::uint64_t a_extraData, std::uint64_t a_count, std::uint64_t a_slot,
                                  std::uint64_t a_queueEquip, std::uint64_t a_forceEquip, std::uint64_t a_playSounds,
                                  std::uint64_t a_applyNow, std::uint64_t a_slotToReplace) {
            // api calls to remove the device should use the hooked func directly - this is for external attempts

            // cases: remove all items, external mod calling unequip, user trying through inventory

            // need to check for quest item
            if (DeviceReader::GetSingleton() && actor && item && item->formType == RE::FormType::Armor &&
                item->As<RE::TESObjectARMO>()) {
                if (DeviceReader::GetSingleton()->GetDisableUnequip(actor, item->As<RE::TESObjectARMO>()) == false ||
                    (RE::UI::GetSingleton() && DeviousDevices::HooksVirtual::GetSingleton() &&
                     RE::UI::GetSingleton()->IsMenuOpen("InventoryMenu") && (GetNormalUnequipMode()==true || (REL::Module::GetRuntime() == REL::Module::Runtime::SE) ))) {
                    DEBUG("Unequip allowed or user requested unequip")
                    
                    return _UnequipObject(a_1, actor, item, a_extraData, a_count, a_slot, a_queueEquip, a_forceEquip,
                                          a_playSounds, a_applyNow, a_slotToReplace);
                } else {
                    DEBUG("Unequip prevented")
                    return false;
                }
            } else {
                DEBUG("Unequip ignored and allowed")
                return _UnequipObject(a_1, actor, item, a_extraData, a_count, a_slot, a_queueEquip, a_forceEquip,
                                      a_playSounds, a_applyNow, a_slotToReplace);
            }
        }

        // Some mods or game itself calls this method sometimes directly (mainly for NPCs). 
        // Because of that, the EquipObject hook will not work 100% of time
        // Using this will make it bulletproof
        static void EquipObject2(RE::ActorEquipManager* a_1,RE::Actor* a_actor, RE::TESBoundObject* a_item,
                                  std::uint64_t a_extradata, std::uint64_t a_unkw)
        {
            //DEBUG("EquipBipedObject({},{}) called",a_actor->GetName(),a_item->GetName())

            // Apply inventory filter
            if (InventoryFilter::GetSingleton()->EquipFilter(a_actor, a_item)) {
                DEBUG("EquipObject2 restricted <{:08X}:{}> for <{:08X}:{}>", a_item->GetFormID(), a_item->GetName(),
                    a_actor->GetFormID(), a_actor->GetName())
                return;
            }
            _EquipObject2(a_1,a_actor,a_item,a_extradata,a_unkw);
        }

        inline void Install() {
            static bool loc_installed = false;
            if (loc_installed)  return;
            loc_installed = true;
            g_dManager = DeviceReader::GetSingleton();

            AddObjectToContainerHook::Install();
            PickUpObjectHook::Install();
          
            if (!ConfigManager::GetSingleton()->GetVariable<bool>("InventoryFilter.bEquipSpell", true))
            {
                EquipSpellHook::Install();
            }
            if (!ConfigManager::GetSingleton()->GetVariable<bool>("InventoryFilter.bEquipShout", true))
            {
                EquipShoutHook::Install();
            }

            UpdateMovementSpeedHook::Install();
            UpdateAutoMoveHook::Install();
            {
                const uintptr_t loc_equipTargetAddress = RE::Offset::ActorEquipManager::EquipObject.address();
                _EquipObject = (OriginalEquipObject)loc_equipTargetAddress;

                DetourTransactionBegin();
                DetourUpdateThread(GetCurrentThread());
                DetourAttach(&(PVOID&)_EquipObject, (PBYTE)&EquipObject);

                if (DetourTransactionCommit() == NO_ERROR) {
                    LOG("Installed papyrus hook on EqquipObject at {0:x} with replacement from address {0:x}",
                        loc_equipTargetAddress, (void*)&EquipObject);
                } else {
                    WARN("Failed to install papyrus hook on EquipObject");
                }
            }
            const uintptr_t loc_equip2TargetAddress = REL::VariantID(37974, 38929, 0x642E30).address();
            _EquipObject2 = (OriginalEquipObject2)loc_equip2TargetAddress;
            DetourTransactionBegin();
            DetourUpdateThread(GetCurrentThread());
            DetourAttach(&(PVOID&)_EquipObject2, (PBYTE)&EquipObject2);

            if (DetourTransactionCommit() == NO_ERROR)
            {
                DEBUG("Installed papyrus hook on EquipObject2 at {0:x} with replacement from address {0:x}",
                             loc_equip2TargetAddress, (void*)&EquipObject2);
            }
            else
            {
                ERROR("Failed to install papyrus hook on EquipObject2");
            }

            const uintptr_t loc_unequipTargetAddress = RE::Offset::ActorEquipManager::UnequipObject.address();
            _UnequipObject = (OriginalUnequipObject)loc_unequipTargetAddress;

            DetourTransactionBegin();
            DetourUpdateThread(GetCurrentThread());
            DetourAttach(&(PVOID&)_UnequipObject, (PBYTE)&UnequipObject);

            if (DetourTransactionCommit() == NO_ERROR)
            {
                LOG("Installed papyrus hook on UnequipObject at {0:x} with replacement from address {0:x}",
                             loc_unequipTargetAddress, (void*)&UnequipObject);
            }
            else
            {
                WARN("Failed to install papyrus hook on UnequipObject");
            }
            if (REL::Module::GetRuntime() != REL::Module::Runtime::SE) {
                 const uintptr_t loc_inventoryUIunequipTargetAddress =
                    REL::VariantOffset(0x0, 0x6ca610, 0x641720).address();
                _InventoryUIUnequipObject = (OriginalInventoryUIUnequipObject)loc_inventoryUIunequipTargetAddress;
                DetourTransactionBegin();
                DetourUpdateThread(GetCurrentThread());
                DetourAttach(&(PVOID&)_InventoryUIUnequipObject, (PBYTE)&InventoryUIUnequipObject);

                if (DetourTransactionCommit() == NO_ERROR) {
                    LOG("Installed papyrus hook on InventoryUIUnequipObject at {0:x} with replacement from address "
                        "{0:x}",
                        loc_inventoryUIunequipTargetAddress, (void*)&InventoryUIUnequipObject);
                } else {
                    WARN("Failed to install papyrus hook on InventoryUIUnequipObject");
                }
            }

        }
    }
} 
