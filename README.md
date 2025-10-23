# 00000000_IA_LOCALE - alter-lolo

Agent suprême thérapeutique ludique - IA locale sans dépendance externe.

## 🌟 Description

**alter-lolo** est une IA locale conçue pour offrir un accompagnement thérapeutique et ludique. Le système est composé d'agents spécialisés orchestrés par un script principal, sans nécessiter de connexion internet ou de dépendances externes.

## 📁 Structure du projet

```
00000000_IA_LOCALE/
├── alter-lolo.ps1          # Script orchestrateur principal
├── agents/                  # Scripts d'agents (.ps1)
│   ├── therapeute.ps1      # Agent thérapeutique
│   └── ludique.ps1         # Agent ludique
├── manifestes/             # Fichiers de configuration (.json)
│   ├── alter-lolo.json     # Manifeste principal
│   ├── therapeute.json     # Configuration agent thérapeutique
│   └── ludique.json        # Configuration agent ludique
├── modules/                # Modules PowerShell personnalisés
├── logs/                   # Fichiers de logs (exclus du git)
└── data/                   # Données et interactions
```

## 🚀 Utilisation

### Exécution standard
```powershell
.\alter-lolo.ps1
```

### Lister les agents et manifestes disponibles
```powershell
.\alter-lolo.ps1 -Action List
```

### Exécuter un agent spécifique
```powershell
.\alter-lolo.ps1 -Action Agent -AgentName "therapeute"
```

## 🤖 Agents disponibles

### Agent Thérapeute
Agent spécialisé dans l'accompagnement émotionnel et le soutien thérapeutique.
```powershell
.\agents\therapeute.ps1 -Message "Je me sens bien aujourd'hui"
```

### Agent Ludique
Agent de divertissement proposant blagues, devinettes et conseils quotidiens.
```powershell
.\agents\ludique.ps1 -Activity "blague"
.\agents\ludique.ps1 -Activity "devinette"
.\agents\ludique.ps1 -Activity "conseil"
```

## 📝 Logs

Les logs sont automatiquement générés dans le dossier `logs/` avec le format :
- Nom de fichier : `alter-lolo-YYYY-MM-DD.log`
- Format : `[YYYY-MM-DD HH:mm:ss] [LEVEL] Message`

## ⚙️ Configuration

Les manifestes JSON définissent la configuration de chaque agent :
- **alter-lolo.json** : Configuration globale et orchestration
- **therapeute.json** : Paramètres de l'agent thérapeutique
- **ludique.json** : Paramètres de l'agent ludique

## 🔧 Prérequis

- Windows PowerShell 5.1 ou supérieur
- Aucune dépendance externe requise
- Pas de connexion internet nécessaire

## 📄 Licence

Projet personnel - alter-lolo
