# Module de Nettoyage des Logs
# Utilitaire pour maintenir la propreté des fichiers de logs

param(
    [int]$JoursAConserver = 7,
    [switch]$ForceClean = $false
)

$BasePath = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$LogsPath = Join-Path $BasePath "logs"

function Clean-LogFile {
    param([string]$LogFilePath, [int]$Jours)
    
    if (-not (Test-Path $LogFilePath)) {
        return
    }
    
    $dateLimit = (Get-Date).AddDays(-$Jours)
    $contenu = Get-Content $LogFilePath
    $lignesAConserver = @()
    
    foreach ($ligne in $contenu) {
        if ($ligne -match '^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\]') {
            $dateLigne = [DateTime]::ParseExact($matches[1], "yyyy-MM-dd HH:mm:ss", $null)
            if ($dateLigne -gt $dateLimit) {
                $lignesAConserver += $ligne
            }
        } else {
            # Conserver les lignes sans timestamp (en-têtes, etc.)
            $lignesAConserver += $ligne
        }
    }
    
    if ($lignesAConserver.Count -lt $contenu.Count) {
        $lignesAConserver | Set-Content $LogFilePath
        $lignesSupprimes = $contenu.Count - $lignesAConserver.Count
        Write-Output "Nettoyé $LogFilePath : $lignesSupprimes entrées supprimées"
    }
}

function Archive-OldLogs {
    $archivePath = Join-Path $LogsPath "archive"
    if (-not (Test-Path $archivePath)) {
        New-Item -Path $archivePath -ItemType Directory -Force | Out-Null
    }
    
    $dateArchive = Get-Date -Format "yyyy-MM-dd"
    Get-ChildItem $LogsPath -Filter "*.log" | ForEach-Object {
        $archiveFile = Join-Path $archivePath "$($_.BaseName)_$dateArchive.log"
        if ($ForceClean -and (Test-Path $archiveFile)) {
            Remove-Item $archiveFile -Force
        }
        Copy-Item $_.FullName $archiveFile -Force
    }
}

Write-Output "=== NETTOYAGE DES LOGS ==="
Write-Output "Conservation: $JoursAConserver jours"

# Archivage des logs actuels
if ($ForceClean) {
    Archive-OldLogs
    Write-Output "Logs archivés"
}

# Nettoyage des fichiers de logs
$logFiles = @("vibration.log", "friction.log", "system.log")
foreach ($logFile in $logFiles) {
    $logPath = Join-Path $LogsPath $logFile
    Clean-LogFile -LogFilePath $logPath -Jours $JoursAConserver
}

Write-Output "Nettoyage terminé"