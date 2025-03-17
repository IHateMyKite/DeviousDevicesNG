#include "NodeHider.h"
#include "LibFunctions.h"
#include "Hider.h"
#include "Utils.h"


SINGLETONBODY(DeviousDevices::NodeHider)

void DeviousDevices::NodeHider::Setup()
{
    if (!_installed)
    {
        DEBUG("NodeHider::Setup() - called")
        _WeaponNodes = ConfigManager::GetSingleton()->GetArrayText("NodeHider.asWeaponNodes",false);

        _ArmNodes       = ConfigManager::GetSingleton()->GetArray<std::string>("NodeHider.asArmNodes");
        _HandNodes      = ConfigManager::GetSingleton()->GetArray<std::string>("NodeHider.asHandNodes");
        _FingerNodes    = ConfigManager::GetSingleton()->GetArray<std::string>("NodeHider.asFingerNodes");

        _ArmHiddingKeywords     = ConfigManager::GetSingleton()->GetArrayText("NodeHider.asArmHiddingKeywords",false);
        _HandHiddingKeywords    = ConfigManager::GetSingleton()->GetArrayText("NodeHider.asHandHiddingKeywords",false);
        _FingerHiddingKeywords  = ConfigManager::GetSingleton()->GetArrayText("NodeHider.asFingerHiddingKeywords",false);

        _HideFirstPerson = ConfigManager::GetSingleton()->GetVariable<bool>("NodeHider.bHideArmsFirstPerson",true);

        DEBUG("NodeHider::Setup() - Hidding nodes")
        for (auto&& it : _ArmNodes) DEBUG("Arm node: {}",it)
        for (auto&& it : _HandNodes) DEBUG("Hand node: {}",it)
        for (auto&& it : _FingerNodes) DEBUG("Finger node: {}",it)
        DEBUG("NodeHider::Setup() - Hidding keywords")
        for (auto&& it : _ArmHiddingKeywords) DEBUG("Arm kw: {}",it)
        for (auto&& it : _HandHiddingKeywords) DEBUG("Hand kw: {}",it)
        for (auto&& it : _FingerHiddingKeywords) DEBUG("Finger kw: {}",it)

        _installed = true;
        DEBUG("NodeHider::Setup() - complete")
    }
}

std::shared_ptr<DeviousDevices::NodeHider::ActorState> DeviousDevices::NodeHider::GetActorState(RE::Actor* a_actor) {
    auto [it, inserted] = _ActorStates.try_emplace(a_actor->GetHandle().native_handle());
    if (inserted)
    {
        it->second = std::make_shared<ActorState>(a_actor);
        LOG("NodeHider::GetActorState({}) - Actor registered",a_actor ? a_actor->GetName() : "NONE")
    }
    return it->second;
}

void DeviousDevices::NodeHider::HideArmNodes(RE::Actor* a_actor, HidderState& a_state, HiddenNodes& a_hidden,
                                             std::vector<std::string> a_nodes) {
    if (a_actor == nullptr) return;

    if (a_state == HidderState::sHidden) return;

    auto thirdPersonNode = a_actor->Get3D(0);
    if (thirdPersonNode == nullptr) return;

    auto firstPersonNode = _HideFirstPerson ? a_actor->Get3D(1) : nullptr;

    LOG("NodeHider::HideArmNodes({}) called",a_actor->GetName())

    for (const auto& it : a_nodes)
    {
        if (auto loc_node = Utils::NodeByName(thirdPersonNode, it))
        {
            if (a_hidden.try_emplace(NodeKey{loc_node->name, false}, loc_node).second)
            {
                loc_node->local.scale = 0.002f;
                LOG("NodeHider::HideArmNodes - Third person node {} hidden",it)
            }
        }
        else ERROR("NodeHider::HideArmNodes - Cant find third person node {}",it)

        if (firstPersonNode)
        {
            if (auto loc_node = Utils::NodeByName(firstPersonNode, it))
            {
                if (a_hidden.try_emplace(NodeKey{loc_node->name, true}, loc_node).second)
                {
                    loc_node->local.scale = 0.002f;
                    LOG("NodeHider::HideArmNodes - First person node {} hidden",it)
                }
            }
            else ERROR("NodeHider::HideArmNodes - Cant find first person node {}",it)
        }
    }

    a_state = HidderState::sHidden;
}

