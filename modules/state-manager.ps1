# Module de Gestion d'État
# Utilitaire pour maintenir et synchroniser les états des agents

param(
    [string]$Action = "lire",
    [string]$Agent = "",
    [hashtable]$NouvelEtat = @{}
)

$BasePath = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$DataPath = Join-Path $BasePath "data"
$StateFile = Join-Path $DataPath "agent-states.json"

function Initialize-StateFile {
    if (-not (Test-Path $StateFile)) {
        $initialState = @{
            timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            agents = @()
            harmonie_globale = 0.5
        }
        $initialState | ConvertTo-Json -Depth 3 | Set-Content $StateFile
    }
}

function Get-AgentState {
    param([string]$AgentName)
    
    if (Test-Path $StateFile) {
        $content = Get-Content $StateFile -Raw
        $states = $content | ConvertFrom-Json
        return $states.agents | Where-Object { $_.nom -eq $AgentName }
    }
    return $null
}

function Set-AgentState {
    param([string]$AgentName, [hashtable]$Etat)
    
    Initialize-StateFile
    $content = Get-Content $StateFile -Raw
    $states = $content | ConvertFrom-Json
    
    # Recherche de l'agent existant
    $agentIndex = -1
    for ($i = 0; $i -lt $states.agents.Count; $i++) {
        if ($states.agents[$i].nom -eq $AgentName) {
            $agentIndex = $i
            break
        }
    }
    
    $nouvelAgent = @{
        nom = $AgentName
        statut = $Etat.statut
        resonance = $Etat.resonance
        derniere_activite = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    
    if ($agentIndex -ge 0) {
        $states.agents[$agentIndex] = $nouvelAgent
    } else {
        $states.agents += $nouvelAgent
    }
    
    $states.timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $states | ConvertTo-Json -Depth 3 | Set-Content $StateFile
}

# Exécution selon l'action demandée
switch ($Action.ToLower()) {
    "lire" {
        if ($Agent) {
            $etat = Get-AgentState -AgentName $Agent
            if ($etat) {
                Write-Output "Agent: $($etat.nom) | Statut: $($etat.statut) | Résonance: $($etat.resonance)"
            } else {
                Write-Output "Agent '$Agent' non trouvé"
            }
        } else {
            Initialize-StateFile
            $content = Get-Content $StateFile -Raw
            $states = $content | ConvertFrom-Json
            Write-Output "=== ÉTATS DES AGENTS ==="
            if ($states.agents -and $states.agents.Count -gt 0) {
                for ($i = 0; $i -lt $states.agents.Count; $i++) {
                    $currentAgent = $states.agents[$i]
                    Write-Host "$($currentAgent.nom) : $($currentAgent.statut) (Résonance: $($currentAgent.resonance))"
                }
            } else {
                Write-Output "Aucun agent enregistré"
            }
            Write-Output "Harmonie globale: $($states.harmonie_globale)"
        }
    }
    
    "ecrire" {
        if ($Agent -and $NouvelEtat.Count -gt 0) {
            Set-AgentState -AgentName $Agent -Etat $NouvelEtat
            Write-Output "État de '$Agent' mis à jour"
        } else {
            Write-Output "Paramètres insuffisants pour l'écriture"
        }
    }
    
    "reset" {
        Remove-Item $StateFile -Force -ErrorAction SilentlyContinue
        Write-Output "États réinitialisés"
    }
}