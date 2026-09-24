#pragma once
#include <RE/Skyrim.h>
#include <detours/detours.h>
#include "DeviceReader.h"
#include "LibFunctions.h"
#include "Utils.h"

namespace DeviousDevices
{
    enum HiderSetting : uint8_t
    {
        sNoNakedNPCs        = 0,
        sBoundNakedNPCs     = 1,
        sAlwaysNakedNPCs    = 2
    };

    struct ForceStripSetting
    {
        int armorfilter         = 0xFFFFFFFF;
        int devicefilter        = 0x00000000;
    };

    struct ArmorSlot
    {
        const RE::TESObjectARMO*  armor;
        const uint32_t            slot;
    };

    class DeviceHiderManager
    {
    SINGLETONHEADER(DeviceHiderManager)
    public:
        void                    Setup();
        void                    Reload();
        void                    SetActorStripped(RE::Actor* a_actor, bool a_stripped, int a_armorfilter, int a_devicefilter);
        bool                    IsActorStripped(RE::Actor* a_actor);
        bool                    IsValidForHide(RE::TESObjectARMO* a_armor) const;
        void                    SyncSetting(std::vector<int> a_masks,HiderSetting a_setting);

    protected:
        bool _setup                     = false;
        RE::BGSKeyword* _kwnohide       = nullptr;
        RE::BGSKeyword* _kwlockable     = nullptr;
        RE::BGSKeyword* _kwplug         = nullptr;
        RE::BGSKeyword* _kwsos          = nullptr;
        RE::BGSKeyword* _contraption    = nullptr;
        bool           _DAVInstalled    = false;

        std::vector<RE::BGSKeyword*> _hidekeywords;
        std::vector<RE::BGSKeyword*> _nohidekeywords;

        mutable Spinlock        _SaveLock;
    private:
        std::vector<int>        RebuildSlotMask(RE::Actor* a_actor, std::vector<int> a_slotfilter);
        int                     FilterMask(RE::Actor* a_actor, int a_slotmask);
        const std::vector<int>& GetFilter() const;
        const HiderSetting&     GetSetting() const;
        inline bool             ProcessHider(RE::TESObjectARMO* a_armor, RE::Actor* a_actor) const;
        inline uint16_t         UpdateActors3D();
        bool                    CheckForceStrip(RE::TESObjectARMO* a_armor, RE::Actor* a_actor) const;
        bool                    CheckNPCArmor(RE::TESObjectARMO* a_armor, RE::Actor* a_actor) const;
        bool                    IsDAVInstalled() {return _DAVInstalled;}

        bool CheckHiderSlots(RE::TESObjectARMO* a_armor, uint8_t a_min, uint8_t a_max, const std::unordered_map<RE::TESObjectARMO*,uint32_t>& a_slots) const;

        std::vector<int>    _filter;
        HiderSetting        _setting;

        std::unordered_map<uint32_t,ForceStripSetting> _forcestrip;

        //=== copied from Dynamic Armor Variables ===
        //returns true if addon have passed race
        static bool HasRace(RE::TESObjectARMA* a_armorAddon, RE::TESRace* a_race);

        //render armor addon on actor (?)
        static void InitWornArmorAddon(RE::TESObjectARMA* a_armorAddon,RE::TESObjectARMO* a_armor,RE::BSTSmartPointer<RE::BipedAnim>* a_biped,RE::SEX a_sex);

        //called every once in the while by game to update 3d models on actor
        static void InitWornArmor(RE::TESObjectARMO* a_armor,RE::Actor* a_actor,RE::BSTSmartPointer<RE::BipedAnim>* a_biped);

        //update actor 3d
        static bool Update3D(RE::Actor* a_actor);

        //update actor serialy
        static void Update3DSafe(RE::Actor* a_actor);

        typedef void(*fInitWornArmorDAV)(RE::TESObjectARMO* a_armor,RE::Actor* a_actor,RE::BSTSmartPointer<RE::BipedAnim>* a_biped);
        static inline fInitWornArmorDAV InitWornArmorDAV;
    };

    inline void SyncSetting(PAPYRUSFUNCHANDLE,std::vector<int> a_slotfilter, int a_setting)
    {
        LOG("SyncSetting called")
        DeviceHiderManager::GetSingleton()->SyncSetting(a_slotfilter,(HiderSetting)a_setting);
    }

    inline void SetActorStripped(PAPYRUSFUNCHANDLE,RE::Actor* a_actor, bool a_stripped, int a_armorfilter, int a_devicefilter)
    {
        LOG("SetActorStripped called")
        DeviceHiderManager::GetSingleton()->SetActorStripped(a_actor,a_stripped,a_armorfilter,a_devicefilter);
    }

    inline bool IsActorStripped(PAPYRUSFUNCHANDLE,RE::Actor* a_actor)
    {
        LOG("IsActorStripped called")
        return DeviceHiderManager::GetSingleton()->IsActorStripped(a_actor);
    }
}