void DeviousDevices::NodeHider::ShowArmNodes(RE::Actor* a_actor, HidderState& a_state, HiddenNodes& a_hidden, std::vector<std::string> a_nodes)
{
    if (a_actor == nullptr) return;

    if (a_state == HidderState::sShown) return;

    auto thirdPersonNode = a_actor->Get3D(0);
    if (thirdPersonNode == nullptr) return;

    auto firstPersonNode = _HideFirstPerson ? a_actor->Get3D(1) : nullptr;

    LOG("NodeHider::ShowArmNodes({}) called",a_actor->GetName())

    for (const auto& it : a_nodes)
    {
        if (auto loc_node = Utils::NodeByName(thirdPersonNode, it))
        {
            if (auto loc_hidden = a_hidden.extract({loc_node->name, false}))
            {
                loc_node->local.scale = loc_hidden.mapped().prevScale;
                LOG("NodeHider::ShowArmNode - Third person node {} shown",it)
            }
        }
        else ERROR("NodeHider::ShowArmNodes - Cant find third person node {}",it)

        if (firstPersonNode)
        {
            if (auto loc_node = Utils::NodeByName(firstPersonNode, it))
            {
                if (auto loc_hidden = a_hidden.extract({loc_node->name, true}))
                {
                    loc_node->local.scale = loc_hidden.mapped().prevScale;
                    LOG("NodeHider::ShowArmNode - First person node {} shown",it)
                }
            }
            else ERROR("NodeHider::ShowArmNodes - Cant find first person node {}",it)
        }
    }

    a_state = HidderState::sShown;
}

void DeviousDevices::NodeHider::UpdateArms(RE::Actor* a_actor, ActorState& a_state)
{
    if (a_actor == nullptr)
    {
        ERROR("NodeHider::UpdateArms() - Actor is none")
        return;
    }

    //LOG("NodeHider::UpdateArms({}) called",a_actor->GetName())

    // Arms
    {
        const auto loc_hidearms = std::find_if(_ArmHiddingKeywords.begin(),_ArmHiddingKeywords.end(),[a_actor](const std::string& a_kw)
        {
            return LibFunctions::GetSingleton()->WornHasKeyword(a_actor,a_kw);
        });
        if (loc_hidearms != _ArmHiddingKeywords.end())
            HideArmNodes(a_actor, a_state.armState, a_state.hiddenNodes, _ArmNodes);
        else
            ShowArmNodes(a_actor, a_state.armState, a_state.hiddenNodes, _ArmNodes);
    }

    // Hands
    {
        const auto loc_hidehands = std::find_if(_HandHiddingKeywords.begin(),_HandHiddingKeywords.end(),[a_actor](const std::string& a_kw)
        {
            return LibFunctions::GetSingleton()->WornHasKeyword(a_actor,a_kw);
        });
        if (loc_hidehands != _HandHiddingKeywords.end())
            HideArmNodes(a_actor, a_state.handState, a_state.hiddenNodes, _HandNodes);
        else
            ShowArmNodes(a_actor, a_state.handState, a_state.hiddenNodes, _HandNodes);
    }

    // Fingers
    {
        const auto loc_hidefingers = std::find_if(_FingerHiddingKeywords.begin(),_FingerHiddingKeywords.end(),[a_actor](const std::string& a_kw)
        {
            return LibFunctions::GetSingleton()->WornHasKeyword(a_actor,a_kw);
        });
        if (loc_hidefingers != _FingerHiddingKeywords.end())
            HideArmNodes(a_actor, a_state.fingerState, a_state.hiddenNodes, _FingerNodes);
        else
            ShowArmNodes(a_actor, a_state.fingerState, a_state.hiddenNodes, _FingerNodes);
    }
}

void DeviousDevices::NodeHider::UpdateWeapons(RE::Actor* a_actor, ActorState& a_state)
{
    if (a_actor == nullptr) return;

    if (ShouldHideWeapons(a_actor)) HideWeapons(a_actor, a_state);
    else ShowWeapons(a_actor, a_state);
}

void DeviousDevices::NodeHider::UpdatePlayer(RE::Actor* a_actor)
{
    UniqueLock lock(SaveLock);

    if (a_actor == nullptr) return;
    static bool loc_hidearms = ConfigManager::GetSingleton()->GetVariable<bool>("NodeHider.bHideArms",false);

    auto loc_state = GetActorState(a_actor);
    if (loc_hidearms)
    {
        UpdateArms(a_actor, *loc_state);
    }
    UpdateWeapons(a_actor, *loc_state);
}

void DeviousDevices::NodeHider::HideWeapons(RE::Actor* a_actor, ActorState& a_state)
{
    if (a_actor == nullptr) return;

    // if (a_state.weaponState == HidderState::sHidden) return;

    for (auto&& it : _WeaponNodes)
    {
        AddHideNode(a_actor,a_state.hiddenNodes,it);
    }

    a_state.weaponState = HidderState::sHidden;

    LOG("NodeHider::HideWeapons({}) - Weapon nodes hidden",a_actor->GetName())
}

void DeviousDevices::NodeHider::ShowWeapons(RE::Actor* a_actor, ActorState& a_state)
{
    if (a_actor == nullptr) return;

    if (a_state.weaponState == HidderState::sShown) return;

    for (auto&& it : _WeaponNodes)
    {
        RemoveHideNode(a_actor,a_state.hiddenNodes,it);
    }

    a_state.weaponState = HidderState::sShown;

    LOG("NodeHider::ShowWeapons({}) - Weapon nodes shown",a_actor->GetName())
}

