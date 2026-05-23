-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — CLIENT/ADMIN.LUA
-- ============================================================

-- Récupérer la position et orientation actuelle du joueur pour la configuration
RegisterNUICallback('getCurrentCoords', function(data, cb)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    cb({
        x = math.floor(coords.x * 100) / 100,
        y = math.floor(coords.y * 100) / 100,
        z = math.floor(coords.z * 100) / 100,
        w = math.floor(heading * 100) / 100
    })
end)

-- Sauvegarder la configuration d'une fourrière (Appelle le serveur)
RegisterNUICallback('saveImpoundConfig', function(data, cb)
    cb({ success = true }) -- Résolution instantanée pour éviter tout freeze CEF/NUI
    ESX.TriggerServerCallback('bl_garage:saveImpound', function(success)
        -- Traitement silencieux en tâche de fond (la synchronisation globale mettra à jour l'état)
    end, data.garageId, data.config)
end)

-- Supprimer la configuration d'un garage ou d'une fourrière (Appelle le serveur)
RegisterNUICallback('deleteGarage', function(data, cb)
    cb({ success = true }) -- Résolution instantanée pour éviter tout freeze CEF/NUI
    ESX.TriggerServerCallback('bl_garage:deleteGarage', function(success)
        -- Traitement silencieux en tâche de fond (la synchronisation globale mettra à jour l'état)
    end, data.garageId)
end)

-- Callback NUI pour démarrer la sélection interactive de coordonnées sur place
RegisterNUICallback('startPositionSelection', function(data, cb)
    local selectionType = data.type or 'ped'
    
    -- Activer l'état de sélection pour bloquer la boucle d'interaction principale
    IsSelectingCoords = true
    
    -- 1. Masquer temporairement l'interface NUI (sans détruire l'état)
    SendNUIMessage({ action = "tempHide" })
    SetNuiFocus(false, false)
    
    -- Notification sonore discrète
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    
    -- 2. Démarrer la boucle asynchrone de sélection interactive
    Citizen.CreateThread(function()
        local selecting = true
        
        -- Empêcher le spam de validation immédiate si la touche E était déjà enfoncée
        Citizen.Wait(200)
        
        while selecting do
            Citizen.Wait(0)
            
            -- Affiche le texte d'aide à l'écran
            local labelType = "Spawn Véhicule"
            if selectionType == "ped" then
                labelType = "Position PNJ"
            elseif selectionType == "delete" then
                labelType = "Rangement Véhicule"
            end
            local displayMsg = "~y~[ADMIN]~s~ Mode Sélection (~g~" .. string.upper(labelType) .. "~s~)\nPositionnez-vous sur le point désiré.\n~g~[E]~s~ pour valider la position | ~r~[BACKSPACE]~s~ pour annuler"
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName(displayMsg)
            EndTextCommandDisplayHelp(0, false, true, -1)
            
            -- Bloquer temporairement certaines touches de combat/tir pour éviter les accidents
            DisableControlAction(0, 24, true) -- Tirer
            DisableControlAction(0, 25, true) -- Visée
            DisableControlAction(0, 37, true) -- Menu armes
            DisableControlAction(0, 140, true) -- Attaque corps à corps
            
            -- Touche [E] pressée : Validation de la position
            if IsControlJustReleased(0, 38) then
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local heading = GetEntityHeading(playerPed)
                
                -- Arrêter la boucle et réinitialiser l'état
                selecting = false
                IsSelectingCoords = false
                
                -- Rétablir le focus NUI
                SetNuiFocus(true, true)
                
                -- Envoyer les coordonnées au NUI
                SendNUIMessage({
                    action = "coordsSelected",
                    type = selectionType,
                    coords = {
                        x = math.floor(coords.x * 100) / 100,
                        y = math.floor(coords.y * 100) / 100,
                        z = math.floor(coords.z * 100) / 100,
                        w = math.floor(heading * 100) / 100
                    }
                })
                
                -- Rétablir visuellement le NUI
                SendNUIMessage({ action = "tempRestore" })
                
                -- Notification sonore de validation
                PlaySoundFrontend(-1, "Challenge_Passed", "HUD_AWARDS", true)
                ESX.ShowNotification("~g~[ADMIN]~s~ Position enregistrée avec succès !")
                
            -- Touche [BACKSPACE] / [CELLPHONE_CANCEL] pressée : Annulation
            elseif IsControlJustReleased(0, 177) then
                -- Arrêter la boucle et réinitialiser l'état
                selecting = false
                IsSelectingCoords = false
                
                -- Rétablir le focus NUI et l'affichage sans modification
                SetNuiFocus(true, true)
                SendNUIMessage({ action = "tempRestore" })
                
                -- Notification sonore d'annulation
                PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                ESX.ShowNotification("~r~[ADMIN]~s~ Sélection de position annulée.")
            end
        end
    end)
    
    cb('ok')
end)

-- Synchronisation en temps réel de tous les points de garage et fourrière depuis le serveur
RegisterNetEvent('bl_garage:syncGarages')
AddEventHandler('bl_garage:syncGarages', function(loaded, notify)
    if not loaded then loaded = {} end
    debugPrint('^2[bl_garage] Synchronisation dynamique reçue. Mise à jour des garages...^0')
    
    -- Supprimer d'abord les anciens garages personnalisés qui ne sont plus présents dans la liste synchronisée ou marqués comme supprimés
    for id, garage in pairs(Config.Garages) do
        local idStr = tostring(id)
        if (string.match(idStr, "^impound_custom_") and not loaded[idStr]) or (loaded[idStr] and loaded[idStr].deleted) then
            Config.Garages[id] = nil
        end
    end

    for id, data in pairs(loaded) do
        if data then
            if data.deleted then
                Config.Garages[tostring(id)] = nil
            elseif data.coords and data.spawn then
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

                local spawnPoints = nil
                local firstSpawn = nil
                if type(data.spawn) == 'table' and data.spawn[1] then
                    spawnPoints = {}
                    for _, pt in ipairs(data.spawn) do
                        table.insert(spawnPoints, vector4(pt.x or 0.0, pt.y or 0.0, pt.z or 0.0, pt.w or pt.heading or 0.0))
                    end
                    firstSpawn = data.spawn[1]
                else
                    spawnPoints = vector4(data.spawn.x or 0.0, data.spawn.y or 0.0, data.spawn.z or 0.0, data.spawn.w or data.spawn.heading or 0.0)
                    firstSpawn = data.spawn
                end

                local localData = {
                    label = data.label,
                    type = pointType,
                    coords = vector3(data.coords.x or 0.0, data.coords.y or 0.0, data.coords.z or 0.0),
                    pedModel = data.pedModel or "s_m_y_xmech_01",
                    pedHeading = tonumber(data.pedHeading) or 0.0,
                    spawn = spawnPoints,
                    delete = (pointType ~= "impound") and (data.delete and vector3(data.delete.x or 0.0, data.delete.y or 0.0, data.delete.z or 0.0) or vector3(firstSpawn.x or 0.0, firstSpawn.y or 0.0, firstSpawn.z or 0.0)) or nil,
                    blip = { active = true, sprite = blipSprite, color = blipColor, scale = 0.8, label = data.label },
                    job = nil
                }
                Config.Garages[tostring(id)] = localData
            end
        end
    end
    
    -- Ré-initialiser les PNJs et les Blips pour appliquer immédiatement les modifications
    initGarage()
    if notify and ESX then
        ESX.ShowNotification("~g~[ADMIN]~s~ Configuration mise à jour en temps réel !")
    end
end)

-- Événement pour ouvrir le menu d'administration générale
RegisterNetEvent('bl_garage:openMasterAdmin')
AddEventHandler('bl_garage:openMasterAdmin', function()
    local allGaragesList = {}
    for id, g in pairs(Config.Garages) do
        local spawnData = nil
        if g.spawn then
            if type(g.spawn) == 'table' and g.spawn[1] then
                spawnData = {}
                for _, pt in ipairs(g.spawn) do
                    table.insert(spawnData, { x = pt.x, y = pt.y, z = pt.z, w = pt.w or pt.heading or 0.0 })
                end
            else
                spawnData = { x = g.spawn.x, y = g.spawn.y, z = g.spawn.z, w = g.spawn.w or g.spawn.heading or 0.0 }
            end
        end

        allGaragesList[id] = {
            label = g.label,
            type = g.type or "car",
            coords = { x = g.coords.x, y = g.coords.y, z = g.coords.z },
            pedModel = g.pedModel or "s_m_y_xmech_01",
            pedHeading = g.pedHeading or 0.0,
            spawn = spawnData or { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
            delete = g.delete and { x = g.delete.x, y = g.delete.y, z = g.delete.z } or nil
        }
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openMasterAdmin",
        isAdmin = true,
        impoundsList = allGaragesList
    })
end)

-- Suggestions pour le chat
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/garageadmin', 'Ouvrir le panneau d\'administration de tous les garages/fourrières.')
    TriggerEvent('chat:addSuggestion', '/admingarage', 'Ouvrir le panneau d\'administration de tous les garages/fourrières.')
end)
