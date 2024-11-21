local vaultBlown = false
local blownCageDoors = {}
local lootResults = {}
local securityHacked = {}

function CreateLootBasedOnChance()
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

        -- Add the result for this location
        table.insert(lootResults, {
            coords = v.coords,
            size = v.size,
            model = selectedModel
        })
    end
end

RegisterNetEvent('cb-unionheist:server:BlowVaultDoor', function()
    -- TODO: Distance Check
    vaultBlown = true
    TriggerClientEvent('cb-unionheist:client:BlowVaultDoor', -1)
end)

RegisterNetEvent('cb-unionheist:server:BlowCageDoor', function(cage)
    -- TODO: Distance Check
    blownCageDoors[cage] = true
    print(blownCageDoors[cage])
    TriggerClientEvent('cb-unionheist:client:BlowCageDoor', -1, cage)
end)

lib.callback.register('cb-unionheist:server:IsVaultBlown', function(source)
    return vaultBlown
end)

lib.callback.register('cb-unionheist:server:IsSecurityHacked', function(source)
    for k, v in pairs(Config.HackLocations) do
        if not securityHacked[k] then
            return false
        end
    end
    return true
end)

lib.callback.register('cb-unionheist:server:IsCageBlown', function(source, cage)
    print(blownCageDoors[cage])
    return blownCageDoors[cage] or false
end)

lib.callback.register('cb-unionheist:server:GetLoot', function(source)
    return lootResults
end)

CreateLootBasedOnChance()

--TODO: Make sure to drop the player from the heist if they log out