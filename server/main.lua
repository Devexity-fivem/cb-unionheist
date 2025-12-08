local vaultBlown = false
local blownCageDoors = {}
local lootResults = {}
local lootStolen = {}
local cageRoomBlown = {}
local securityHacked = {}
local robbedGuards = {}
local pendingVaultPayment = {}
local pendingCagePayment = {}

local function isWithinDistance(src, coords, maxDistance)
    if not coords then return false end
    local playerCoords = GetPlayerCoords(src)
    if not playerCoords then return false end
    local dx = playerCoords.x - coords.x
    local dy = playerCoords.y - coords.y
    local dz = playerCoords.z - coords.z
    return (dx * dx + dy * dy + dz * dz) <= (maxDistance * maxDistance)
end

function CreateLootBasedOnChance()
    lootResults = {}
    for k, v in pairs(Config.Loot) do
        local roll = math.random(100)
        local cumulativeChance = 0
        local selectedModel = nil
        for _, modelData in ipairs(v.models) do
            cumulativeChance = cumulativeChance + modelData.chance
            if roll <= cumulativeChance then
                selectedModel = modelData.model
                break
            end
        end
        lootResults[k] = {
            coords = v.coords,
            size = v.size,
            cage = v.cage,
            model = selectedModel
        }
    end
end

function ResetHeistLoop()
    local minutes = Config.ResetTime
    Wait(1000 * 60 * minutes)
    vaultBlown = false
    blownCageDoors = {}
    lootResults = {}
    lootStolen = {}
    cageRoomBlown = {}
    securityHacked = {}
    robbedGuards = {}
    pendingVaultPayment = {}
    pendingCagePayment = {}
    TriggerClientEvent('cb-unionheist:client:ResetHeist', -1)
    CreateLootBasedOnChance()
end

lib.callback.register('cb-unionheist:server:CheckPoliceCount', function(source)
    local policeCount = 0
    local players = exports.qbx_core:GetQBPlayers()
    for _, player in pairs(players) do
        if player.PlayerData.job.type == "leo" and player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end
    return policeCount >= Config.MinimumPolice
end)

RegisterNetEvent('cb-unionheist:server:BlowVaultDoor', function()
    local allSecurityHacked = true
    for k, v in pairs(Config.HackLocations) do
        if securityHacked[k] == nil then
            allSecurityHacked = false
            break
        end
    end
    if allSecurityHacked and pendingVaultPayment[source] then
        vaultBlown = true
        pendingVaultPayment[source] = nil
        TriggerClientEvent('cb-unionheist:client:BlowVaultDoor', -1)
        ResetHeistLoop()
    end
end)

RegisterNetEvent('cb-unionheist:server:FailedSecurityHack', function(hack)
    if not RemoveItem(source, Config.HackLocations[hack].required.item, Config.HackLocations[hack].required.amount) then
        print(string.format("Error removing %.0fx %s to Player %.0f", Config.HackLocations[hack].required.amount, Config.HackLocations[hack].required.item, source))
    end
end)

lib.callback.register('cb-unionheist:server:IsGuardRobbed', function(source, guard)
    if vaultBlown then
        if robbedGuards[guard] == nil then
            return false
        else
            return true
        end
    end
end)

RegisterNetEvent('cb-unionheist:server:RobGuard', function(guard)
    local src = source
    local guardConfig = Config.Guards[guard]
    if not vaultBlown or not guardConfig or not guardConfig.rewards then
        return
    end
    if robbedGuards[guard] then
        return
    end
    if not isWithinDistance(src, guardConfig.coords, 10.0) then
        return
    end
    robbedGuards[guard] = true
    if guardConfig and guardConfig.rewards then
        local rewardsToGive = math.random(guardConfig.rewardsToGive.min, guardConfig.rewardsToGive.max)
        local totalChance = 0
        for _, reward in ipairs(guardConfig.rewards) do
            totalChance = totalChance + reward.chance
        end
        for i = 1, rewardsToGive do
            local randomPick = math.random(1, totalChance)
            local cumulativeChance = 0
            for _, reward in ipairs(guardConfig.rewards) do
                cumulativeChance = cumulativeChance + reward.chance
                if randomPick <= cumulativeChance then
                    local amount = math.random(reward.minAmount, reward.maxAmount)
                    if not AddItem(source, reward.item, amount) then
                        print(string.format("Error adding %.0fx %s to Player %.0f", amount, reward.item, source))
                    else
                        TriggerClientEvent('cb-unionheist:client:RobGuard', -1, guard)
                    end
                    break
                end
            end
        end
    end
end)

