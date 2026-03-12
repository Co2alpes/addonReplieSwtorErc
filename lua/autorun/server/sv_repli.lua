-- Configuration chargée automatiquement via lua/autorun/sh_repli_config.lua
-- Client init chargé automatiquement via lua/autorun/client/cl_repli.lua

-- Initialisation du reseau
util.AddNetworkString("REPLI_TriggerAlert")

-- Fonction principale pour declencher l'alerte
local function TriggerRepli(factionKey, leaderPly)
    local factionData = REPLI.Config.Factions[factionKey]
    if not factionData then return end

    -- Filtrer les joueurs : Seuls les membres de la faction recoivent l'alerte
    local recipients = {}
    
    for _, ply in ipairs(player.GetAll()) do
        if REPLI:IsPlayerInTeamList(ply, factionData.teams) then
            table.insert(recipients, ply)
        end
    end

    -- Envoyer le message reseau uniquement aux concernés (Optimisation)
    if #recipients > 0 then
        net.Start("REPLI_TriggerAlert")
            net.WriteString(factionKey) -- On envoie juste la clé, la config est partagée
        net.Send(recipients)

        -- Feedback pour le leader qu ia lance la commande
        leaderPly:ChatPrint("[REPLI] L'ordre de repli a été envoyé à " .. #recipients .. " troupes.")
    else
        leaderPly:ChatPrint("[REPLI] Aucune troupe de votre faction n'est en ligne.")
    end
end

-- Hook sur le chat
hook.Add("PlayerSay", "REPLI_CommandListener", function(ply, text)
    text = string.lower(text) -- Gestion de la casse
    
    for key, data in pairs(REPLI.Config.Factions) do
        if text == data.command then
            -- Verifier si le joueur est un leader autorise
            if REPLI:IsPlayerInTeamList(ply, data.leaders) then
                TriggerRepli(key, ply)
                return "" -- Cache la commande dans le chat
            else
                -- Optionnel : Message si pas leader (decommenter si voulu)
                -- ply:ChatPrint("[REPLI] Vous n'avez pas l'grade pour ordonner un repli.")
            end
        end
    end
end)

print("[REPLI] Systeme serveur initialise.")
