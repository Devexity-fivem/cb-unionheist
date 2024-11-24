local createdLoot = {}
local robbedLoot = {}
local robbedGuards = {}
local CreatedObjectHandles = {}
local cageDoorBlown = {}
local doingSomething = false
local vaultBlown = false

function DeleteNativeProps()
    for k, v in pairs(Config.DeleteProps) do
        local object = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 2, v.modelHash, false, false, false)
        CreateModelHide(v.coords.x, v.coords.y, v.coords.z, 0.05, v.modelHash, false)
    end
end

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x,y,z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function SpawnMissionPeds()
    for k,v in pairs(Config.Guards) do
        local pedCoords = v.coords -- Replace with your desired coordinates
        local pedModel = GetHashKey(v.model) -- Replace with your desired ped model
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(1)
        end
        local ped = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z, pedCoords.w, true, false)
        GiveWeaponToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), 100, false, true)
        local player = PlayerPedId()
        TaskCombatPed(ped, player, 0, 16)
        SetPedAccuracy(ped, 75)
        SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))
        SetEntityAsMissionEntity(ped, true, true)
        SetPedCombatMovement(ped, 2)
        SetEntityHealth(ped, v.health)
        SetModelAsNoLongerNeeded(pedModel)
        exports.ox_target:addLocalEntity(ped, {
            label = "Rob",
            icon = "fa-solid fa-mask",
            distance = 1.5,
            canInteract = function(entity, distance, coords, name, bone)
                return IsEntityDead(entity) and (robbedGuards[k] == nil)
            end,
            onSelect = function()
                local robbed = lib.callback.await('cb-unionheist:server:IsGuardRobbed', false, k)
                if robbed then
                    Notify("Already Robbed", "This guard has already been robbed!", "error")
                else
                    RobCopAnim(ped, k)
                end
            end,
        })
    end
end

