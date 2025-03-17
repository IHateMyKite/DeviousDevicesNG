#pragma once

namespace DeviousDevices {
    namespace Utils {
        void ForEachReferenceInRange(
            RE::TESObjectREFR* origin, float radius,
            std::function<RE::BSContainer::ForEachResult(RE::TESObjectREFR& ref)> callback);


        void ForEachActorInRange(float a_range,
                                    std::function<void(RE::Actor* a_actor)> callback);

        RE::NiNode* NodeByName(RE::NiAVObject* a_root, const RE::BSFixedString& a_node);
    }  // namespace Utils

    class Spinlock
    {
    public:
        void Lock()
        {
            while (_lock.exchange(true))
            {
                ;
            }
        }
        void Unlock()
        {
            _lock.store(false);
        }
    private:
        mutable std::atomic<bool> _lock   = false;
    };

    class UniqueLock
    {
    public:
        UniqueLock(Spinlock& a_lock)
        {
            _lock = &a_lock;
            _lock->Lock();
        }
        ~UniqueLock()
        {
            _lock->Unlock();
        }
        void Unlock()
        {
            _lock->Unlock();
        }
    private:
        mutable Spinlock* _lock;
    };
}  // namespace DeviousDevices