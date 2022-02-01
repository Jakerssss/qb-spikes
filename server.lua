local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("policespikes", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("spikestrips:client:usespikes", source, item)
end)

RegisterServerEvent("Spikes:TriggerDeleteSpikes")
AddEventHandler("Spikes:TriggerDeleteSpikes", function(netid)
    TriggerClientEvent("Spikes:DeleteSpikes", -1, netid)
end)