function RobCopAnim(targetPed, guard)
    if not DoesEntityExist(targetPed) or IsPedAPlayer(targetPed) then
        return
    end
    doingSomething = true

    -- Load required assets
    local animDict = "anim@gangops@facility@servers@bodysearch@"
    local propModel = "hei_p_m_bag_var22_arm_s"
    local ptfxAsset = "scr_ornate_heist"

    RequestAnimDict(animDict)
    RequestModel(propModel)
    RequestNamedPtfxAsset(ptfxAsset)

    while not HasAnimDictLoaded(animDict) or not HasModelLoaded(propModel) or not HasNamedPtfxAssetLoaded(ptfxAsset) do
        Wait(50)
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerRot = GetEntityRotation(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    local sceneOffset = vector3(0.0, 0.0, -0.6)
    local searchScene = NetworkCreateSynchronisedScene(targetCoords.x, targetCoords.y, targetCoords.z + sceneOffset.z, playerRot.x, playerRot.y, playerRot.z, 2, true, false, 1.0, 0, 1.3)
    NetworkAddPedToSynchronisedScene(playerPed, searchScene, animDict, "player_search", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkStartSynchronisedScene(searchScene)
    doingSomething = false
    TriggerServerEvent('cb-unionheist:server:RobGuard', guard)
    ClearPedTasks(playerPed)
    RemoveAnimDict(animDict)
    SetModelAsNoLongerNeeded(propModel)
    RemoveNamedPtfxAsset(ptfxAsset)
end

function BlowVaultDoor()
    if LocalPlayer.state.UnionHeist and not doingSomething then
        doingSomething = true
        local removedItem = lib.callback.await('cb-unionheist:server:RemoveVaultItem', false)
        if removedItem then
            local ped = PlayerPedId()
            local vaultCoords = Config.Vault.coords
            SetEntityHeading(ped, 120)
            RequestAnimDict("anim@scripted@charlie_missions@mission_5@ig1_avi_hacking@")
            while not HasAnimDictLoaded("anim@scripted@charlie_missions@mission_5@ig1_avi_hacking@") do
                Wait(50)
            end
            local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
            local hackscene = NetworkCreateSynchronisedScene(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z-0.5, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, hackscene, "anim@scripted@charlie_missions@mission_5@ig1_avi_hacking@", "hack", 1.2, -4.0, 1, 16, 1148846080, 0)
            NetworkStartSynchronisedScene(hackscene)
            local success = VaultMinigame()
            if success then
                NetworkStopSynchronisedScene(hackscene)
                RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
                RequestModel("hei_p_m_bag_var22_arm_s")
                RequestNamedPtfxAsset("scr_ornate_heist")
                while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
                    Wait(50)
                end
                Wait(100)
                SetEntityHeading(ped, 297)
                rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
                local bagscene = NetworkCreateSynchronisedScene(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z-0.5, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
                local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z-0.5, true, true, false)
                NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
                SetPedComponentVariation(ped, 5, 0, 0, 0)
                NetworkStartSynchronisedScene(bagscene)
                Wait(3500)
                DeleteObject(bag)
                SetPedComponentVariation(ped, 5, 45, 0, 0)
                NetworkStopSynchronisedScene(bagscene)
                AddExplosion(vaultCoords.x-1.75, vaultCoords.y+0.8, vaultCoords.z, 22, 0.8, true, false, 1)
                TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
                TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
                -- Add Evidence
                Wait(52000)
                AddExplosion(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z, 2, 0.8, true, false, 1)
                TriggerServerEvent('cb-unionheist:server:BlowVaultDoor')
                NotifyCops()
                SpawnMissionPeds()
                doingSomething = false
            else
                doingSomething = false
                NetworkStopSynchronisedScene(hackscene)
                return
            end
            ClearPedTasks(ped)
        else
            Notify("Missing Item", "You are missing the required item", "error")
        end
    else
        Notify("Headaches", "You need to exit the depository and re-enter!", "error")
    end
end

function SecurityHackAnim(hack)
    if LocalPlayer.state.UnionHeist and not doingSomething then
        doingSomething = true
        local ped = PlayerPedId()
        SetEntityHeading(ped, Config.HackLocations[hack].pedHeading)
        local hackCoords = Config.HackLocations[hack].coords
        RequestAnimDict("anim@scripted@charlie_missions@mission_5@ig1_avi_hacking@")
        while not HasAnimDictLoaded("anim@scripted@charlie_missions@mission_5@ig1_avi_hacking@") do
            Wait(50)
        end
        local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
        local animModifier = Config.HackLocations[hack].animModifier
        local hackScene = NetworkCreateSynchronisedScene(hackCoords.x+animModifier.x, hackCoords.y+animModifier.y, hackCoords.z+animModifier.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, hackScene, "anim@scripted@charlie_missions@mission_5@ig1_avi_hacking@", "hack", 1.2, -4.0, 1, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(hackScene)
        local success = SecurityHackMinigame()
        if success then
            TriggerServerEvent('cb-unionheist:server:SecurityHack', hack)
        else
            TriggerServerEvent('cb-unionheist:server:FailedSecurityHack', hack)
        end
        NetworkStopSynchronisedScene(hackScene)
        -- Add Evidence
        doingSomething = false
        ClearPedTasks(ped)
    else
        Notify("Headaches", "You need to exit the depository and re-enter!", "error")
    end
end

function BlowCageDoor(cage)
    if LocalPlayer.state.UnionHeist and not doingSomething then
        doingSomething = true
        local removedItem = lib.callback.await('cb-unionheist:server:RemoveCageItem', false, cage)
        if removedItem then
            local cageCoords = Config.DoorLocations[cage].coords
            local pedHeading = Config.DoorLocations[cage].pedHeading
            RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
            RequestModel("hei_p_m_bag_var22_arm_s")
            RequestNamedPtfxAsset("scr_ornate_heist")
            while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
                Wait(50)
            end
            local ped = PlayerPedId()
            SetEntityHeading(ped, pedHeading)
            Wait(100)

            local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
            local targetModifier = Config.DoorLocations[cage].targetModifier
            local lootscene = NetworkCreateSynchronisedScene(cageCoords.x+targetModifier.x, cageCoords.y+targetModifier.y, cageCoords.z+targetModifier.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)

            NetworkAddPedToSynchronisedScene(ped, lootscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
            SetPedComponentVariation(ped, 5, 45, 0, 0)
            NetworkStartSynchronisedScene(lootscene)
            Wait(3500)
            NetworkStopSynchronisedScene(lootscene)
            local explosionYModifier = Config.DoorLocations[cage].explosionYModifier
            local explosionXModifier = Config.DoorLocations[cage].explosionXModifier
            TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
            TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
            -- Add Evidence
            AddExplosion(cageCoords.x+explosionXModifier, cageCoords.y+explosionYModifier, cageCoords.z, 22, 0.8, true, false, 1)
            Wait(52000)
            if Config.GasGrenades.enabled then
                for k, v in pairs(Config.GasGrenades.locations) do
                    local cageGroupBlown = lib.callback.await('cb-unionheist:server:IsCageRoomBlown', false, cage)
                    if not cageGroupBlown then
                        if k == cage then
                            local gasCoords = v.coords
                            AddExplosion(gasCoords.x, gasCoords.y, gasCoords.z, 21, 1.5, true, false, 1)
                        end
                    end
                end
            end
            TriggerServerEvent('cb-unionheist:server:BlowCageDoor', cage)
            if Config.DoorLocations[cage].blowUp then
                AddExplosion(cageCoords.x+explosionXModifier, cageCoords.y+explosionYModifier, cageCoords.z, 43, 0.8, true, false, 1)
            end
            doingSomething = false
            ClearPedTasks(ped)
        end
    else
        Notify("Headaches", "You need to exit the depository and re-enter!", "error")
    end
end

TeleportInside = lib.zones.box({
    coords = vector3(Config.TeleportIn.x, Config.TeleportIn.y, Config.TeleportIn.z), -- The center of the zone
    size = vec3(2, 1, 1),
    rotation = Config.TeleportIn.w, -- Rotation of the zone
    debug = false,
    inside = function()
        DrawText3Ds(Config.TeleportIn.x, Config.TeleportIn.y, Config.TeleportIn.z, "[E] Exit Depository")
        if IsControlJustReleased(0, 38) then -- 38 is the control for "E"
            DoScreenFadeOut(500)
            Wait(1000)
            SetEntityCoords(PlayerPedId(), Config.TeleportOut.x, Config.TeleportOut.y, Config.TeleportOut.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), Config.TeleportOut.w)
            SetGameplayCamRelativeHeading(Config.TeleportOut.w)
            ExitHeist()
            LocalPlayer.state.UnionHeist = false
            DoScreenFadeIn(500)
        end
    end
})

TeleportOutside = lib.zones.box({
    coords = vector3(Config.TeleportOut.x, Config.TeleportOut.y, Config.TeleportOut.z), -- The center of the zone
    size = vec3(2, 1, 1),
    rotation = Config.TeleportOut.w, -- Rotation of the zone
    debug = false,
    inside = function()
        DrawText3Ds(Config.TeleportOut.x, Config.TeleportOut.y, Config.TeleportOut.z, "[E] Enter Depository")
        if IsControlJustReleased(0, 38) then -- 38 is the control for "E"
            DoScreenFadeOut(500)
            Wait(1000)
            LocalPlayer.state.UnionHeist = true
            SetEntityCoords(PlayerPedId(), Config.TeleportIn.x, Config.TeleportIn.y, Config.TeleportIn.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), Config.TeleportIn.w)
            SetGameplayCamRelativeHeading(Config.TeleportIn.w)
            EnterHeist()
            DoScreenFadeIn(500)
        end
    end
})

function CreateSecurityHacks()
    local alreadyHackedSecurity = lib.callback.await('cb-unionheist:server:GetSecurityHacks', false)
    for k, v in pairs(Config.HackLocations) do
        if alreadyHackedSecurity[k] == nil then
            exports.ox_target:addBoxZone({
                name = "UnionHeist_SecurityHack"..k,
                coords = Config.HackLocations[k].coords,
                size = Config.HackLocations[k].size,
                rotation = Config.HackLocations[k].coords.w,
                debug = Config.HackLocations[k].debug,
                options = {
                    {
                        icon = "fa-solid fa-mobile",
                        label = 'Hack Vault Security',
                        onSelect = function()
                            SecurityHackAnim(k)
                        end,
                        canInteract = function()
                            return HasItemClient(Config.HackLocations[k].required.item, Config.HackLocations[k].required.amount) and not doingSomething
                        end,
                        distance = 2.5,
                    }
                }
            })
        end
    end
end

function CreateVaultDoor()
    local vaultCoords = Config.Vault.coords
    local entity = GetClosestObjectOfType(vaultCoords.x, vaultCoords.y, vaultCoords.z, 2, -1932297301, false, false, false)
    local vaultBlown = lib.callback.await('cb-unionheist:server:IsVaultBlown', false)
    if not vaultBlown then
        FreezeEntityPosition(entity, true)
        exports.ox_target:addBoxZone({
            name = "UnionHeist_VaultDoor",
            coords = vec3(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z),
            size = Config.Vault.size,
            rotation = Config.Vault.coords.w,
            debug = Config.Vault.debug,
            options = {
                {
                    icon = "fa-solid fa-vault",
                    label = 'Blow Vault Door',
                    onSelect = function()
                        local securityHacked = lib.callback.await('cb-unionheist:server:IsSecurityHacked', false)
                        if securityHacked then
                            BlowVaultDoor()
                        else
                            Notify("Vault Security", "Take out the security system first!", "error")
                        end
                    end,
                    canInteract = function()
                        return HasItemClient(Config.Vault.required.item, Config.Vault.required.amount) and not doingSomething
                    end,
                    distance = 2.5,
                }
            }
        })
    end
end

function CreateCageDoors()
    local blownCages = lib.callback.await('cb-unionheist:server:GetBlownCages', false)
    for k, v in pairs(Config.DoorLocations) do
        if not blownCages[k] then
            local doorCoords = Config.DoorLocations[k].coords
            local entity = GetClosestObjectOfType(doorCoords.x, doorCoords.y, doorCoords.z, 0.05, Config.DoorLocations[k].modelHash, false, false, false)
            FreezeEntityPosition(entity, true)
            local targetModifier = Config.DoorLocations[k].targetModifier
            exports.ox_target:addBoxZone({
                name = "UnionHeist_Door_"..k,
                coords = vec3(doorCoords.x+targetModifier.x, doorCoords.y+targetModifier.y, doorCoords.z+targetModifier.z),
                size = Config.DoorLocations[k].size,
                rotation = Config.DoorLocations[k].coords.w,
                debug = Config.DoorLocations[k].debug,
                options = {
                    {
                        icon = "fa-solid fa-explosion",
                        label = 'Blow Cage Door '..k,
                        onSelect = function()
                            if vaultBlown then
                                BlowCageDoor(k)
                            else
                                Notify("Blow Vault", "Blow the Vault Door first", "error")
                            end
                        end,
                        canInteract = function()
                            return HasItemClient(Config.DoorLocations[k].required.item, Config.DoorLocations[k].required.amount)
                        end,
                        distance = 2.5,
                    }
                }
            })
        end
    end
end

function CreateLoot()
    local lootData = lib.callback.await('cb-unionheist:server:GetLoot', false)

    if not lootData or next(lootData) == nil then
        return
    end
    for key, loot in pairs(lootData) do
        if loot.model then -- Ensure the loot has a model

            local goodModel = true
            for _, emptyModel in ipairs(Config.EmptyModels) do
                if loot.model == emptyModel then
                    goodModel = false
                    break
                end
            end
            -- Locate the matching Config.Loot entry for this key
            local lootConfig = Config.Loot[key]
            if lootConfig then
                -- Find the matching modelData within the lootConfig
                local modelData = nil
                for _, data in ipairs(lootConfig.models) do
                    if data.model == loot.model then
                        modelData = data
                        break
                    end
                end

                if modelData then
                    local modelHash = GetHashKey(loot.model)
                    local object = CreateObject(modelHash, lootConfig.coords.x, lootConfig.coords.y, lootConfig.coords.z, false, false, false)
                    SetEntityRotation(object, 0, 0, lootConfig.coords.w, 2, true)
                    FreezeEntityPosition(object, true)
                    if goodModel then
                        exports.ox_target:addBoxZone({
                            name = "UnionHeist_Loot_" .. key,
                            coords = vec3(lootConfig.coords.x, lootConfig.coords.y, lootConfig.coords.z),
                            size = vec3(lootConfig.size.x, lootConfig.size.y, lootConfig.size.z),
                            rotation = lootConfig.coords.w,
                            debug = false,
                            options = {
                                {
                                    icon = "fa-solid fa-box-open",
                                    label = 'Loot',
                                    onSelect = function()
                                        local cageBlown = lib.callback.await('cb-unionheist:server:IsCageRoomBlown', false, lootConfig.cage)
                                        if cageBlown then
                                            StealLoot(key, modelHash, lootConfig.coords)
                                        end
                                    end,
                                    canInteract = function()
                                        return true
                                    end,
                                    distance = 1,
                                }
                            }
                        })
                    end
                    createdLoot[key] = object
                end
            end
        end
    end
end

RegisterNetEvent('cb-unionheist:client:SecurityHacked', function(hack)
    if LocalPlayer.state.UnionHeist then
        exports.ox_target:removeZone("UnionHeist_SecurityHack"..hack)
    end
end)

RegisterNetEvent('cb-unionheist:client:RobGuard', function(guard)
    robbedGuards[guard] = true
end)

RegisterNetEvent('cb-unionheist:client:ResetHeist', function()
    createdLoot = {}
    robbedLoot = {}
    robbedGuards = {}
    CreatedObjectHandles = {}
    cageDoorBlown = {}
    doingSomething = false
    vaultBlown = false
    ExitHeist()
end)

RegisterNetEvent('cb-unionheist:client:BlowVaultDoor', function()
    if LocalPlayer.state.UnionHeist then
        vaultBlown = lib.callback.await('cb-unionheist:server:IsVaultBlown', false)
        if not vaultBlown then
            return
        else
            local vaultCoords = Config.Vault.coords
            local entity = GetClosestObjectOfType(vaultCoords.x, vaultCoords.y, vaultCoords.z, 2, -1932297301, false, false, false)
            FreezeEntityPosition(entity, false)
        end
    end
end)

RegisterNetEvent('cb-unionheist:client:BlowCageDoor', function(cage)
    if LocalPlayer.state.UnionHeist then
        local cageCoords = Config.DoorLocations[cage].coords
        local entity = GetClosestObjectOfType(cageCoords.x, cageCoords.y, cageCoords.z, 0.05, Config.DoorLocations[cage].modelHash, false, false, false)
        CreateModelHide(cageCoords.x, cageCoords.y, cageCoords.z, 0.05, Config.DoorLocations[cage].modelHash, false)
        --FreezeEntityPosition(entity, false)
    end
end)

RegisterNetEvent('cb-unionheist:client:SyncLoot', function(lootKey, model)    
    -- Mark this loot as robbed
    robbedLoot[lootKey] = true
    if LocalPlayer.state.UnionHeist then
        -- Ensure vault is blown, if applicable        
        local lootCoords = Config.Loot[lootKey].coords
        local newModel
        
        -- Iterate through models in the config
        for k, v in pairs(Config.Loot[lootKey].models) do
            if v.model == model then
                newModel = v.newModel
                -- Swap models
                CreateModelSwap(lootCoords.x, lootCoords.y, lootCoords.z, 0.05, GetHashKey(model), GetHashKey(newModel), false)
                -- Remove zone targeting
                local zoneId = "UnionHeist_Loot_"..lootKey
                exports.ox_target:removeZone(zoneId)
                break
            end
        end
    end
end)

function DestroyLoot()
    for k, object in pairs(createdLoot) do
        if DoesEntityExist(object) then
            DeleteObject(object) -- Deletes the object
            exports.ox_target:removeZone("UnionHeist_Loot_"..k)
        end
    end
    createdLoot = {}
end

function DestroyVaultDoor()
    exports.ox_target:removeZone("UnionHeist_VaultDoor")
end

function DestroyCageDoors()
    for k, v in pairs(Config.DoorLocations) do
        exports.ox_target:removeZone("UnionHeist_Door_"..k)
    end
end

function DestroySecurityHacks()
    for k, v in pairs(Config.HackLocations) do
        exports.ox_target:removeZone("UnionHeist_SecurityHack"..k)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, object in pairs(createdLoot) do
            if DoesEntityExist(object) then
                DeleteObject(object) -- Deletes the object
                exports.ox_target:removeZone("UnionHeist_Loot_"..k)
            end
        end

        -- Clear the table after deleting
        createdLoot = {}
    end
end)

function StealLoot(key, modelHash, coords)
    if lib.progressBar({
        duration = Config.Loot[key].duration,
        label = "Looting",
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'anim@heists@ornate_bank@grab_cash',
            clip = 'grab'
        },
    }) then
        TriggerServerEvent('cb-unionheist:server:LootStolen', key)
    else
        Notify("Art Heist", "You cancelled the action", "error")
    end
