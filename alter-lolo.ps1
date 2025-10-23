#Requires -Version 5.1
<#
.SYNOPSIS
    Agent suprême thérapeutique ludique - alter-lolo
.DESCRIPTION
    Orchestrateur principal pour l'IA locale alter-lolo.
    Lit les manifestes, exécute les agents, écrit dans les logs.
.NOTES
    Aucune dépendance externe requise.
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "Run",
    
    [Parameter(Mandatory=$false)]
    [string]$AgentName = ""
)

# Configuration des chemins
$ScriptRoot = $PSScriptRoot
$AgentsPath = Join-Path $ScriptRoot "agents"
$ManifestesPath = Join-Path $ScriptRoot "manifestes"
$LogsPath = Join-Path $ScriptRoot "logs"
$DataPath = Join-Path $ScriptRoot "data"
$ModulesPath = Join-Path $ScriptRoot "modules"

# Fonction d'écriture dans les logs
function Write-AlterLoloLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    $LogFile = Join-Path $LogsPath "alter-lolo-$(Get-Date -Format 'yyyy-MM-dd').log"
    
    # Afficher dans la console
    Write-Host $LogMessage
    
    # Écrire dans le fichier log
    Add-Content -Path $LogFile -Value $LogMessage
}

# Fonction de lecture des manifestes
function Read-Manifest {
    param(
        [string]$ManifestName
    )
    
    $ManifestPath = Join-Path $ManifestesPath "$ManifestName.json"
    
    if (Test-Path $ManifestPath) {
        try {
            $ManifestContent = Get-Content $ManifestPath -Raw | ConvertFrom-Json
            Write-AlterLoloLog "Manifeste chargé : $ManifestName"
            return $ManifestContent
        }
        catch {
            Write-AlterLoloLog "Erreur lors de la lecture du manifeste $ManifestName : $_" -Level "ERROR"
            return $null
        }
    }
    else {
        Write-AlterLoloLog "Manifeste introuvable : $ManifestPath" -Level "WARNING"
        return $null
    }
}

# Fonction d'exécution d'un agent
function Invoke-Agent {
    param(
        [string]$AgentScript,
        [hashtable]$Parameters = @{}
    )
    
    $AgentPath = Join-Path $AgentsPath $AgentScript
    
    if (Test-Path $AgentPath) {
        try {
            Write-AlterLoloLog "Exécution de l'agent : $AgentScript"
            
            # Préparer les paramètres pour l'agent
            $ParamString = ""
            foreach ($key in $Parameters.Keys) {
                $ParamString += " -$key `"$($Parameters[$key])`""
            }
            
            # Exécuter l'agent
            $Result = & $AgentPath @Parameters
            
            Write-AlterLoloLog "Agent $AgentScript terminé avec succès"
            return $Result
        }
        catch {
            Write-AlterLoloLog "Erreur lors de l'exécution de l'agent $AgentScript : $_" -Level "ERROR"
            return $null
        }
    }
    else {
        Write-AlterLoloLog "Agent introuvable : $AgentPath" -Level "ERROR"
        return $null
    }
}

# Fonction de découverte des agents disponibles
function Get-AvailableAgents {
    if (Test-Path $AgentsPath) {
        $Agents = Get-ChildItem -Path $AgentsPath -Filter "*.ps1"
        return $Agents
    }
    return @()
}

# Fonction de découverte des manifestes disponibles
function Get-AvailableManifests {
    if (Test-Path $ManifestesPath) {
        $Manifests = Get-ChildItem -Path $ManifestesPath -Filter "*.json"
        return $Manifests
    }
    return @()
}

# Initialisation
Write-AlterLoloLog "=== Démarrage d'alter-lolo ===" -Level "INFO"
Write-AlterLoloLog "Action demandée : $Action"

# Traitement des actions
switch ($Action.ToLower()) {
    "run" {
        # Charger le manifeste principal
        $MainManifest = Read-Manifest -ManifestName "alter-lolo"
        
        if ($MainManifest) {
            Write-AlterLoloLog "Configuration : $($MainManifest.name) v$($MainManifest.version)"
            
            # Exécuter les agents définis dans le manifeste
            if ($MainManifest.agents) {
                foreach ($agent in $MainManifest.agents) {
                    $params = @{}
                    if ($agent.parameters) {
                        $agent.parameters.PSObject.Properties | ForEach-Object {
                            $params[$_.Name] = $_.Value
                        }
                    }
                    Invoke-Agent -AgentScript $agent.script -Parameters $params
                }
            }
        }
        else {
            Write-AlterLoloLog "Aucun manifeste principal trouvé, mode découverte" -Level "WARNING"
            
            # Lister les agents disponibles
            $AvailableAgents = Get-AvailableAgents
            Write-AlterLoloLog "Agents disponibles : $($AvailableAgents.Count)"
            foreach ($agent in $AvailableAgents) {
                Write-AlterLoloLog "  - $($agent.Name)"
            }
        }
    }
    
    "list" {
        # Lister tous les agents et manifestes
        Write-AlterLoloLog "=== Agents disponibles ==="
        $Agents = Get-AvailableAgents
        foreach ($agent in $Agents) {
            Write-AlterLoloLog "  - $($agent.Name)"
        }
        
        Write-AlterLoloLog "=== Manifestes disponibles ==="
        $Manifests = Get-AvailableManifests
        foreach ($manifest in $Manifests) {
            Write-AlterLoloLog "  - $($manifest.Name)"
        }
    }
    
    "agent" {
        if ($AgentName) {
            # Exécuter un agent spécifique
            Invoke-Agent -AgentScript "$AgentName.ps1"
        }
        else {
            Write-AlterLoloLog "Nom d'agent requis pour l'action 'agent'" -Level "ERROR"
        }
    }
    
    default {
        Write-AlterLoloLog "Action inconnue : $Action" -Level "ERROR"
        Write-AlterLoloLog "Actions valides : Run, List, Agent"
    }
}

Write-AlterLoloLog "=== Fin d'exécution d'alter-lolo ==="
