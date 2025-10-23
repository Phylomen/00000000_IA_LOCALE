#!/usr/bin/env python3
"""
Gestionnaire d'État Python pour ALTER-LOLO
Remplacement du module PowerShell state-manager.ps1
"""

import json
import sys
import argparse
from datetime import datetime
from pathlib import Path
from typing import Dict, Any, Optional

class StateManager:
    """Gestionnaire d'états des agents ALTER-LOLO"""
    
    def __init__(self, base_path: str = None):
        self.base_path = Path(base_path) if base_path else Path(__file__).parent.parent
        self.data_path = self.base_path / "data"
        self.state_file = self.data_path / "agent-states.json"
        
        # Création du dossier data si nécessaire
        self.data_path.mkdir(exist_ok=True)
    
    def initialize_state_file(self):
        """Initialise le fichier d'états s'il n'existe pas"""
        if not self.state_file.exists():
            initial_state = {
                "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "agents": [],
                "harmonie_globale": 0.5
            }
            with open(self.state_file, 'w', encoding='utf-8') as f:
                json.dump(initial_state, f, indent=2, ensure_ascii=False)
    
    def get_agent_state(self, agent_name: str) -> Optional[Dict[str, Any]]:
        """Récupère l'état d'un agent spécifique"""
        if self.state_file.exists():
            with open(self.state_file, 'r', encoding='utf-8') as f:
                states = json.load(f)
            
            for agent in states.get("agents", []):
                if agent.get("nom") == agent_name:
                    return agent
        return None
    
    def set_agent_state(self, agent_name: str, etat: Dict[str, Any]):
        """Met à jour l'état d'un agent"""
        self.initialize_state_file()
        
        with open(self.state_file, 'r', encoding='utf-8') as f:
            states = json.load(f)
        
        # Recherche et mise à jour de l'agent existant
        agent_found = False
        for i, agent in enumerate(states.get("agents", [])):
            if agent.get("nom") == agent_name:
                states["agents"][i] = {
                    "nom": agent_name,
                    "statut": etat.get("statut", "inconnu"),
                    "resonance": etat.get("resonance", 0.5),
                    "derniere_activite": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                }
                agent_found = True
                break
        
        # Ajout d'un nouvel agent si non trouvé
        if not agent_found:
            if "agents" not in states:
                states["agents"] = []
            states["agents"].append({
                "nom": agent_name,
                "statut": etat.get("statut", "inconnu"),
                "resonance": etat.get("resonance", 0.5),
                "derniere_activite": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            })
        
        states["timestamp"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        with open(self.state_file, 'w', encoding='utf-8') as f:
            json.dump(states, f, indent=2, ensure_ascii=False)
    
    def read_all_states(self):
        """Affiche tous les états d'agents"""
        self.initialize_state_file()
        
        with open(self.state_file, 'r', encoding='utf-8') as f:
            states = json.load(f)
        
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
    
    def reset_states(self):
        """Réinitialise tous les états"""
        if self.state_file.exists():
            self.state_file.unlink()
        self.initialize_state_file()
        print("États réinitialisés")

def main():
    """Fonction principale"""
    parser = argparse.ArgumentParser(description="Gestionnaire d'États ALTER-LOLO")
    parser.add_argument("--action", default="lire", choices=["lire", "ecrire", "reset"],
                       help="Action à effectuer")
    parser.add_argument("--agent", help="Nom de l'agent")
    parser.add_argument("--statut", help="Statut de l'agent")
    parser.add_argument("--resonance", type=float, help="Niveau de résonance")
    parser.add_argument("--base-path", help="Chemin de base du projet")
    
    args = parser.parse_args()
    
    manager = StateManager(base_path=args.base_path)
    
    if args.action == "lire":
        if args.agent:
            etat = manager.get_agent_state(args.agent)
            if etat:
                print(f"Agent: {etat['nom']} | Statut: {etat['statut']} | Résonance: {etat['resonance']}")
            else:
                print(f"Agent '{args.agent}' non trouvé")
        else:
            manager.read_all_states()
    
    elif args.action == "ecrire":
        if args.agent and (args.statut or args.resonance is not None):
            nouvel_etat = {}
            if args.statut:
                nouvel_etat["statut"] = args.statut
            if args.resonance is not None:
                nouvel_etat["resonance"] = args.resonance
            
            manager.set_agent_state(args.agent, nouvel_etat)
            print(f"État de '{args.agent}' mis à jour")
        else:
            print("Paramètres insuffisants pour l'écriture (--agent et --statut/--resonance requis)")
    
    elif args.action == "reset":
        manager.reset_states()

if __name__ == "__main__":
    main()