end

function UpdateExtraCageDoors()
    if LocalPlayer.state.UnionHeist then
        for k, v in pairs(Config.DoorLocations) do
            if v.specialDoor then
                local cageBlown = lib.callback.await('cb-unionheist:server:IsCageBlown', false, k)
                if not cageBlown then
                    for _, q in pairs(Config.CreatedProps) do
                        if k == q.cageDoor then
                            local object = CreateObject(q.modelHash, q.coords.x, q.coords.y, q.coords.z, false, false, false)
                            SetEntityHeading(object, q.coords.w)
                            FreezeEntityPosition(object, true)
                            table.insert(CreatedObjectHandles, object)
                        end
                    end
                end
            end
        end

    else
        for _, object in pairs(CreatedObjectHandles) do
            if DoesEntityExist(object) then
                DeleteObject(object)
            end
        end
        -- Clear the array after deletion
        CreatedObjectHandles = {}

        -- Optionally hide the models
        for _, v in pairs(Config.CreatedProps) do
            CreateModelHide(v.coords.x, v.coords.y, v.coords.z, 1, v.modelHash, false)
        end
    end
end

function EnterHeist()
    LocalPlayer.state.UnionHeist = true
    DeleteNativeProps()
    UpdateExtraCageDoors()
    CreateSecurityHacks()
    CreateVaultDoor()
    CreateCageDoors()
    CreateLoot()
end

function ExitHeist()
    LocalPlayer.state.UnionHeist = false
    UpdateExtraCageDoors()
    DestroySecurityHacks()
    DestroyVaultDoor()
    DestroyCageDoors()
    DestroyLoot()
end

RegisterCommand("enterHeist", function()
    EnterHeist()
end, false)

RegisterCommand("exitHeist", function()
    ExitHeist()
end, false)