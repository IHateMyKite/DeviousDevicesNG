#pragma once

namespace DeviousDevices
{

    class HooksVirtual
    {
    SINGLETONHEADER(HooksVirtual)
    public:
        void Setup();
        static void ProcessButton(RE::MovementHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data);
        static void ProcessButtonAM(RE::AutoMoveHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data);
        static void ProcessThumbstick(RE::MovementHandler* a_this, RE::ThumbstickEvent* a_event, RE::PlayerControlsData* a_data);
        static void DrawWeaponMagicHands(RE::PlayerCharacter* a_this, bool a_draw);
    private:
        bool _init = false;
    private:
        inline static REL::Relocation<decltype(ProcessButton)>      ProcessButton_old;
        inline static REL::Relocation<decltype(ProcessButtonAM)>    ProcessButtonAM_old;
        inline static REL::Relocation<decltype(ProcessThumbstick)>  ProcessThumbstick_old;
        inline static REL::Relocation<decltype(DrawWeaponMagicHands)>  DrawWeaponMagicHands_old;
        bool _PlayerForceWalk       = false;
        bool _PlayerDisableDraw     = false;
    };
}