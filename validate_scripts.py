#!/usr/bin/env python3
# Script de validation alternative pour ALTER-LOLO

import os
import glob
import json
import subprocess
import sys

def validate_json_files():
    """Valide tous les fichiers JSON"""
    print("🔍 Validation des fichiers JSON...")
    json_files = glob.glob("**/*.json", recursive=True)
    errors = []
    
    for file in json_files:
        try:
            with open(file, 'r', encoding='utf-8') as f:
                json.load(f)
            print(f"✅ {file}")
        except Exception as e:
            errors.append(f"❌ {file}: {str(e)}")
            print(f"❌ {file}: {str(e)}")
    
    return errors

def validate_powershell_syntax():
    """Valide la syntaxe des fichiers PowerShell avec différentes méthodes"""
    print("\n🔍 Validation syntaxique PowerShell...")
    ps_files = glob.glob("**/*.ps1", recursive=True)
    errors = []
    
    for file in ps_files:
        try:
            # Test de syntaxe basique avec PowerShell Core
            result = subprocess.run([
                "pwsh", "-NoProfile", "-Command", 
                f"try {{ [System.Management.Automation.PSParser]::Tokenize((Get-Content '{file}' -Raw), [ref]$null) | Out-Null; Write-Output 'OK' }} catch {{ Write-Output $_.Exception.Message }}"
            ], capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0 and "OK" in result.stdout:
                print(f"✅ {file}")
            else:
                error_msg = result.stdout.strip() or result.stderr.strip()
                errors.append(f"❌ {file}: {error_msg}")
                print(f"❌ {file}: {error_msg}")
                
        except Exception as e:
            errors.append(f"❌ {file}: Erreur de validation - {str(e)}")
            print(f"❌ {file}: Erreur de validation - {str(e)}")
    
    return errors

def check_file_permissions():
    """Vérifie les permissions des fichiers"""
    print("\n🔍 Vérification des permissions...")
    issues = []
    
    for root, dirs, files in os.walk('.'):
        for file in files:
            filepath = os.path.join(root, file)
            if not os.access(filepath, os.R_OK):
                issues.append(f"❌ Lecture impossible: {filepath}")
            elif file.endswith('.ps1') and not os.access(filepath, os.X_OK):
                issues.append(f"⚠️  Exécution limitée: {filepath}")
    
    if not issues:
        print("✅ Permissions OK")
    
    return issues

def main():
    print("🌟 === VALIDATION ALTER-LOLO === 🌟")
    print("Alternative de diagnostic sans PowerShell")
    print()
    
    all_errors = []
    
    # Validation JSON
    all_errors.extend(validate_json_files())
    
    # Validation PowerShell
    all_errors.extend(validate_powershell_syntax())
    
    # Vérification permissions
    all_errors.extend(check_file_permissions())
    
    print(f"\n📊 Résumé:")
    if all_errors:
        print(f"❌ {len(all_errors)} problème(s) détecté(s):")
        for error in all_errors:
            print(f"  {error}")
        sys.exit(1)
    else:
        print("✅ Aucun problème détecté - Système ALTER-LOLO validé")
        sys.exit(0)

if __name__ == "__main__":
    main()