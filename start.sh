#!/bin/bash

# 🚀 TodoList Production - Script de démarrage intelligent
# Ce script guide l'utilisateur vers les bonnes ressources selon ses besoins

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction d'affichage avec style
print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              🚀 TodoList Production - Guide                  ║"
    echo "║            Solution Ansible Robuste & Modulaire             ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Fonction pour vérifier les prérequis
check_requirements() {
    print_section "Vérification des prérequis..."
    
    local missing_deps=()
    
    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        missing_deps+=("docker-compose")
    fi
    
    if ! command -v make &> /dev/null; then
        missing_deps+=("make")
    fi
    
    if [ ${#missing_deps[@]} -eq 0 ]; then
        print_success "Tous les prérequis sont installés !"
        return 0
    else
        print_error "Prérequis manquants: ${missing_deps[*]}"
        return 1
    fi
}

# Fonction pour afficher le menu principal
show_menu() {
    echo -e "${PURPLE}"
    echo "🎯 Que souhaitez-vous faire ?"
    echo -e "${NC}"
    echo "1️⃣  Démarrage rapide (développement local)"
    echo "2️⃣  Déploiement production avec Ansible"
    echo "3️⃣  Consulter la documentation"
    echo "4️⃣  Valider la solution Ansible"
    echo "5️⃣  Monitoring et maintenance"
    echo "6️⃣  Aide et support"
    echo "0️⃣  Quitter"
    echo ""
    echo -n "Votre choix (0-6): "
}

# Fonction pour le démarrage rapide
quick_start() {
    print_section "🚀 Démarrage rapide - Développement local"
    echo ""
    echo "Nous allons démarrer l'application en mode développement..."
    echo ""
    
    if [ ! -f "tp/.env" ]; then
        print_warning "Fichier .env non trouvé. Création à partir du template..."
        if [ -f "tp/.env.example" ]; then
            cp tp/.env.example tp/.env
            print_success "Fichier .env créé ! Vérifiez la configuration."
        else
            print_error "Template .env.example non trouvé !"
            return 1
        fi
    fi
    
    cd tp
    print_section "Démarrage de l'application..."
    make start-simple
    
    print_success "Application démarrée !"
    echo ""
    echo "🌐 Accès à l'application : http://localhost:3000"
    echo "🏥 Health check : http://localhost:3000/health"
    echo ""
    echo "📊 Pour voir les logs : make logs"
    echo "🛑 Pour arrêter : make stop"
}

# Fonction pour le déploiement Ansible
ansible_deployment() {
    print_section "🎯 Déploiement production avec Ansible"
    echo ""
    
    if [ ! -d "deployment/ansible" ]; then
        print_error "Dossier deployment/ansible non trouvé !"
        return 1
    fi
    
    cd deployment/ansible
    
    print_warning "Configuration requise avant le déploiement :"
    echo "1. Éditez le fichier vars/deploy.yml avec vos paramètres"
    echo "2. Configurez l'inventaire inventory.ini avec vos serveurs"
    echo "3. Assurez-vous que les clés SSH sont configurées"
    echo ""
    
    echo -n "Configuration terminée ? (y/N): "
    read -r confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        print_section "Lancement du déploiement..."
        make deploy
        print_success "Déploiement terminé !"
    else
        print_warning "Consultez le guide : deployment/ansible/GUIDE-DEPLOIEMENT.md"
    fi
}

# Fonction pour la documentation
show_documentation() {
    print_section "📚 Documentation disponible"
    echo ""
    echo "📖 Guides principaux :"
    echo "   • README.md - Documentation générale"
    echo "   • docs/README.md - Hub central de documentation"
    echo "   • deployment/ansible/GUIDE-DEPLOIEMENT.md - Guide Ansible complet"
    echo "   • deployment/ansible/README-INFRASTRUCTURE.md - Configuration infrastructure"
    echo ""
    echo "🛠️ Outils et commandes :"
    echo "   • deployment/ansible/Makefile - Interface de commandes"
    echo "   • deployment/ansible/validate-solution.sh - Validation automatique"
    echo ""
    echo "🌐 Ressources en ligne :"
    echo "   • Documentation Ansible : https://docs.ansible.com/"
    echo "   • Best practices Docker : https://docs.docker.com/develop/best-practices/"
    echo ""
    
    echo -n "Ouvrir le hub de documentation ? (y/N): "
    read -r open_docs
    
    if [[ $open_docs =~ ^[Yy]$ ]]; then
        if command -v code &> /dev/null; then
            code docs/README.md
        else
            cat docs/README.md
        fi
    fi
}

# Fonction pour valider la solution
validate_solution() {
    print_section "✅ Validation de la solution Ansible"
    echo ""
    
    if [ ! -f "deployment/ansible/validate-solution.sh" ]; then
        print_error "Script de validation non trouvé !"
        return 1
    fi
    
    cd deployment/ansible
    chmod +x validate-solution.sh
    ./validate-solution.sh
}

# Fonction pour le monitoring
monitoring_maintenance() {
    print_section "📊 Monitoring et maintenance"
    echo ""
    echo "🔍 Commandes disponibles :"
    echo "   • make health-check - Vérification de santé complète"
    echo "   • make logs - Consultation des logs"
    echo "   • make backup - Sauvegarde manuelle"
    echo "   • make clean-old-images - Nettoyage des anciennes images"
    echo "   • make monitor-services - Monitoring en temps réel"
    echo ""
    
    if [ -d "deployment/ansible" ]; then
        cd deployment/ansible
        echo -n "Lancer une vérification de santé ? (y/N): "
        read -r health_check
        
        if [[ $health_check =~ ^[Yy]$ ]]; then
            make health-check
        fi
    fi
}

# Fonction d'aide
show_help() {
    print_section "🆘 Aide et support"
    echo ""
    echo "📋 Structure du projet :"
    echo "   • tp/ - Code source de l'application"
    echo "   • deployment/ - Configuration de déploiement"
    echo "   • docs/ - Documentation centralisée"
    echo "   • scripts/ - Scripts utilitaires"
    echo ""
    echo "🔧 Commandes principales :"
    echo "   • Local : cd tp && make start-simple"
    echo "   • Production : cd deployment/ansible && make deploy"
    echo "   • Documentation : cat docs/README.md"
    echo ""
    echo "🐛 En cas de problème :"
    echo "   • Vérifiez les logs : make logs"
    echo "   • Validez la solution : ./deployment/ansible/validate-solution.sh"
    echo "   • Consultez la documentation : docs/README.md"
    echo ""
    echo "📞 Support :"
    echo "   • GitHub Issues : https://github.com/votre-repo/issues"
    echo "   • Documentation : deployment/ansible/GUIDE-DEPLOIEMENT.md"
}

# Fonction principale
main() {
    clear
    print_header
    
    # Vérification des prérequis
    if ! check_requirements; then
        echo ""
        print_warning "Installez les prérequis manquants avant de continuer."
        echo "Consultez la documentation pour les instructions d'installation."
        exit 1
    fi
    
    echo ""
    
    while true; do
        show_menu
        read -r choice
        echo ""
        
        case $choice in
            1) quick_start ;;
            2) ansible_deployment ;;
            3) show_documentation ;;
            4) validate_solution ;;
            5) monitoring_maintenance ;;
            6) show_help ;;
            0) 
                print_success "Au revoir ! 👋"
                exit 0
                ;;
            *)
                print_error "Choix invalide. Veuillez sélectionner une option valide."
                ;;
        esac
        
        echo ""
        echo -n "Appuyez sur Entrée pour continuer..."
        read -r
        echo ""
    done
}

# Lancement du script
main "$@"
