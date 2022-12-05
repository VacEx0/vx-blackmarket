Config = {}

Config.useItemCost = true       -- Whether or not to use items such as dirty money for item cost.
Config.costItem = 'rolledbills' -- The item to take from the player for purchasing.

Config.marketItems = {
    ['lockpick'] = {
        itemCost = 500,
        requiredRep = 0,
        rewardRep = 5
    },
    ['advancedlockpick'] = {
        itemCost = 1000,
        requiredRep = 500,
        rewardRep = 10
    }
}

Config.blackmarketPedModels = {
    'a_m_m_mlcrisis_01',
    'a_m_y_mexthug_01',
    'a_m_y_cyclist_01',
    'a_m_m_socenlat_01'
}

Config.scenarios = {
    'WORLD_HUMAN_AA_SMOKE',
    'WORLD_HUMAN_DRUG_DEALER',
    'WORLD_HUMAN_DRUG_DEALER_HARD',
}

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