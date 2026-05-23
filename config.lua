Config = {}

-- Langue du script
Config.Locale = 'fr'

-- Liste des identifiants (license:xxx, steam:xxx, discord:xxx, ip:xxx, live:xxx, xbl:xxx) ayant un accès admin garanti
Config.AdminIdentifiers = {
    -- Ajoutez vos identifiants ici (Exemple: "license:1abc2def...")
    -- "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
}

-- Groupes d'administration autorisés à accéder au menu de configuration
Config.AdminGroups = {
    ['superadmin'] = true,
    ['admin'] = true,
    ['mod'] = true,
    ['_dev'] = true,
    ['owner'] = true,
}

-- Prix de la récupération à la fourrière
Config.ImpoundFee = 10000

-- Prix du transfert depuis un autre garage (Valet de livraison)
Config.TransferFee = 500

-- Rayon pour vérifier si la zone de spawn est encombrée
Config.SpawnRadius = 6.0

-- Options d'affichage 3D / Markers dans le jeu
Config.Marker = {
    Type = 36, -- Symbole rotatif de clé/voiture
    Color = { r = 59, g = 130, b = 246, a = 150 }, -- Bleu moderne Indigo
    Size = { x = 0.8, y = 0.8, z = 0.8 },
    BobUpAndDown = true,
    FaceCamera = true,
    DrawDistance = 15.0
}

