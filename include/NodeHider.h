#pragma once

#include "Utils.h"

namespace DeviousDevices
{
    //for implementing this, I used https://github.com/ArranzCNL/ImprovedCameraSE-NG as reference which also hides arms using nodes
    class NodeHider
    {
    SINGLETONHEADER(NodeHider)
    public:
        enum HidderState : uint8_t
        {
            sShown  = 0,
            sHidden = 1
        };

        struct NodeKey
        {
            RE::BSFixedString nodeName;
            bool firstPerson;
        };

        struct NodeKeyCompare
        {
            bool operator()(const NodeKey& lhs, const NodeKey& rhs) const
            {
                return (lhs.firstPerson < rhs.firstPerson) && (lhs.nodeName.front() < rhs.nodeName.front());
            }
        };

        struct HiddenNode
        {
            HiddenNode(RE::NiNode* a_node) :
                nodeName(a_node->name),
                prevScale(a_node->local.scale) {}
            RE::BSFixedString nodeName;
            float prevScale;
        };

        using HiddenNodes = std::map<NodeKey, HiddenNode, NodeKeyCompare>;

        struct ActorState
        {
            ActorState(RE::Actor* a_actor)
            {
                actorHandle = a_actor->GetHandle();
            }
            ~ActorState();

            RE::ActorHandle actorHandle;
            HiddenNodes hiddenNodes;
            HidderState armState;
            HidderState handState;
            HidderState fingerState;
            HidderState weaponState;
            UpdateHandle updateHandle;
        };

        std::shared_ptr<ActorState> GetActorState(RE::Actor* a_actor);

        void HideArmNodes(RE::Actor* a_actor,HidderState& a_state,HiddenNodes& a_hidden,std::vector<std::string> a_nodes);
        void ShowArmNodes(RE::Actor* a_actor,HidderState& a_state,HiddenNodes& a_hidden,std::vector<std::string> a_nodes);
        void UpdateArms(RE::Actor* a_actor,ActorState& a_state);

        //https://wiki.beyondskyrim.org/wiki/Arcane_University:Nifskope_Weapons_Setup
        void HideWeapons(RE::Actor* a_actor,ActorState& a_state);
        void ShowWeapons(RE::Actor* a_actor,ActorState& a_state);
        void UpdateWeapons(RE::Actor* a_actor,ActorState& a_state);
        void UpdatePlayer(RE::Actor* a_actor);
        void Setup();
        //void Update();
        void UpdateTimed(RE::Actor* a_actor);
        void Reload();

        void CleanUnusedActors();
        void IncUpdateCounter();

        Spinlock SaveLock;
    protected:
        bool ActorIsValid(RE::Actor* a_actor) const;
        bool ShouldHideWeapons(RE::Actor* a_actor) const;
        bool AddHideNode(RE::Actor* a_actor, HiddenNodes& a_hidden, std::string a_nodename);
        bool RemoveHideNode(RE::Actor* a_actor, HiddenNodes& a_hidden, std::string a_nodename);
    private:
        bool _installed = false;
        std::vector<uint32_t>       _lastupdatestack;
        std::vector<std::string>    _WeaponNodes;
        std::vector<std::string>    _ArmNodes;
        std::vector<std::string>    _HandNodes;
        std::vector<std::string>    _FingerNodes;
        std::unordered_map<uint32_t, std::shared_ptr<ActorState>> _ActorStates;
        uint64_t                    _UpdateCounter = 0UL;
        std::vector<std::string>    _ArmHiddingKeywords;
        std::vector<std::string>    _HandHiddingKeywords;
        std::vector<std::string>    _FingerHiddingKeywords;
        bool                        _HideFirstPerson;
    };

    inline void HideWeapons(PAPYRUSFUNCHANDLE, RE::Actor* a_actor) {
        LOG("HideWeapons called")
        UniqueLock lock( NodeHider::GetSingleton()->SaveLock);
        auto loc_state = NodeHider::GetSingleton()->GetActorState(a_actor);
        NodeHider::GetSingleton()->HideWeapons(a_actor, *loc_state);
    }

    inline void ShowWeapons(PAPYRUSFUNCHANDLE, RE::Actor* a_actor) {
        LOG("ShowWeapons called")
        UniqueLock lock(NodeHider::GetSingleton()->SaveLock);
        auto loc_state = NodeHider::GetSingleton()->GetActorState(a_actor);
        NodeHider::GetSingleton()->ShowWeapons(a_actor, *loc_state);
    }
}