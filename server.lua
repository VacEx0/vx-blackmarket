local QBCore = exports['qb-core']:GetCoreObject()
local pedData = { data = {}, loaded = false }
local fromCheck = 'itemshop-BlackMarket'

if Config.useItemCost then fromCheck = 'citemshop-BlackMarket' end

function getRandomPedModel()
    return Config.blackmarketPedModels[math.floor(math.random(1, #Config.blackmarketPedModels))]
end

function getRandomScenario()
    return Config.scenarios[math.floor(math.random(1, #Config.scenarios))]
end

CreateThread(function()
    for pedDataIndex, data in pairs(Config.locations) do
        local model, scenario = data.model, data.scenario
        if not model then model = getRandomPedModel() end
        if not scenario then scenario = getRandomScenario() end
        local ped = CreatePed(0, model, data.coords, true, true)
        FreezeEntityPosition(ped, true)
        pedData.data[pedDataIndex] = {
            netId = NetworkGetNetworkIdFromEntity(ped),
            scenario = scenario,
        }
    end
    pedData.loaded = true
end)

RegisterNetEvent('vxbm:sever:requestPedData', function()
    local src = source
    while not pedData.loaded do Wait(10) end
    TriggerClientEvent('vxbm:client:updatePedData', src, pedData)
end)

RegisterNetEvent('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
    local src = source
    if QBCore.Shared.SplitStr(fromInventory, "_")[1] == fromCheck then
        TriggerClientEvent('vxbm:client:updateRep', src, fromSlot, fromAmount)
    end
end)

RegisterNetEvent('vxbm:server:setMetaData', function(rep, id)
    local src = source
    if not id then id = src end
    local player = QBCore.Functions.GetPlayer(id)
    if player then
        player.Functions.SetMetaData('bmrep', rep)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for i, data in pairs(pedData.data) do
        DeleteEntity(NetworkGetEntityFromNetworkId(data.netId))
    end
end)

RegisterCommand('setbmrep', function(src, args)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    if not target or not amount then return end
    TriggerEvent('vxbm:server:setMetaData', amount, target)
end, true)