void DeviousDevices::NodeHider::UpdateTimed(RE::Actor* a_actor)
{
    UniqueLock lock(SaveLock);
    if (!a_actor) return;

    //LOG("NodeHider::UpdateTimed({}) called", a_actor ? a_actor->GetName() : "NONE")

    auto loc_refBase = a_actor->GetActorBase();
    if(a_actor->IsDisabled() || !a_actor->Is3DLoaded() || !(a_actor->Is(RE::FormType::NPC) || (loc_refBase && loc_refBase->Is(RE::FormType::NPC))))
    {
        LOG("NodeHider::UpdateTimed({}) - Actor is invalid",a_actor ? a_actor->GetName() : "NONE")
        _ActorStates.erase(a_actor->GetHandle().native_handle());
        return;
    }

    auto loc_state = GetActorState(a_actor);

    loc_state->updateHandle.lastUpdateFrame = _UpdateCounter;
    loc_state->updateHandle.elapsedFrames++;

    static bool loc_hidearms = ConfigManager::GetSingleton()->GetVariable<bool>("NodeHider.bHideArms",false);

    static const int loc_updatetime = ConfigManager::GetSingleton()->GetVariable<int>("NodeHider.iNPCUpdateTime",60);

    if (loc_state->updateHandle.elapsedFrames >= loc_updatetime)
    {
        loc_state->updateHandle.elapsedFrames -= loc_updatetime;
        UpdateWeapons(a_actor, *loc_state);
        if (loc_hidearms) UpdateArms(a_actor, *loc_state);
    }
}

void DeviousDevices::NodeHider::Reload()
{
    UniqueLock lock(SaveLock);
    _ActorStates.clear();
}

void DeviousDevices::NodeHider::CleanUnusedActors()
{
    UniqueLock lock(SaveLock);

    std::erase_if(_ActorStates, [=](const auto& it){
        return (it.second->updateHandle.lastUpdateFrame + 120) < _UpdateCounter;
    });
}

void DeviousDevices::NodeHider::IncUpdateCounter()
{
    _UpdateCounter++;
}

bool DeviousDevices::NodeHider::ActorIsValid(RE::Actor* a_actor) const
{
    if (a_actor == nullptr) return false;

    if (a_actor->IsDead() || !a_actor->Is3DLoaded() || a_actor->IsDisabled())
    {
        return false;
    }
    return true;
}

bool DeviousDevices::NodeHider::ShouldHideWeapons(RE::Actor* a_actor) const
{
    if (!ActorIsValid(a_actor)) return false;
    return LibFunctions::GetSingleton()->IsAnimating(a_actor) || (LibFunctions::GetSingleton()->IsBound(a_actor));
}

bool DeviousDevices::NodeHider::AddHideNode(RE::Actor* a_actor, HiddenNodes& a_hidden, std::string a_nodename)
{
    if (a_actor == nullptr || !a_actor->Is3DLoaded()) return false;

    auto loc_actor = a_actor->Get3D(false);
    if (loc_actor == nullptr) return false;

    auto loc_node = Utils::NodeByName(loc_actor, a_nodename);
    if (loc_node != nullptr && loc_node->local.scale >= 0.5f)
    {
        if(a_hidden.try_emplace(NodeKey{loc_node->name, false}, loc_node).second)
        {
            loc_node->local.scale = 0.002f;
            return true;
        }
    }
    return false;
}

bool DeviousDevices::NodeHider::RemoveHideNode(RE::Actor* a_actor, HiddenNodes& a_hidden, std::string a_nodename)
{
    if (a_actor == nullptr || !a_actor->Is3DLoaded()) return false;

    auto loc_actor = a_actor->Get3D(false);
    if (loc_actor == nullptr) return false;

    auto loc_node = Utils::NodeByName(loc_actor, a_nodename);
    if (loc_node != nullptr)
    {
        auto loc_hidden = a_hidden.extract(NodeKey{loc_node->name, false});
        if (loc_hidden)
        {
            loc_node->AsNode()->local.scale = loc_hidden.mapped().prevScale;
            return true;
        }
    }
    return false;
}

DeviousDevices::NodeHider::ActorState::~ActorState()
{
    auto loc_actor = actorHandle.get();
    if (!loc_actor) return;

    auto firstPerson = loc_actor->Get3D(true);
    auto thirdPerson = loc_actor->Get3D(false);

    for (auto&& [key,it] : hiddenNodes)
    {
        if (auto loc_node = Utils::NodeByName(key.firstPerson ? firstPerson : thirdPerson, key.nodeName))
            loc_node->local.scale = it.prevScale;
    }
}
