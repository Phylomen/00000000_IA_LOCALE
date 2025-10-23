#Requires -Version 5.1
<#
.SYNOPSIS
    Agent ludique - Jeux et divertissement
.DESCRIPTION
    Agent spécialisé dans les activités ludiques et le divertissement.
.PARAMETER Activity
    Type d'activité ludique demandée
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Activity = "random"
)

# Fonction principale de l'agent
function Invoke-LudicActivity {
    param([string]$ActivityType)
    
    Write-Host "🎮 Agent Ludique activé 🎮"
    Write-Host "Activité demandée : $ActivityType"
    
    switch ($ActivityType.ToLower()) {
        "blague" {
            $Jokes = @(
                "Pourquoi les plongeurs plongent-ils toujours en arrière ? Parce que sinon ils tombent dans le bateau !",
                "Qu'est-ce qu'un crocodile qui surveille la pharmacie ? Un Lacoste garde !",
                "Qu'est-ce qu'un canif ? Un petit fien !",
                "Comment appelle-t-on un chat tombé dans un pot de peinture ? Un chat-peint !",
                "Pourquoi les poissons n'aiment pas jouer au tennis ? Parce qu'ils ont peur du filet !"
            )
            $Result = $Jokes | Get-Random
        }
        "devinette" {
            $Riddles = @(
                "Je suis toujours devant toi mais tu ne peux jamais me voir. Qui suis-je ? (Réponse : L'avenir)",
                "Plus on m'enlève, plus je deviens grand. Qui suis-je ? (Réponse : Un trou)",
                "Je peux voler sans ailes. Je peux pleurer sans yeux. Qui suis-je ? (Réponse : Un nuage)",
                "Plus je suis chaud, plus je suis frais. Qui suis-je ? (Réponse : Le pain)",
                "Je commence la nuit et je termine le matin. Qui suis-je ? (Réponse : La lettre N)"
            )
            $Result = $Riddles | Get-Random
        }
        "conseil" {
            $Tips = @(
                "💡 Conseil du jour : Prenez une pause et faites quelques étirements !",
                "💡 Conseil du jour : Buvez un grand verre d'eau !",
                "💡 Conseil du jour : Souriez, même si personne ne vous regarde !",
                "💡 Conseil du jour : Écoutez votre musique préférée !",
                "💡 Conseil du jour : Faites une chose qui vous fait plaisir aujourd'hui !"
            )
            $Result = $Tips | Get-Random
        }
        default {
            # Activité aléatoire
            $RandomActivities = @("blague", "devinette", "conseil")
            $RandomActivity = $RandomActivities | Get-Random
            return Invoke-LudicActivity -ActivityType $RandomActivity
        }
    }
    
    Write-Host $Result
    return $Result
}

# Exécuter l'agent
Invoke-LudicActivity -ActivityType $Activity
