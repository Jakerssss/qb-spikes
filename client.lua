local QBCore = exports['qb-core']:GetCoreObject()
local SpawnedSpikes = {}
local spikemodel = "p_stinger_04"
local nearSpikes = false

RegisterNetEvent("spikestrips:client:usespikes")
AddEventHandler("spikestrips:client:usespikes", function(config)
    Animation()
    Citizen.Wait(1700)
    ClearPedTasksImmediately(PlayerPedId())
    CreateSpikes(Config.Amount)
    TriggerServerEvent("QBCore:Server:RemoveItem", "policespikes", 1)
    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["policespikes"], "remove")
end)

RegisterNetEvent("Spikes:DeleteSpikes")
AddEventHandler("Spikes:DeleteSpikes", function(netid)
    Citizen.CreateThread(function()
        Animation()
        Citizen.Wait(1700)
        ClearPedTasksImmediately(PlayerPedId())
        local spike = NetworkGetEntityFromNetworkId(netid)
        DeleteEntity(spike)
        TriggerServerEvent("QBCore:Server:AddItem", "policespikes", 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["policespikes"], "add")
    end)
end)

Citizen.CreateThread(function()
    while true do
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                local vehiclePos = GetEntityCoords(vehicle, false)
                local spikes = GetClosestObjectOfType(vehiclePos.x, vehiclePos.y, vehiclePos.z, 80.0, GetHashKey(spikemodel), 1, 1, 1)
                local spikePos = GetEntityCoords(spikes, false)
                local distance = Vdist(vehiclePos.x, vehiclePos.y, vehiclePos.z, spikePos.x, spikePos.y, spikePos.z)

                if spikes ~= 0 then
                    nearSpikes = true
                else
                    nearSpikes = false
                end
            else
                nearSpikes = false
            end
        else
            nearSpikes = false
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if nearSpikes then
            local tires = {
                {bone = "wheel_lf", index = 0},
                {bone = "wheel_rf", index = 1},
                {bone = "wheel_lm", index = 2},
                {bone = "wheel_rm", index = 3},
                {bone = "wheel_lr", index = 4},
                {bone = "wheel_rr", index = 5}
            }

            for a = 1, #tires do
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 15.0, GetHashKey(spikemodel), 1, 1, 1)
                local spikePos = GetEntityCoords(spike, false)
                local distance = Vdist(tirePos.x, tirePos.y, tirePos.z, spikePos.x, spikePos.y, spikePos.z)

                if distance < 1.8 then
                    if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                        SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end)

function CreateSpikes(amount)
    local spawnCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.2, 0.0)
    for a = 1, amount do
        local spike = CreateObject(GetHashKey(spikemodel), spawnCoords.x, spawnCoords.y, spawnCoords.z, 1, 1, 1)
        local netid = NetworkGetNetworkIdFromEntity(spike)
        SetNetworkIdExistsOnAllMachines(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        SetEntityHeading(spike, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(spike)
        spawnCoords = GetOffsetFromEntityInWorldCoords(spike, 0.0, 3.2, 0.0)
        table.insert(SpawnedSpikes, netid)
    end
end

RegisterCommand("RemoveSpikes",function()
    for a = 1, #SpawnedSpikes do
        TriggerServerEvent("Spikes:TriggerDeleteSpikes", SpawnedSpikes[a])
    end
    SpawnedSpikes = {}
end)

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

function Animation()
	local ped 	  = PlayerPedId()
	local coords  = GetEntityCoords(ped)
    
	loadAnimDict("pickup_object")
	TaskPlayAnim(ped, "pickup_object", "pickup_low", 1.0, 1, -1, 33, 0, 0, 0, 0)
end

local spikestrips = {
    "p_stinger_04",
}
exports['qb-target']:AddTargetModel(spikestrips, {
    options = {
        {
            type = "command",
            event = "RemoveSpikes",
            icon = "fas fa-hand-holding",
            label = "Pick Up",
        },
    },
    distance = 2.0
})
