local vaultBlown = false
local blownCageDoors = {}
local blownCageGroup = {}
local lootResults = {}
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

RegisterNetEvent('cb-unionheist:server:BlowVaultDoor', function()
    -- TODO: Distance Check
    vaultBlown = true
    TriggerClientEvent('cb-unionheist:client:BlowVaultDoor', -1)
end)

lib.callback.register('cb-unionheist:server:RobGuard', function(source, guard)
    -- TODO: Distance Check
    if robbedGuards[guard] == nil then
        robbedGuards[guard] = true

        -- Process rewards
        local guardConfig = Config.Guards[guard]
        if guardConfig and guardConfig.rewards then
            for _, reward in ipairs(guardConfig.rewards) do
                local randomChance = math.random(1, 100) -- Random number between 1 and 100
                if randomChance <= reward.chance then
                    local amount = math.random(reward.minAmount, reward.maxAmount)
                    if not AddItem(source, reward.item, amount) then
                        print(string.format("Error adding %.0fx %s to Player %.0f", reward.item, amount, source))
                    end
                end
            end
        end

        return true
    else
        return false
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
                            if not AddItem(src, reward.item, rewardAmount) then
                                print(string.format("Error adding %.0fx %s to Player %.0f inventory", src, reward.item, rewardAmount))
                            end
                        end
                    end
                end
                TriggerClientEvent('cb-unionheist:client:SyncLoot', -1, k, lootResults[k].model)

                -- Update the model for the loot item
                for _, modelData in pairs(Config.Loot[k].models) do
                    if modelData.model == lootResults[k].model then
                        newModel = modelData.newModel
                    end
                end

                lootResults[k].model = newModel
            end
        end
    else
        return
    end
end)

RegisterNetEvent('cb-unionheist:server:BlowCageDoor', function(cage)
    -- TODO: Distance Check
    blownCageDoors[cage] = true
    for k, v in pairs(Config.DoorLocations) do
        local convertedCageGroup = Config.DoorLocations[cage].cage
        if convertedCageGroup == v.cage then
            blownCageGroup[v.cage] = true
            TriggerClientEvent('cb-unionheist:client:BlowCageDoor', -1, cage)
            break
        end
    end
end)

RegisterNetEvent('cb-unionheist:server:SecurityHack', function(hack)
    securityHacked[hack] = true
end)

lib.callback.register('cb-unionheist:server:IsVaultBlown', function(source)
    return vaultBlown
end)

lib.callback.register('cb-unionheist:server:IsCageRoomBlown', function(source, cage)
    return blownCageGroup[cage] or false
end)

lib.callback.register('cb-unionheist:server:IsSecurityHacked', function(source)
    for k, v in pairs(Config.HackLocations) do
        if not securityHacked[k] then
            print(k)
            return false
        end
    end
    return true
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

--TODO: Make sure to drop the player from the heist if they log out