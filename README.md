# vx-blackmarket
Simple Black Market script for QBCore servers.
*NOTE: This is a small project, and I am not actively working on it. There may be issues with the resource I am unaware of.*

## Dependencies
* qb-core
* qb-target
* lj-inventory or similar (tested on lj-inventory, but should work on qb-inventory and others like it)

## Installation
* Download files, and extract vx-blackmarket into your fivem resources folder.
* Add `start vx-blackmarket` to your config ***under qb-core***.

* `qb-core/server/player.lua` `AROUND LINE: 145`
```lua
PlayerData.metadata['bmrep'] = PlayerData.metadata['bmrep'] or 0 -- Added for vx-blackmarket
```

* `lj-inventory/server/main.lua` `AROUND LINE: 1245`
```lua
elseif name == "customPayShop" then
				secondInv.name = "citemshop-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = SetupShopItems(other.items)
				ShopItems[id] = {}
				ShopItems[id].items = other.items
				secondInv.slots = #other.items
```

* `lj-inventory/server/main.lua` `AROUND LINE: 1825`
```lua
elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "citemshop" then
		local shopType = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local itemData = ShopItems[shopType].items[fromSlot]
		local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
		local price = tonumber((itemData.price*fromAmount))
		local removeItem = itemData.removeItem
		if HasItem(src, removeItem, price) then
			AddItem(src, itemData.name, fromAmount, toSlot, itemData.info)
			for slot, item in pairs(Player.PlayerData.items) do
				if item.name == removeItem then
					RemoveItem(src, removeItem, price, item.slot)
					QBCore.Functions.Notify(src, itemInfo["label"] .. " bought!", "success")
					return
				end
			end
		else
			TriggerClientEvent('QBCore:Notify', src, "You can\'t afford this...", "error")
		end
```

## Configuration
```lua
Config = {}

Config.useItemCost = true       -- Whether or not to use items such as dirty money for item cost.
Config.costItem = 'rolledbills' -- The item to take from the player for purchasing.

Config.marketItems = {
    ['lockpick'] = {        -- Item to put in the blackmarket.
        itemCost = 500,     -- How much money or items it costs to purchase.
        requiredRep = 0,    -- Required blackmarket reputation.
        rewardRep = 5       -- Rewarded blackmarket reputation.
    },
    ['advancedlockpick'] = {
        itemCost = 1000,
        requiredRep = 500,
        rewardRep = 10
    }
}

Config.blackmarketPedModels = {   -- Ped models to spawn for interactions.
    'a_m_m_mlcrisis_01',
    'a_m_y_mexthug_01',
    'a_m_y_cyclist_01',
    'a_m_m_socenlat_01'
}

Config.scenarios = {    -- Scenarios to use on the peds.
    'WORLD_HUMAN_AA_SMOKE',
    'WORLD_HUMAN_DRUG_DEALER',
    'WORLD_HUMAN_DRUG_DEALER_HARD',
}

-- Locations --
-- {
--     model = 'ped_model',          -- Model for this location. (OPTIONAL, Random if not set)
--     scenario = 'SCENARIO_NAME',   -- Scenario for this location. (OPTIONAL, Random if not set)
--     coords = vector4(1, 2, 3, 4)  -- Vector4 coords to spawn the ped at for this location.
-- }
Config.locations = {
    { coords = vector4(2673.18, 3500.8, 53.3, 297.29) },
    {
        scenario = 'WORLD_HUMAN_BINOCULARS',
        coords = vector4(-185.33, 6157.3, 42.64, 44.08)
    },
    {
        model = 's_m_y_dockwork_01',
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        coords = vector4(-193.56, -1106.22, 30.14, 297.34)
    }
}
```
