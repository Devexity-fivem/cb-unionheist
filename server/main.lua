local vaultBlown = false
local blownCageDoors = {}
local lootResults = {}

function CreateLootBasedOnChance()
    print("here")
    for k, v in pairs(Config.Loot) do
        local roll = math.random(100) -- Roll a random number between 1 and 100
        local cumulativeChance = 0 -- Initialize cumulative chance
        local selectedModel = nil -- Default to no model

        -- Determine which model (if any) to spawn
        for _, modelData in ipairs(v.models) do
            cumulativeChance = cumulativeChance + modelData.chance
            if roll <= cumulativeChance then
                print(modelData.modelHash)
                print(roll, cumulativeChance)
                selectedModel = modelData.modelHash
                break
            end
        end

        -- Add the result for this location
        table.insert(lootResults, {
            coords = v.coords,
            size = v.size,
            modelHash = selectedModel -- May be nil if no model is selected
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

lib.callback.register('cb-unionheist:server:IsCageBlown', function(source, cage)
    print(blownCageDoors[cage])
    return blownCageDoors[cage] or false
end)

lib.callback.register('cb-unionheist:server:GetLoot', function(source)
    return lootResults
end)

CreateLootBasedOnChance()

--TODO: Make sure to drop the player from the heist if they log out