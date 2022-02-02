local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("policespikes", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("spikestrips:client:usespikes", source, item)
end)

RegisterServerEvent("qb-spikes-use")
AddEventHandler("qb-spikes-use", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items["policespikes"], 'remove')
    Player.Functions.RemoveItem('policespikes', Config.Amount, false, info) 
end)

RegisterServerEvent("qb-spikes-remove")
AddEventHandler("qb-spikes-remove", function(netid)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items["policespikes"], 'add')
    Player.Functions.AddItem('policespikes',  1, false, info) -- set to 1 still pulls the config spawned ammount...
    TriggerClientEvent("qb-spikes-delete", -1, netid) 
end)
