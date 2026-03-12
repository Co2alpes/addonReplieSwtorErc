# Addon Repli - SWTOR RP

Un système d'alerte de repli optimisé pour serveur Garry's Mod (DarkRP/StarWarsRP), permettant aux officiers de lancer une alerte visuelle et sonore uniquement pour leur propre faction.

🔗 **Dépôt GitHub** : [https://github.com/Co2alpes/addonReplieSwtorErc](https://github.com/Co2alpes/addonReplieSwtorErc)

## 📋 Fonctionnalités

*   **Optimisation Réseau** : Utilise `net` pour n'envoyer l'information qu'aux joueurs concernés (ex: Les Siths ne voient pas l'alerte des Clones).
*   **Visuel Immersif** : HUD minimaliste clignotant avec typographie style Sci-Fi.
*   **Sonore** : Sons d'alarme configurables par faction.
*   **Configuration Facile** : Fichier unique pour gérer les jobs, couleurs et commandes.

## 🛠️ Installation

1.  Téléchargez ce dépôt ou faites un `git clone` dans le dossier `garrysmod/addons/` de votre serveur.
    ```bash
    cd garrysmod/addons/
    git clone https://github.com/Co2alpes/addonReplieSwtorErc.git repli_system
    ```
2.  Redémarrez votre serveur.

## ⚙️ Configuration (TRES IMPORTANT)

Vous **DEVEZ** configurer les Jobs (Teams) pour que l'addon fonctionne avec votre DarkRP.

1.  Ouvrez le fichier : `lua/autorun/sh_repli_config.lua`.
2.  Modifiez la section `REPLI.Config.Factions`.

### Exemple :

```lua
["empire"] = {
    name = "ALERTE IMPÉRIALE",
    command = "/repliemp",
    color = Color(200, 0, 0), -- Rouge
    sound = "ambient/alarms/klaxon1.wav",
    
    -- Jobs qui VOIENT l'alerte (Tous les soldats)
    teams = {
        TEAM_STORMTROOPER,
        TEAM_SITH,
        TEAM_OFFICIER -- Ajoutez vos vraies variables de jobs ici !
    },
    
    -- Jobs qui peuvent LANCER la commande (Officiers uniquement)
    leaders = {
        TEAM_SITH,
        TEAM_OFFICIER
    }
},
```

*   **Remplacer `TEAM_XXX`** : Assurez-vous d'utiliser les noms de variables définis dans votre `jobs.lua` DarkRP (ex: `TEAM_501ST`, `TEAM_JEDI`).
*   **Ajouter une faction** : Copiez-collez un bloc faction entier et changez la clé (ex: `["mandalorien"]`).

## 🎮 Utilisation

Une fois en jeu, si vous avez un métier listé dans la table `leaders` :

1.  Ouvrez le chat.
2.  Tapez la commande configurée (ex: `/repliemp` ou `/replirep`).
3.  L'alerte se déclenche pour tous les membres de la faction pendant la durée définie (`REPLI.Config.Duration`).

## 📁 Structure des fichiers

*   `lua/config/sh_repli_config.lua` : Configuration principale (Teams, Couleurs, Sons).
*   `lua/autorun/server/sv_repli.lua` : Logique serveur (Vérification des accès, Envoi réseau).
*   `lua/autorun/client/cl_repli.lua` : Logique client (Affichage HUD, Son).
