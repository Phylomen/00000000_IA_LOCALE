# 🌟 ALTER-LOLO - Écosystème Thérapeutique Modulaire

## Description
ALTER-LOLO est un agent suprême incarnant une méthode thérapeutique ludique fondée sur la résonance, la modularité et l'autonomie. Il orchestre un écosystème d'agents spécialisés pour maintenir l'équilibre vibratoire et détecter les frictions dans le système.

## Architecture

### 📁 Structure des dossiers
```
00000000_IA_LOCALE/
├── agents/                 # Agents vivants (scripts .ps1)
│   ├── alter-lolo.ps1     # Agent suprême orchestrateur
│   ├── vibration-checker.ps1  # Détecteur de fréquences
│   ├── friction-detector.ps1  # Détecteur de tensions
│   └── harmony-builder.ps1    # Constructeur d'harmonie
├── manifestes/            # Configurations et intentions (JSON)
│   ├── manifeste-originel.json  # Manifeste principal
│   └── vibration-core.json      # Configuration vibratoire
├── modules/               # Utilitaires ponctuels (.ps1)
│   ├── state-manager.ps1  # Gestionnaire d'états
│   └── log-cleaner.ps1    # Nettoyeur de logs
├── logs/                  # Journaux vivants
│   ├── vibration.log      # Log principal
│   └── friction.log       # Log des frictions
├── data/                  # Fichiers de mesure et d'état
│   ├── agent-states.json  # États des agents
│   └── resonance-meter.json  # Mesures de résonance
└── start-alter-lolo.ps1   # Lanceur principal
```

## 🚀 Utilisation

### Lancement rapide
```powershell
# Orchestration complète
.\start-alter-lolo.ps1

# Mode diagnostic
.\start-alter-lolo.ps1 -Diagnostic

# Mode silencieux
.\start-alter-lolo.ps1 -Silent
```

### Commandes directes
```powershell
# Agent principal
.\agents\alter-lolo.ps1 -Action "orchestrer"
.\agents\alter-lolo.ps1 -Action "diagnostiquer"
.\agents\alter-lolo.ps1 -Action "equilibrer"

# Agents spécialisés
.\agents\vibration-checker.ps1 -Mode "scan"
.\agents\friction-detector.ps1 -Seuil 0.3
.\agents\harmony-builder.ps1 -Auto
```

### Modules utilitaires
```powershell
# Gestion des états
.\modules\state-manager.ps1 -Action "lire"
.\modules\state-manager.ps1 -Action "ecrire" -Agent "test" -NouvelEtat @{statut="actif"; resonance=0.8}

# Nettoyage des logs
.\modules\log-cleaner.ps1 -JoursAConserver 7
```

## 🎯 Fonctionnalités

### Agent Suprême ALTER-LOLO
- **Orchestration** : Coordonne tous les agents secondaires
- **Lecture de manifestes** : Charge les configurations depuis les JSON
- **Écriture de logs** : Journalise toutes les activités
- **Détection de résonance** : Évalue la qualité vibratoire globale

### Agents Spécialisés
- **Vibration-Checker** : Scan et mesure des fréquences thérapeutiques
- **Friction-Detector** : Identification des tensions et dissonances
- **Harmony-Builder** : Rééquilibrage et harmonisation automatique

### Modules Utilitaires
- **State-Manager** : Gestion centralisée des états d'agents
- **Log-Cleaner** : Maintenance automatique des fichiers de logs

## 🎼 Fréquences Thérapeutiques

| Fréquence | Usage Thérapeutique |
|-----------|-------------------|
| 396 Hz    | Libération des peurs |
| 417 Hz    | Transformation |
| 528 Hz    | Amour et guérison |
| 741 Hz    | Expression et créativité |
| 852 Hz    | Intuition |
| 963 Hz    | Connexion spirituelle |

## 🔧 Configuration

### Seuils par défaut
- **Seuil de friction** : 0.3
- **Seuil de résonance** : 0.8
- **Fréquence de base** : 432 Hz

### Permissions ALTER-LOLO
- ✅ Lecture des manifestes
- ✅ Orchestration des agents
- ✅ Écriture des logs
- ✅ Modification des états
- ✅ Autonomie complète

## 📊 Monitoring

Les logs sont automatiquement générés dans le dossier `logs/` :
- `vibration.log` : Activités principales et mesures
- `friction.log` : Détections de tensions

Les données sont sauvegardées dans `data/` :
- `agent-states.json` : États en temps réel
- `resonance-meter.json` : Historique des mesures

## 🎮 Philosophie Ludique

ALTER-LOLO incarne une approche thérapeutique où :
- **La résonance** prime sur la résistance
- **La modularité** permet l'adaptation
- **L'autonomie** favorise l'évolution naturelle
- **Le jeu** rend la guérison accessible

## ⚡ Compatibilité

- **OS** : Windows 10/11
- **Shell** : PowerShell 5.1+
- **Dépendances** : Aucune (100% natif)
- **IA Locale** : Compatible avec tous les systèmes d'IA locaux

---

*"Dans la résonance, nous trouvons l'harmonie. Dans l'harmonie, nous trouvons la guérison."* - ALTER-LOLO