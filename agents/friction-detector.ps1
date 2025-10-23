# Agent Détecteur de Frictions
# Identifie les tensions et dissonances dans le système

param(
    [double]$Seuil = 0.3,
    [string]$Mode = "detection"
)

$BasePath = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$DataPath = Join-Path $BasePath "data"
$LogsPath = Join-Path $BasePath "logs"

function Write-FrictionLog {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logFile = Join-Path $LogsPath "friction.log"
    Add-Content -Path $logFile -Value "[$timestamp] [FRICTION-DETECTOR] $Message"
}

function Detect-FrictionPoints {
    # Simulation de détection de frictions
    $frictions = @()
    $zones = @("mental", "emotionnel", "physique", "energetique", "social")
    
    foreach ($zone in $zones) {
        $niveau = Get-Random -Minimum 0.0 -Maximum 1.0
        if ($niveau -gt $Seuil) {
            $frictions += @{
                zone = $zone
                niveau = [math]::Round($niveau, 2)
                timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                recommandation = Get-Recommandation $zone $niveau
            }
        }
    }
    return $frictions
}

function Get-Recommandation {
    param([string]$Zone, [double]$Niveau)
    
    $recommandations = @{
        "mental" = "Méditation ou respiration consciente"
        "emotionnel" = "Expression créative ou dialogue bienveillant"
        "physique" = "Mouvement doux ou étirement"
        "energetique" = "Ancrage ou harmonisation fréquentielle"
        "social" = "Communication authentique ou retrait temporaire"
    }
    
    return $recommandations[$Zone]
}

Write-FrictionLog "Démarrage détection frictions - Seuil: $Seuil"

switch ($Mode.ToLower()) {
    "detection" {
        $frictions = Detect-FrictionPoints
        
        if ($frictions.Count -eq 0) {
            Write-FrictionLog "Aucune friction significative détectée"
        } else {
            Write-FrictionLog "Frictions détectées dans $($frictions.Count) zone(s)"
            foreach ($friction in $frictions) {
                Write-FrictionLog "FRICTION [$($friction.zone)]: Niveau $($friction.niveau) - $($friction.recommandation)"
            }
            
            # Sauvegarde des frictions détectées
            $frictionFile = Join-Path $DataPath "friction-report.json"
            $rapport = @{
                timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                seuil_utilise = $Seuil
                frictions_detectees = $frictions
                statut = if ($frictions.Count -eq 0) { "optimal" } else { "attention_requise" }
            }
            $rapport | ConvertTo-Json -Depth 3 | Set-Content $frictionFile
        }
    }
    
    "rapport" {
        Write-FrictionLog "Génération du rapport de frictions"
        $frictionFile = Join-Path $DataPath "friction-report.json"
        if (Test-Path $frictionFile) {
            $rapport = Get-Content $frictionFile | ConvertFrom-Json
            Write-FrictionLog "Dernier rapport: $($rapport.statut) - $($rapport.frictions_detectees.Count) friction(s)"
        } else {
            Write-FrictionLog "Aucun rapport précédent disponible"
        }
    }
}

Write-FrictionLog "Fin détection frictions"