RegisterNetEvent('cb-unionheist:server:LootStolen', function(key)
    local src = source
    local rewardConfig
    local newModel
    if vaultBlown then
        for k, v in pairs(Config.Loot) do
            if key == k then
                for lootModel, rewards in pairs(Config.LootRewards) do
                    if lootModel == lootResults[k].model then
                        rewardConfig = rewards
                    end
                end
                if rewardConfig then
                    for _, reward in pairs(rewardConfig) do
                        if math.random(100) <= reward.chance then
                            local rewardAmount = math.random(reward.min, reward.max)
                            if lootStolen[key] == nil then
                                if not AddItem(src, reward.item, rewardAmount) then
                                    return
                                else
                                    lootStolen[key] = true
                                    TriggerClientEvent('cb-unionheist:client:SyncLoot', -1, k, lootResults[k].model)
                                    for _, modelData in pairs(Config.Loot[k].models) do
                                        if modelData.model == lootResults[k].model then
                                            newModel = modelData.newModel
                                        end
                                    end
                                    lootResults[k].model = newModel
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('cb-unionheist:server:BlowCageDoor', function(cage)
    local src = source
    local cageConfig = Config.DoorLocations[cage]
    if not cageConfig or blownCageDoors[cage] or not vaultBlown then
        return
    end
    local hasPayment = pendingCagePayment[src] and pendingCagePayment[src][cage]
    if not hasPayment then
        return
    end
    if not isWithinDistance(src, cageConfig.coords, 30.0) then
        return
    end
    blownCageDoors[cage] = true
    cageRoomBlown[cageConfig.cage] = true
    pendingCagePayment[src][cage] = nil
    TriggerClientEvent('cb-unionheist:client:BlowCageDoor', -1, cage)
end)

RegisterNetEvent('cb-unionheist:server:SecurityHack', function(hack)
    if HasItem(source, Config.HackLocations[hack].required.item, Config.HackLocations[hack].required.amount) then
        if RemoveItem(source, Config.HackLocations[hack].required.item, Config.HackLocations[hack].required.amount) then
            securityHacked[hack] = true
            TriggerClientEvent('cb-unionheist:client:SecurityHacked', -1, hack)
        end
    end
end)

lib.callback.register('cb-unionheist:server:IsVaultBlown', function(source)
    return vaultBlown
end)

lib.callback.register('cb-unionheist:server:RemoveVaultItem', function(source)
    if HasItem(source, Config.Vault.required.item, Config.Vault.required.amount) then
        local allSecurityHacked = true
        for k, v in pairs(Config.HackLocations) do
            if securityHacked[k] == nil then
                allSecurityHacked = false
                break
            end
        end
        if allSecurityHacked then
            if not RemoveItem(source, Config.Vault.required.item, Config.Vault.required.amount) then
                print(string.format("Error removing %.0fx %s from Player %.0f inventory", Config.Vault.required.amount, Config.Vault.required.item, source))
                return false
            else
                pendingVaultPayment[source] = true
                return true
            end
        end
        return false
    else
        return false
    end
end)

lib.callback.register('cb-unionheist:server:RemoveCageItem', function(source, cage)
    local cageConfig = Config.DoorLocations[cage]
    if not cageConfig then
        return false
    end
    if HasItem(source, cageConfig.required.item, cageConfig.required.amount) then
        if not RemoveItem(source, cageConfig.required.item, cageConfig.required.amount) then
            print(string.format("Error removing %.0fx %s from Player %.0f inventory", cageConfig.required.amount, cageConfig.required.item, source))
            return false
        else
            pendingCagePayment[source] = pendingCagePayment[source] or {}
            pendingCagePayment[source][cage] = true
            return true
        end
    else
        return false
    end
end)

lib.callback.register('cb-unionheist:server:GetSecurityHacks', function(source)
    return securityHacked
end)

lib.callback.register('cb-unionheist:server:IsSecurityHacked', function(source)
    for k, v in pairs(Config.HackLocations) do
        if not securityHacked[k] then
            return false
        end
    end
    return true
end)

lib.callback.register('cb-unionheist:server:IsAllowedToStealLoot', function(source, cage, loot)
    local lootConfig = Config.Loot[loot]
    if not lootConfig then
        return false
    end
    local cageGroup = lootConfig.cage
    return vaultBlown and (cageRoomBlown[cageGroup] == true) and (lootStolen[loot] == nil)
end)

lib.callback.register('cb-unionheist:server:IsCageBlown', function(source, cage)
    return blownCageDoors[cage] or false
end)

lib.callback.register('cb-unionheist:server:GetBlownCages', function(source)
    return blownCageDoors or false
end)

lib.callback.register('cb-unionheist:server:GetLoot', function(source)
    return lootResults
end)

CreateLootBasedOnChance()
