Framework = nil
UsingOxInventory = false
WebhookName = "Cool Brad Scripts"
WebhookUrl = "CHANGEME"
if GetResourceState('qbx_core') == 'started' then
    Framework = "qbox"
elseif GetResourceState('qb-core') == 'started' then
    Framework = "qb-core"
    QBCore = exports['qb-core']:GetCoreObject()
end
if GetResourceState('ox_inventory') == 'started' then
    UsingOxInventory = true
end

function GetPlayer(target)
    if Framework == "qb-core" then
        return QBCore.Functions.GetPlayer(target)

    elseif Framework == "qbox" then
        return exports.qbx_core:GetPlayer(target)
    end
end

function GetPlayerCoords(target)
    local playerPed = GetPlayerPed(target)
    return GetEntityCoords(playerPed)
end

function GetPlayers()
    if Framework == "qb-core" then
        return QBCore.Functions.GetPlayers()

    elseif Framework == "qbox" then
        local sources = {}
        local players = exports.qbx_core:GetQBPlayers()
        for k in pairs(players) do
            sources[#sources+1] = k
        end
        return sources
    end
end

function GetDutyCount(job)
    if Framework == "qb-core" then
        local players = GetPlayers()
        local onDuty = 0
        for k, v in pairs(players) do
            local Player = GetPlayer(v)
            if Player ~= nil then
                if Player.PlayerData.job.name == job then
                    onDuty = onDuty + 1
                end
            end
        end
        return onDuty
    elseif Framework == "qbox" then
        return exports.qbx_core:GetDutyCountJob(job)
    end
end

function HasItem(source, item, amount)
    local Player = GetPlayer(source)
    if Framework == "qb-core" then
        return Player.Functions.HasItem(item, amount)
    elseif Framework == "qbox" then
        if UsingOxInventory then
            local itemCount = exports.ox_inventory:Search(source, "count", item)
            if not itemCount then
                return false
            elseif itemCount >= amount then
                return true
            else
                return false
            end
        else
            return Player.Functions.HasItem(item, amount)
        end
    end
end

function RemoveMoney(source, amount)
    local src = source
    local player = GetPlayer(src)
    if player then
        player.Functions.RemoveMoney('cash', amount)
        return true
    else
        return false
    end
end

function RemoveItem(source, item, amount)
    if not UsingOxInventory then
        local Player = GetPlayer(source)
        if not Player or not Player.Functions then
            return false
        end
        local removed = Player.Functions.RemoveItem(item, amount)
        return removed == true
    elseif UsingOxInventory then
        local removed = exports.ox_inventory:RemoveItem(source, item, amount)
        return removed ~= nil and removed ~= false
    end
    return false
end

function AddItem(source, item, amount)
    if not UsingOxInventory then
        local Player = GetPlayer(source)
        if not Player or not Player.Functions then
            return false
        end
        local added = Player.Functions.AddItem(item, amount)
        return added == true
    elseif UsingOxInventory then
        local canCarryItem = exports.ox_inventory:CanCarryItem(source, item, amount)
        if canCarryItem then
            local added = exports.ox_inventory:AddItem(source, item, amount)
            return added ~= nil and added ~= false
        else
            TriggerClientEvent('cb-unionheist:client:NotEnoughSpace', source)
            return false
        end
    end
end

function DiscordLog(data)
    PerformHttpRequest(WebhookUrl, function() end, 'POST',
        json.encode({ username = WebhookName, content = data }), { ['Content-Type'] = 'application/json' })
end