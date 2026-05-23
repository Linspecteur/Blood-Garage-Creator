-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — SERVER/ADMIN.LUA
-- ============================================================

-- Helper de permission d'administration
function isAdmin(source)
    if source == 0 then return true end
    
    -- 1. Vérification par permission FiveM globale 'command' (Tous les admins autorisés via txAdmin / server.cfg)
    if IsPlayerAceAllowed(source, "command") or IsPlayerAceAllowed(source, "command.bl_garage_admin") then
        debugPrint(string.format("^2[bl_garage DEBUG] isAdmin: Accès accordé par Ace Permission command/bl_garage_admin (source %s)^0", tostring(source)))
        return true
    end

    -- 2. Vérification par Identifiant Garanti (Config.AdminIdentifiers)
    local xPlayerSafe = nil
    if ESX then
        xPlayerSafe = ESX.GetPlayerFromId(source)
    end
    
    if xPlayerSafe and xPlayerSafe.identifier then
        if Config.AdminIdentifiers then
            for _, ident in ipairs(Config.AdminIdentifiers) do
                if string.lower(xPlayerSafe.identifier) == string.lower(ident) then
                    debugPrint(string.format("^2[bl_garage DEBUG] isAdmin: Accès garanti accordé pour l'identifiant %s (source %s)^0", tostring(xPlayerSafe.identifier), tostring(source)))
                    return true
                end
            end
        end
    end

    -- 3. Vérification par License FiveM brute (sécurité supplémentaire si ESX n'est pas encore prêt)
    local playerIdentifiers = GetPlayerIdentifiers(source)
    if playerIdentifiers and Config.AdminIdentifiers then
        for _, playerIdent in ipairs(playerIdentifiers) do
            for _, ident in ipairs(Config.AdminIdentifiers) do
                if string.lower(playerIdent) == string.lower(ident) then
                    debugPrint(string.format("^2[bl_garage DEBUG] isAdmin: Accès garanti accordé par License FiveM brute %s (source %s)^0", tostring(playerIdent), tostring(source)))
                    return true
                end
            end
        end
    end

    if ESX == nil then 
        debugPrint("^1[bl_garage DEBUG] isAdmin: ESX est NIL! Impossible de vérifier le groupe ESX.^0")
        return false 
    end
    local xPlayer = xPlayerSafe or ESX.GetPlayerFromId(source)
    if not xPlayer then 
        debugPrint(string.format("^1[bl_garage DEBUG] isAdmin: xPlayer est NIL pour la source %s!^0", tostring(source)))
        return false 
    end
    
    local group = nil
    if type(xPlayer.getGroup) == 'function' then
        group = xPlayer.getGroup()
    elseif xPlayer.group then
        group = xPlayer.group
    elseif type(xPlayer.get) == 'function' then
        group = xPlayer.get('group')
    end

    if group then
        group = string.lower(tostring(group))
    end

    debugPrint(string.format("^3[bl_garage DEBUG] Player source: %s | Identifier: %s | Group: %s^0", tostring(source), tostring(xPlayer.identifier), tostring(group)))

    if group and Config.AdminGroups and Config.AdminGroups[group] then
        return true
    end
    if group == 'admin' or group == 'superadmin' or group == 'mod' then
        return true
    end
    
    debugPrint(string.format("^1[bl_garage DEBUG] isAdmin: Accès refusé pour la source %s (Groupe: %s)^0", tostring(source), tostring(group)))
    return false
end

-- Enregistrer les Callbacks administratifs une fois ESX disponible
function registerAdminCallbacks()
    -- Callback : Enregistrer/Modifier un point de garage ou fourrière (Admin)
    ESX.RegisterServerCallback('bl_garage:saveImpound', function(source, cb, garageId, data)
        debugPrint(string.format("^3[bl_garage DEBUG] saveImpound déclenché pour l'ID: %s par le joueur: %s^0", tostring(garageId), tostring(source)))
        debugPrint(string.format("^3[bl_garage DEBUG] Données brutes reçues: %s^0", json.encode(data)))

        if not isAdmin(source) then
            debugPrint("^1[bl_garage DEBUG] ÉCHEC DE PERMISSION : Le joueur " .. tostring(source) .. " n'est pas admin !^0")
            cb(false)
            return
        end

        local pointType = data.type or "impound"
        local blipSprite = 357
        local blipColor = 3
        if pointType == "boat" then
            blipSprite = 427
            blipColor = 3
        elseif pointType == "air" then
            blipSprite = 307
            blipColor = 3
        elseif pointType == "impound" then
            blipSprite = 68
            blipColor = 5
        end

        data.pedModel = data.pedModel or "s_m_y_xmech_01"
        data.blip = { active = true, sprite = blipSprite, color = blipColor, scale = 0.8, label = data.label }

        -- Récupérer les propriétés d'origine si existantes
        local originalDelete = nil
        local originalJob = nil
        if Config.Garages[garageId] then
            originalDelete = Config.Garages[garageId].delete
            originalJob = Config.Garages[garageId].job
        end

        local spawnPoints = nil
        local firstSpawn = nil
        if type(data.spawn) == 'table' and data.spawn[1] then
            spawnPoints = {}
            for _, pt in ipairs(data.spawn) do
                table.insert(spawnPoints, vector4(pt.x or 0.0, pt.y or 0.0, pt.z or 0.0, pt.w or 0.0))
            end
            firstSpawn = data.spawn[1]
        else
            spawnPoints = vector4(data.spawn.x or 0.0, data.spawn.y or 0.0, data.spawn.z or 0.0, data.spawn.w or 0.0)
            firstSpawn = data.spawn
        end

        -- Convertir pour le Config local du serveur
        local localData = {
            label = data.label,
            type = pointType,
            coords = vector3(data.coords.x, data.coords.y, data.coords.z),
            pedModel = data.pedModel,
            pedHeading = tonumber(data.pedHeading) or 0.0,
            spawn = spawnPoints,
            delete = (pointType ~= "impound") and (data.delete and vector3(data.delete.x, data.delete.y, data.delete.z) or vector3(firstSpawn.x or 0.0, firstSpawn.y or 0.0, firstSpawn.z or 0.0)) or nil,
            blip = data.blip,
            job = originalJob
        }

        Config.Garages[garageId] = localData

        -- Mettre à jour notre cache en mémoire
        CustomGarages[garageId] = data
        
        -- Sauvegarder dans la base de données (100% Persistant et immunisé contre les écrasements de fichiers)
        MySQL.update("INSERT INTO bl_garages (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {
            garageId,
            json.encode(data),
            json.encode(data)
        }, function()
            debugPrint(string.format("^2[bl_garage DEBUG] Sauvegarde de %s dans la table bl_garages réussie !^0", garageId))
        end)

        -- Synchroniser avec tous les clients
        TriggerClientEvent('bl_garage:syncGarages', -1, CustomGarages, true)
        cb(true)
    end)

    -- Callback : Supprimer un point de garage ou fourrière (Admin)
    ESX.RegisterServerCallback('bl_garage:deleteGarage', function(source, cb, garageId)
        if not isAdmin(source) then
            cb(false)
            return
        end

        -- Supprimer du Config local
        Config.Garages[garageId] = nil

        -- Si c'est un point custom, on peut complètement le supprimer de CustomGarages & de la BDD
        -- Si c'est un point par défaut, on le marque comme deleted pour que ce soit persistant après reboot
        if string.match(tostring(garageId), "^impound_custom_") then
            CustomGarages[garageId] = nil
            MySQL.update("DELETE FROM bl_garages WHERE id = ?", { garageId }, function()
                debugPrint(string.format("^2[bl_garage DEBUG] Suppression de %s de la table bl_garages réussie !^0", garageId))
            end)
        else
            CustomGarages[garageId] = { deleted = true }
            MySQL.update("INSERT INTO bl_garages (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {
                garageId,
                json.encode({ deleted = true }),
                json.encode({ deleted = true })
            }, function()
                debugPrint(string.format("^2[bl_garage DEBUG] Masquage persistant de %s dans la table bl_garages réussi !^0", garageId))
            end)
        end

        -- Synchroniser avec tous les clients
        TriggerClientEvent('bl_garage:syncGarages', -1, CustomGarages, true)
        cb(true)
    end)
end

-- Commandes Admin /garageadmin et /admingarage pour ouvrir le menu de configuration global en jeu
local function openAdminPanel(source)
    local src = source
    if src == 0 then
        print("[bl_garage] Cette commande doit être exécutée en jeu par un administrateur.")
        return
    end

    if isAdmin(src) then
        TriggerClientEvent('bl_garage:openMasterAdmin', src)
    else
        TriggerClientEvent('esx:showNotification', src, "~r~Vous n'avez pas la permission d'utiliser cette commande.")
    end
end

RegisterCommand('garageadmin', function(source, args, rawCommand)
    openAdminPanel(source)
end, false)

RegisterCommand('admingarage', function(source, args, rawCommand)
    openAdminPanel(source)
end, false)

-- Hook d'initialisation découplé de l'ordre du manifeste
Citizen.CreateThread(function()
    while ESX == nil do
        local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok and result then
            ESX = result
        else
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
        Citizen.Wait(100)
    end
    registerAdminCallbacks()
end)
