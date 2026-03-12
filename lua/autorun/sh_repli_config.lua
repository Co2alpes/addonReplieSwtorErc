REPLI = REPLI or {}
REPLI.Config = {}

-- Duree de l'alerte en secondes
REPLI.Config.Duration = 15

-- Configuration des Factions
REPLI.Config.Factions = {
    ["empire"] = {
        name = "ALERTE IMPÉRIALE", -- Texte affiché
        command = "/repliemp", -- Commande chat
        color = Color(200, 0, 0), -- Rouge pour l'Empire
        sound = "ambient/alarms/klaxon1.wav", -- Son de l'alerte
        
        -- IDs des Jobs qui peuvent voir l'alerte (Membres de la faction)
        -- Remplacez TEAM_XXX par vos vrais noms de team (ex: TEAM_SITH, TEAM_STORMTROOPER)
        teams = {
            TEAM_CITIZEN, -- Placeholder: A remplacer
            TEAM_POLICE   -- Placeholder: A remplacer
        },
        
        -- IDs des Jobs qui peuvent LANCER l'alerte (Officiers/Leaders)
        leaders = {
            TEAM_POLICE -- Placeholder: A remplacer
        }
    },

    ["republic"] = {
        name = "ALERTE RÉPUBLICAINE",
        command = "/replirep",
        color = Color(0, 100, 255), -- Bleu pour la République
        sound = "ambient/alarms/siren.wav",
        
        teams = {
            TEAM_GANG, -- Placeholder: A remplacer
            TEAM_MOB   -- Placeholder: A remplacer
        },
        
        leaders = {
            TEAM_MOB -- Placeholder: A remplacer
        }
    }
}

-- Fonction utilitaire pour verifier si un joueur est dans une liste de teams
function REPLI:IsPlayerInTeamList(ply, teamList)
    if not IsValid(ply) then return false end
    local pTeam = ply:Team()
    
    for _, tID in pairs(teamList) do
        if pTeam == tID then return true end
    end
    return false
end
