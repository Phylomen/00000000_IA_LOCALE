#!/usr/bin/env python3
"""
Lanceur Principal ALTER-LOLO (Version Python)
Point d'entrée unifié pour l'écosystème thérapeutique
"""

import os
import sys
import argparse
from pathlib import Path

# Ajout du dossier parent au path pour les imports
sys.path.insert(0, str(Path(__file__).parent))

from alter_lolo import AlterLolo

def check_system_structure(base_path: Path) -> bool:
    """Vérification de la structure du système"""
    required_dirs = ["agents", "manifestes", "modules", "logs", "data"]
    missing_dirs = []
    
    for dir_name in required_dirs:
        dir_path = base_path / dir_name
        if dir_path.exists():
            print(f"✅ {dir_name}")
        else:
            print(f"❌ {dir_name} MANQUANT")
            missing_dirs.append(dir_name)
    
    return len(missing_dirs) == 0

def show_agent_states(base_path: Path):
    """Affichage des états d'agents"""
    try:
        import json
        states_file = base_path / "data" / "agent-states.json"
        
        if states_file.exists():
            with open(states_file, 'r', encoding='utf-8') as f:
                states = json.load(f)
            
            print("📊 État des agents:")
            print("=== ÉTATS DES AGENTS ===")
            
            if states.get("agents"):
                for agent in states["agents"]:
                    nom = agent.get("nom", "N/A")
                    statut = agent.get("statut", "N/A")
                    resonance = agent.get("resonance", "N/A")
                    print(f"{nom} : {statut} (Résonance: {resonance})")
            else:
                print("Aucun agent enregistré")
            
            harmonie = states.get("harmonie_globale", "N/A")
            print(f"Harmonie globale: {harmonie}")
        else:
            print("📊 État des agents: Fichier d'états non trouvé")
    except Exception as e:
        print(f"❌ Erreur lecture états: {e}")

def main():
    """Fonction principale du lanceur"""
    parser = argparse.ArgumentParser(description="🌟 ALTER-LOLO - Écosystème Thérapeutique Modulaire (Python)")
    parser.add_argument("--mode", default="orchestrer", choices=["orchestrer", "diagnostiquer", "equilibrer"],
                       help="Mode de fonctionnement")
    parser.add_argument("--diagnostic", action="store_true", help="Diagnostic complet du système")
    parser.add_argument("--silent", action="store_true", help="Mode silencieux")
    parser.add_argument("--base-path", help="Chemin de base du projet")
    
    args = parser.parse_args()
    
    # Détermination du chemin de base
    if args.base_path:
        base_path = Path(args.base_path)
    else:
        base_path = Path(__file__).parent.parent
    
    print("🌟 === ÉCOSYSTÈME ALTER-LOLO === 🌟")
    print("Thérapie ludique par résonance et modularité")
    print("Version Python - Sans dépendances externes")
    print()
    
    if args.diagnostic:
        print("🔍 Diagnostic complet du système...")
        
        # Vérification de la structure
        structure_ok = check_system_structure(base_path)
        print()
        
        # Affichage des états
        show_agent_states(base_path)
        print()
        
        if not structure_ok:
            print("⚠️  Problèmes de structure détectés")
            return 1
    
    print("🚀 Activation d'ALTER-LOLO...")
    
    # Création et lancement de l'agent
    try:
        agent = AlterLolo(base_path=str(base_path))
        success = agent.run(action=args.mode, silent=args.silent)
        
        print()
        print("✨ Session terminée - Que la résonance soit avec vous ✨")
        
        return 0 if success else 1
        
    except KeyboardInterrupt:
        print("\n🛑 Interruption utilisateur")
        return 130
    except Exception as e:
        print(f"\n❌ Erreur fatale: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())