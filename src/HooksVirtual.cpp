#include "HooksVirtual.h"
#include "LibFunctions.h"
#include "MovementManager.h"

SINGLETONBODY(DeviousDevices::HooksVirtual)

void DeviousDevices::HooksVirtual::Setup()
{
    if (!_init)
    {
        // Vtable of MovementHandler
        REL::Relocation<std::uintptr_t> vtbl_MovementHandler{RELOCATION_ID(263056, 208715).address()};
        ProcessButton_old = vtbl_MovementHandler.write_vfunc(0x04, ProcessButton);
        ProcessThumbstick_old = vtbl_MovementHandler.write_vfunc(0x02, ProcessThumbstick);
        
        // Vtable of AutoMoveHandler - 1418B6EA0 - xxxx/208725
        REL::Relocation<std::uintptr_t> vtbl_MovementHandlerAM{RELOCATION_ID(263061, 208725).address()};
        ProcessButtonAM_old = vtbl_MovementHandlerAM.write_vfunc(0x04, ProcessButtonAM);
        REL::Relocation<std::uintptr_t> vtbl_player{RE::PlayerCharacter::VTABLE[0]};
        
        
        DrawWeaponMagicHands_old = vtbl_player.write_vfunc(REL::Module::GetRuntime() != REL::Module::Runtime::VR ? 0x0A6 : 0x0A8, DrawWeaponMagicHands);

        _init = true;
    }
}


void DeviousDevices::HooksVirtual::ProcessButton(RE::MovementHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data)
{
    LOG("HooksVirtual::ProcessButton() called")
    ProcessButton_old(a_this,a_event,a_data);

    MovementManager::GetSingleton()->ManagePlayerInput(a_data);
}

void DeviousDevices::HooksVirtual::ProcessButtonAM(RE::AutoMoveHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data)
{
    LOG("HooksVirtual::ProcessButton() called")
    ProcessButtonAM_old(a_this,a_event,a_data);

    MovementManager::GetSingleton()->ManagePlayerInput(a_data);
}

void DeviousDevices::HooksVirtual::ProcessThumbstick(RE::MovementHandler* a_this, RE::ThumbstickEvent* a_event, RE::PlayerControlsData* a_data)
{
    ProcessThumbstick_old(a_this,a_event,a_data);

    if (a_event->GetIDCode() != 11)
    {
        // This is not left analogue stick. Exit
        return;
    }

    MovementManager::GetSingleton()->ManagePlayerInput(a_data);
}

void DeviousDevices::HooksVirtual::DrawWeaponMagicHands(RE::PlayerCharacter* a_this, bool a_draw)
{
    LOG("HooksVirtual::DrawWeaponMagicHands() called")
    if (a_draw && MovementManager::GetSingleton()->ManageWeapons(a_this))
    {
        return;
    }
    DrawWeaponMagicHands_old(a_this,a_draw);
}
