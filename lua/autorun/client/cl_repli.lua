include("sh_config.lua")

-- Variables locales pour l'etat de l'alerte
local activeAlert = nil
local alertEndTime = 0
local textPulse = 0

-- Création d'une police d'ecriture aggressive/scifi
surface.CreateFont("REPLI_Font_Big", {
    font = "Trebuchet MS", -- Style standard, peut etre remplacé par une police SWTOR
    size = 50,
    weight = 800,
    antialias = true,
    outline = true,
})

surface.CreateFont("REPLI_Font_Sub", {
    font = "Trebuchet MS",
    size = 25,
    weight = 500,
    antialias = true,
})

-- Reception du message reseau
net.Receive("REPLI_TriggerAlert", function()
    local factionKey = net.ReadString()
    local data = REPLI.Config.Factions[factionKey]
    
    if data then
        activeAlert = data
        alertEndTime = CurTime() + REPLI.Config.Duration
        
        -- Jouer le son
        surface.PlaySound(data.sound)
        
        -- Message console pour debug
        print("[REPLI] Alerte recue: " .. data.name)
    end
end)

-- Rendu HUD
hook.Add("HUDPaint", "REPLI_DrawHUD", function()
    -- Si pas d'alerte ou temps ecoule, on ne dessine rien
    if not activeAlert or CurTime() > alertEndTime then 
        activeAlert = nil
        return 
    end

    local w, h = ScrW(), ScrH()
    local timeLeft = math.ceil(alertEndTime - CurTime())

    -- Calcul du clignotement (Sinusoidal)
    -- Vitesse rapide pour un effet d'urgence
    local alphaPulse = math.abs(math.sin(CurTime() * 5)) * 255
    
    -- Couleur de base de la faction
    local col = activeAlert.color
    local blinkColor = Color(col.r, col.g, col.b, alphaPulse)

    -- --- DESSIN DU HUD ---

    -- 1. Barre ou boite d'arriere plan (Optionnel, ici style minimaliste SWTOR)
    -- On centre en haut de l'ecran
    local boxW, boxH = 600, 100
    local boxX, boxY = (w / 2) - (boxW / 2), h * 0.15

    -- Fond semi-transparent
    draw.RoundedBox(0, boxX, boxY, boxW, boxH, Color(0, 0, 0, 150))
    
    -- Bordures clignotantes
    surface.SetDrawColor(blinkColor)
    surface.DrawOutlinedRect(boxX, boxY, boxW, boxH, 2)

    -- 2. Texte principal (ex: ALERTE IMPERIALE)
    draw.SimpleText(activeAlert.name, "REPLI_Font_Big", w / 2, boxY + 10, blinkColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    -- 3. Sous-titre (Instruction)
    draw.SimpleText("ORDRE DE REPLI IMMÉDIAT - " .. timeLeft .. "s", "REPLI_Font_Sub", w / 2, boxY + 60, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end)

print("[REPLI] Systeme client initialise.")
