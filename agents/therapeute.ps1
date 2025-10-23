#Requires -Version 5.1
<#
.SYNOPSIS
    Agent thérapeutique - Conseils et assistance
.DESCRIPTION
    Agent spécialisé dans l'accompagnement thérapeutique ludique.
.PARAMETER Message
    Message ou requête de l'utilisateur
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Message = "Bonjour"
)

# Chemin pour les données
$DataPath = Join-Path $PSScriptRoot "..\data"

# Fonction principale de l'agent
function Invoke-TherapeuticResponse {
    param([string]$Input)
    
    Write-Host "🌟 Agent Thérapeute activé 🌟"
    Write-Host "Message reçu : $Input"
    
    # Réponses thérapeutiques simples
    $Responses = @(
        "Je suis là pour vous écouter. Comment vous sentez-vous aujourd'hui ?",
        "Chaque jour est une nouvelle opportunité de croissance.",
        "Vos émotions sont valides et importantes.",
        "Prenez un moment pour respirer profondément.",
        "Vous faites de votre mieux, et c'est ce qui compte."
    )
    
    # Sélectionner une réponse aléatoire
    $Response = $Responses | Get-Random
    
    Write-Host "Réponse : $Response"
    
    # Enregistrer l'interaction dans les données
    $Interaction = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Agent = "therapeute"
        Message = $Input
        Response = $Response
    }
    
    $DataFile = Join-Path $DataPath "interactions.json"
    
    # Charger les interactions existantes
    $AllInteractions = [System.Collections.ArrayList]@()
    if (Test-Path $DataFile) {
        $JsonContent = Get-Content $DataFile -Raw | ConvertFrom-Json
        if ($JsonContent) {
            if ($JsonContent -is [array]) {
                $AllInteractions.AddRange($JsonContent)
            } else {
                $AllInteractions.Add($JsonContent) | Out-Null
            }
        }
    }
    
    # Ajouter la nouvelle interaction
    $AllInteractions.Add($Interaction) | Out-Null
    
    # Sauvegarder
    $AllInteractions | ConvertTo-Json | Set-Content $DataFile
    
    return $Response
}

# Exécuter l'agent
Invoke-TherapeuticResponse -Input $Message
