# Lanceur Principal ALTER-LOLO
# Point d'entrée unifié pour l'écosystème thérapeutique

param(
    [string]$Mode = "orchestrer",
    [switch]$Diagnostic = $false,
    [switch]$Silent = $false
)

$BasePath = Split-Path -Parent $MyInvocation.MyCommand.Path
$AgentPath = Join-Path $BasePath "agents\alter-lolo.ps1"

Write-Host "🌟 === ÉCOSYSTÈME ALTER-LOLO === 🌟" -ForegroundColor Cyan
Write-Host "Thérapie ludique par résonance et modularité" -ForegroundColor Yellow
Write-Host ""

if ($Diagnostic) {
    Write-Host "🔍 Diagnostic complet du système..." -ForegroundColor Green
    
    # Vérification de la structure
    $dossiers = @("agents", "manifestes", "modules", "logs", "data")
    foreach ($dossier in $dossiers) {
        $chemin = Join-Path $BasePath $dossier
        if (Test-Path $chemin) {
            Write-Host "✅ $dossier" -ForegroundColor Green
        } else {
            Write-Host "❌ $dossier MANQUANT" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "📊 État des agents:" -ForegroundColor Yellow
    & (Join-Path $BasePath "modules\state-manager.ps1") -Action "lire"
    
    Write-Host ""
}

# Lancement d'ALTER-LOLO
Write-Host "🚀 Activation d'ALTER-LOLO..." -ForegroundColor Magenta

$params = @{
    Action = $Mode
}

if ($Silent) {
    $params.Silencieux = $true
}

& $AgentPath @params

Write-Host ""
Write-Host "✨ Session terminée - Que la résonance soit avec vous ✨" -ForegroundColor Cyan