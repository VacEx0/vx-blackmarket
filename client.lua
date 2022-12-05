local QBCore = exports['qb-core']:GetCoreObject()
local pedData = { data = {}, loaded = false }
local ShopItems = { label="Black Market", items={} }
local marketType = 'shop'
local rep = 0

if Config.useItemCost then marketType = 'customPayShop' end

function setupNewPed(data)
    local ped = NetworkGetEntityFromNetworkId(data.netId)
    TaskStartScenarioInPlace(ped, data.scenario, 0, true)
    SetEntityInvincible(ped, true)
    SetPedCanBeTargetted(ped, toggle)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

function setupItems()
    rep = QBCore.Functions.GetPlayerData().metadata["bmrep"]
    ShopItems.items = {}
    local slot = 1

    for item, settings in pairs(Config.marketItems) do
        if rep >= settings.requiredRep then
            ShopItems.items[slot] = {
                name = item,
                price = settings.itemCost,
                removeItem = Config.costItem,
                amount = 50,
                info = {},
                type = 'item',
                slot = slot
            }
            slot = slot + 1
        end
    end
    
    print(rep)

    ShopItems.slots = slot - 1
    TriggerServerEvent('inventory:server:OpenInventory', marketType, 'BlackMarket_'..tostring(math.random(0, 999)), ShopItems)
end

CreateThread(function()
    while not pedData.loaded do Wait(10) end
    for i, data in pairs(pedData.data) do
        CreateThread(function()
            while not NetworkDoesEntityExistWithNetworkId(data.netId) do Wait(10000) end
            local blackmarketPed = setupNewPed(data)
            exports['qb-target']:AddTargetEntity(blackmarketPed, {
                options = {
                    {
                        icon = 'fas fa-shop-lock',
                        label = 'Browse Market',
                        action = function()
                            setupItems()
                        end,
                        canInteract = function(entity, distance, data)
                            -- Todo: Make police unable to interact
                            return true
                        end
                    }
                },
                distance = 2.5
            })
        end)
    end
end)

RegisterNetEvent('vxbm:client:updateRep')
AddEventHandler('vxbm:client:updateRep', function(slot, amount)
    for i, item in pairs(ShopItems.items) do
        if tostring(item.slot) == slot then
            local reward = Config.marketItems[item.name].rewardRep * amount
            local liveRep = QBCore.Functions.GetPlayerData().metadata["bmrep"]
            TriggerServerEvent('vxbm:server:setMetaData', liveRep + reward)
            return
        end
    end
end)

TriggerServerEvent('vxbm:sever:requestPedData')
RegisterNetEvent('vxbm:client:updatePedData')
AddEventHandler('vxbm:client:updatePedData', function(data) pedData = data end)

TriggerEvent('chat:addSuggestion', '/setbmrep', 'Sets the specified players Black Market reputation.', {
    { name="ID", help="Player ID" },
    { name="Reputation", help="Desired reputation." }
})