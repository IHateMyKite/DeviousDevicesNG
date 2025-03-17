#include "Utils.h"

using namespace RE;

void DeviousDevices::Utils::ForEachReferenceInRange(
    RE::TESObjectREFR* origin, float radius,
    std::function<RE::BSContainer::ForEachResult(RE::TESObjectREFR& ref)> callback) {
    if (origin && radius > 0.0f) {
        const auto originPos = origin->GetPosition();
        auto* tesSingleton = RE::TES::GetSingleton();
        auto* interiorCell = tesSingleton->interiorCell;
        if (interiorCell) {
            interiorCell->ForEachReferenceInRange(originPos, radius,
                                                  [&](TESObjectREFR& a_ref) { return callback(a_ref); });
        } else {
            if (const auto gridLength = tesSingleton->gridCells ? tesSingleton->gridCells->length : 0; gridLength > 0) {
                const float yPlus = originPos.y + radius;
                const float yMinus = originPos.y - radius;
                const float xPlus = originPos.x + radius;
                const float xMinus = originPos.x - radius;

                std::uint32_t x = 0;
                do {
                    std::uint32_t y = 0;
                    do {
                        if (const auto cell = tesSingleton->gridCells->GetCell(x, y); cell && cell->IsAttached()) {
                            if (const auto cellCoords = cell->GetCoordinates(); cellCoords) {
                                const NiPoint2 worldPos{cellCoords->worldX, cellCoords->worldY};
                                if (worldPos.x < xPlus && (worldPos.x + 4096.0f) > xMinus && worldPos.y < yPlus &&
                                    (worldPos.y + 4096.0f) > yMinus) {
                                    cell->ForEachReferenceInRange(
                                        originPos, radius, [&](TESObjectREFR& a_ref) { return callback(a_ref); });
                                }
                            }
                        }
                        ++y;
                    } while (y < gridLength);
                    ++x;
                } while (x < gridLength);
            }
        }
    } else {
        RE::TES::GetSingleton()->ForEachReference([&](RE::TESObjectREFR& a_ref) { return callback(a_ref); });
    }
}

void DeviousDevices::Utils::ForEachActorInRange(float a_range, std::function<void(RE::Actor* a_actor)> a_callback) {
    const auto playerPos = RE::PlayerCharacter::GetSingleton()->GetPosition();

    for (auto actorHandle : RE::ProcessLists::GetSingleton()->highActorHandles) {
        if (auto actorPtr = actorHandle.get()) {
            if (auto actor = actorPtr.get()) {
                if (playerPos.GetDistance(actor->GetPosition()) <= a_range) {
                    a_callback(actor);
                }
            }
        }
    }
}

RE::NiNode* DeviousDevices::Utils::NodeByName(RE::NiAVObject* a_root, const RE::BSFixedString& a_name) {
    const auto obj = a_root ? a_root->GetObjectByName(a_name) : nullptr;
    return obj ? obj->AsNode() : nullptr;
}
