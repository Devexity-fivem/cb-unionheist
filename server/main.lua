local vaultBlown = false
local blownCageDoors = {}
local lootResults = {}
local lootStolen = {}
local cageRoomBlown = {}
local securityHacked = {}
local robbedGuards = {}

function CreateLootBasedOnChance()
    lootResults = {} -- Initialize lootResults table
    for k, v in pairs(Config.Loot) do
        local roll = math.random(100) -- Roll a random number between 1 and 100
        local cumulativeChance = 0 -- Initialize cumulative chance
        local selectedModel = nil -- Default to no model

        -- Determine which model (if any) to spawn
        for _, modelData in ipairs(v.models) do
            cumulativeChance = cumulativeChance + modelData.chance
            if roll <= cumulativeChance then
                selectedModel = modelData.model
                break
            end
        end

        -- Add the result for this location, using the key from Config.Loot
        lootResults[k] = { -- Ensure the key in lootResults matches the Config.Loot key
            coords = v.coords,
            size = v.size,
            cage = v.cage, -- Include cage if needed
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
    securityHacked = {}
    robbedGuards = {}
    TriggerClientEvent('cb-unionheist:client:ResetHeist', -1)
end

RegisterNetEvent('cb-unionheist:server:BlowVaultDoor', function()
    local allSecurityHacked = true
    for k, v in pairs(Config.HackLocations) do
        if securityHacked[k] == nil then
            allSecurityHacked = false
            break
        end
    end
    if allSecurityHacked then
        vaultBlown = true
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
    local guardConfig = Config.Guards[guard]
    if guardConfig and guardConfig.rewards then
        -- Number of rewards to give, randomized within the specified range
        local rewardsToGive = math.random(guardConfig.rewardsToGive.min, guardConfig.rewardsToGive.max)

        -- Calculate the total chance for cumulative logic
        local totalChance = 0
        for _, reward in ipairs(guardConfig.rewards) do
            totalChance = totalChance + reward.chance
        end

        -- Loop to give the randomized number of rewards
        for i = 1, rewardsToGive do
            local randomPick = math.random(1, totalChance) -- Random number between 1 and totalChance
            local cumulativeChance = 0

            -- Determine which reward corresponds to the random number
            for _, reward in ipairs(guardConfig.rewards) do
                cumulativeChance = cumulativeChance + reward.chance
                if randomPick <= cumulativeChance then
                    local amount = math.random(reward.minAmount, reward.maxAmount)
                    if not AddItem(source, reward.item, amount) then
                        print(string.format("Error adding %.0fx %s to Player %.0f", amount, reward.item, source))
                    else
                        robbedGuards[guard] = true
                        TriggerClientEvent('cb-unionheist:client:RobGuard', -1, guard)
                    end
                    break -- Stop once the reward is given
                end
            end
        end
    end
end)

RegisterNetEvent('cb-unionheist:server:LootStolen', function(key)
    local src = source
    local rewardConfig
    local newModel

    -- Check if the vault is blown
    if vaultBlown then
        -- Iterate through Config.Loot to find the matching key
        for k, v in pairs(Config.Loot) do
            if key == k then
                -- Get the reward configuration for the loot model
                for lootModel, rewards in pairs(Config.LootRewards) do
                    if lootModel == lootResults[k].model then
                        rewardConfig = rewards
                    end
                end

                if rewardConfig then
                    -- Distribute rewards to the player based on the reward configuration
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
    else
        return
    end
end)

RegisterNetEvent('cb-unionheist:server:BlowCageDoor', function(cage)
    for k, v in pairs(Config.DoorLocations) do
        local convertedCageGroup = Config.DoorLocations[cage].cage
        if convertedCageGroup == v.cage then
            blownCageDoors[cage] = true
            TriggerClientEvent('cb-unionheist:client:BlowCageDoor', -1, cage)
            break
        end
    end
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
                return true
            end
        end
    else
        return false
    end
end)

lib.callback.register('cb-unionheist:server:RemoveCageItem', function(source, cage)
    local cageConfig = Config.DoorLocations[cage]
    if HasItem(source, cageConfig.required.item, cageConfig.required.amount) then
        if not RemoveItem(source, cageConfig.required.item, cageConfig.required.amount) then
            print(string.format("Error removing %.0fx %s from Player %.0f inventory", cageConfig.required.amount, cageConfig.required.item, source))
            return false
        else
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
    for k, v in pairs(Config.DoorLocations) do
        if cage == v.cage then
            cageRoomBlown[v.cage] = true
            break
        end
    end
    return (cageRoomBlown[cage] or false) and (lootStolen[loot] == nil)
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