-- Configuration des différents garages et fourrière (100% Civils)
Config.Garages = {
    ["Legion"] = {
        label = "Garage Central",
        type = "car",
        coords = vector3(215.12, -809.95, 30.0), -- Position PNJ
        pedModel = "s_m_y_xmech_01",
        pedHeading = 250.0,
        spawn = vector4(224.28, -799.34, 30.6, 250.0),
        delete = vector3(211.5, -812.5, 30.0),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["Sandy"] = {
        label = "Garage Sandy Shores",
        type = "car",
        coords = vector3(1877.89, 3757.25, 32.8),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 300.0,
        spawn = vector4(1869.4, 3762.6, 33.1, 300.0),
        delete = vector3(1883.6, 3753.1, 32.8),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["Paleto"] = {
        label = "Garage Paleto Bay",
        type = "car",
        coords = vector3(-119.5, 6401.35, 31.4),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 45.0,
        spawn = vector4(-125.1, 6408.2, 31.6, 45.0),
        delete = vector3(-115.8, 6397.5, 31.4),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["Pillbox"] = {
        label = "Garage Pillbox Hill",
        type = "car",
        coords = vector3(-342.3, -901.2, 31.0),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 180.0,
        spawn = vector4(-332.5, -895.4, 31.0, 180.0),
        delete = vector3(-348.6, -906.5, 30.5),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["Vinewood"] = {
        label = "Garage Vinewood",
        type = "car",
        coords = vector3(336.8, 263.3, 105.1), -- Parking public Boulevard Vinewood
        pedModel = "s_m_y_xmech_01",
        pedHeading = 350.0,
        spawn = vector4(343.4, 258.2, 105.1, 350.0),
        delete = vector3(331.4, 266.8, 105.1),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["DelPerro"] = {
        label = "Garage Del Perro Beach",
        type = "car",
        coords = vector3(-1611.8, -827.2, 10.1), -- Parking public plage Del Perro
        pedModel = "s_m_y_xmech_01",
        pedHeading = 140.0,
        spawn = vector4(-1618.5, -835.4, 10.1, 140.0),
        delete = vector3(-1605.6, -820.5, 10.1),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["Davis"] = {
        label = "Garage Davis",
        type = "car",
        coords = vector3(275.6, -1620.2, 29.2),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 50.0,
        spawn = vector4(268.4, -1612.5, 29.2, 50.0),
        delete = vector3(280.4, -1625.6, 29.1),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["Marina"] = {
        label = "Garage Marina Puerto",
        type = "boat",
        coords = vector3(-812.4, -1345.6, 5.1), -- Sur le ponton (pédestre)
        pedModel = "s_m_y_xmech_01",
        pedHeading = 110.0,
        spawn = vector4(-804.5, -1340.2, 1.2, 110.0), -- Dans l'eau (niveau de la mer)
        delete = vector3(-818.2, -1350.5, 1.2), -- Dans l'eau
        blip = { active = true, sprite = 427, color = 3, scale = 0.8, label = "Garage (Bateaux)" },
        job = nil
    },
    ["AlamoSea"] = {
        label = "Garage Alamo Sea Boat",
        type = "boat",
        coords = vector3(1312.2, 4220.5, 33.9), -- Sur le ponton en bois
        pedModel = "s_m_y_xmech_01",
        pedHeading = 90.0,
        spawn = vector4(1304.5, 4214.2, 31.0, 90.0), -- Dans l'eau du lac Alamo Sea
        delete = vector3(1318.6, 4225.5, 31.0), -- Dans l'eau
        blip = { active = true, sprite = 427, color = 3, scale = 0.8, label = "Garage (Bateaux)" },
        job = nil
    },
    ["Airport"] = {
        label = "Garage Aéroport LS",
        type = "air",
        coords = vector3(-1258.2, -2702.4, 13.9), -- Tarmac devant le Hangar A17 à LSIA
        pedModel = "s_m_y_xmech_01",
        pedHeading = 140.0,
        spawn = vector4(-1250.5, -2708.2, 13.9, 140.0), -- Large zone de spawn sur le tarmac
        delete = vector3(-1264.4, -2695.5, 13.9),
        blip = { active = true, sprite = 307, color = 3, scale = 0.8, label = "Garage (Avions)" },
        job = nil
    },
    ["SandyAirfield"] = {
        label = "Garage Aérodrome Sandy",
        type = "air",
        coords = vector3(1744.1, 3274.6, 41.1), -- Sandy Shores Hangar
        pedModel = "s_m_y_xmech_01",
        pedHeading = 180.0,
        spawn = vector4(1734.2, 3278.4, 41.1, 180.0),
        delete = vector3(1752.5, 3270.2, 41.1),
        blip = { active = true, sprite = 307, color = 3, scale = 0.8, label = "Garage (Avions)" },
        job = nil
    },
    ["Richman"] = {
        label = "Garage Richman Glen",
        type = "car",
        coords = vector3(-1695.5, 87.2, 64.2), -- Parking public Université Richman
        pedModel = "s_m_y_xmech_01",
        pedHeading = 140.0,
        spawn = vector4(-1703.4, 93.6, 64.2, 140.0),
        delete = vector3(-1688.2, 81.5, 64.2),
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage (Voitures)" },
        job = nil
    },
    ["Fourriere"] = {
        label = "Fourrière Municipale",
        type = "impound",
        coords = vector3(408.61, -1625.47, 28.26),
        pedModel = "s_m_y_xmech_01", -- Modèle mécanicien standard super stable
        pedHeading = 230.0,
        spawn = vector4(405.64, -1643.4, 27.61, 229.54),
        delete = nil,
        blip = { active = true, sprite = 68, color = 5, scale = 0.8, label = "Fourrière Municipale" },
        job = nil
    },
    ["FourriereSandy"] = {
        label = "Fourrière Sandy Shores",
        type = "impound",
        coords = vector3(1651.38, 3804.84, 37.62),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 308.0,
        spawn = vector4(1627.84, 3788.45, 33.77, 308.53),
        delete = nil,
        blip = { active = true, sprite = 68, color = 5, scale = 0.8, label = "Fourrière Sandy Shores" },
        job = nil
    },
    ["FourrierePaleto"] = {
        label = "Fourrière Paleto Bay",
        type = "impound",
        coords = vector3(-234.82, 6198.65, 30.91),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 140.0,
        spawn = vector4(-230.08, 6190.24, 30.49, 140.24),
        delete = nil,
        blip = { active = true, sprite = 68, color = 5, scale = 0.8, label = "Fourrière Paleto Bay" },
        job = nil
    }
}



-- Dictionnaire de labels personnalisés pour l'interface UI
Config.VehicleLabels = {
    -- Supercars & Sportives
    ["adder"] = "Truffade Adder",
    ["t20"] = "Progen T20",
    ["zentorno"] = "Pegassi Zentorno",
    ["turismor"] = "Grotti Turismo R",
    ["cheetah"] = "Grotti Cheetah",
    ["vacca"] = "Pegassi Vacca",
    ["bullet"] = "Vapid Bullet",
    ["infernus"] = "Pegassi Infernus",
    ["sultan"] = "Karin Sultan",
    ["banshee"] = "Bravado Banshee",
    ["elegy"] = "Annis Elegy RH8",
    ["jester"] = "Dinka Jester",
    ["massacro"] = "Dewbauchee Massacro",
    ["comet2"] = "Pfister Comet",
    ["carbonizzare"] = "Grotti Carbonizzare",
    ["ninef"] = "Obey 9F",
    ["sentinel"] = "Ubermacht Sentinel",
    
    -- Berlines & Classiques
    ["panto"] = "Benefactor Panto",
    ["kuruma"] = "Karin Kuruma",
    ["exemplar"] = "Dewbauchee Exemplar",
    ["felon"] = "Lampadati Felon",
    ["jackal"] = "Ocelot Jackal",
    ["oracle"] = "Ubermacht Oracle",
    ["tailgater"] = "Obey Tailgater",
    ["schafter2"] = "Benefactor Schafter",
    ["buffalo"] = "Bravado Buffalo",
    ["fugitive"] = "Cheval Fugitive",
    ["premier"] = "Declasse Premier",
    ["stanier"] = "Vapid Stanier",
    ["washington"] = "Albany Washington",
    
    -- SUVs & Tout-terrain
    ["baller"] = "Gallivanter Baller",
    ["cavalcade"] = "Albany Cavalcade",
    ["rocoto"] = "Obey Rocoto",
    ["granger"] = "Declasse Granger",
    ["dubsta"] = "Benefactor Dubsta",
    ["patriot"] = "Mammoth Patriot",
    ["landstalker"] = "Dundreary Landstalker",
    ["mesa"] = "Canis Mesa",
    ["sandking"] = "Vapid Sandking",
    ["bison"] = "Bravado Bison",
    ["rebel"] = "Karin Rebel",
    
    -- Motos
    ["bati"] = "Pegassi Bati 801",
    ["akuma"] = "Dinka Akuma",
    ["double"] = "Dinka Double T",
    ["hakuchou"] = "Shitzu Hakuchou",
    ["ruffian"] = "Pegassi Ruffian",
    ["sanchez"] = "Maibatsu Sanchez",
    ["faggio2"] = "Pegassi Faggio",
    
    -- Services & Police
    ["police"] = "Vapid Interceptor LSPD",
    ["police2"] = "Vapid Cruiser LSPD",
    ["police3"] = "Vapid Interceptor Slick",
    ["police4"] = "Vapid Cruiser Banalisé",
    ["sheriff"] = "Declasse Sheriff Granger",
    ["sheriff2"] = "Vapid Sheriff Cruiser",
}

-- Traduction
Config.Translations = {
    ['fr'] = {
        ['open_garage'] = "Appuyez sur ~INPUT_CONTEXT~ pour parler au ~b~Garagiste~s~.",
        ['open_impound'] = "Appuyez sur ~INPUT_CONTEXT~ pour parler à l'~b~Agent de Fourrière~s~.",
        ['store_vehicle'] = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre ~b~véhicule~s~.",
        ['not_owner'] = "Ce véhicule ne vous appartient pas.",
        ['no_vehicle'] = "Aucun véhicule à proximité.",
        ['spawn_blocked'] = "La zone de sortie est encombrée par un autre véhicule.",
        ['vehicle_spawned'] = "Votre véhicule a été sorti !",
        ['vehicle_stored'] = "Votre véhicule a été rangé avec succès.",
        ['not_enough_money'] = "Vous n'avez pas assez d'argent (%s$ requis).",
        ['impound_retrieved'] = "Vous avez payé %s$ pour récupérer votre véhicule.",
        ['no_owned_vehicles'] = "Vous ne possédez aucun véhicule dans ce garage.",
        ['garage_restricted'] = "Ce garage est réservé aux membres de la faction : %s.",
        ['stored_status'] = "Rangé",
        ['out_status'] = "Sorti",
        ['impounded_status'] = "Fourrière",
    }
}

-- Helper fonction de traduction
function _T(str, ...)
    local lang = Config.Locale or 'fr'
    local translation = Config.Translations[lang] and Config.Translations[lang][str] or str
    return string.format(translation, ...)
end

-- Activer le débogage pour afficher les logs de diagnostic détaillés (Désactivé par défaut)
Config.Debug = false

-- Helper global de débogage pour désencombrer les consoles F8 et serveur
function debugPrint(msg)
    if Config.Debug then
        print(msg)
    end
end
