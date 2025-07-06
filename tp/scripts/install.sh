#!/bin/bash

# ==============================================================================
# SCRIPT D'INSTALLATION AUTOMATIQUE - TODOLIST PRODUCTION
# ==============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Logo ASCII
show_logo() {
    echo -e "${BLUE}${BOLD}"
    cat << "EOF"
████████╗ ██████╗ ██████╗  ██████╗ ██╗     ██╗███████╗████████╗
╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗██║     ██║██╔════╝╚══██╔══╝
   ██║   ██║   ██║██║  ██║██║   ██║██║     ██║███████╗   ██║   
   ██║   ██║   ██║██║  ██║██║   ██║██║     ██║╚════██║   ██║   
   ██║   ╚██████╔╝██████╔╝╚██████╔╝███████╗██║███████║   ██║   
   ╚═╝    ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝╚══════╝   ╚═╝   
                                                               
EOF
    echo -e "${NC}"
    echo -e "${GREEN}${BOLD}TodoList Production Setup - Version 1.0.0${NC}"
    echo -e "${BLUE}Configuration automatique pour l'environnement de production${NC}"
    echo ""
}

# Fonction d'affichage
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} ❌ $1"
}

log_step() {
    echo -e "${GREEN}${BOLD}[$1/7]${NC} $2"
}

# Vérification des prérequis
check_prerequisites() {
    log_step "1" "Vérification des prérequis..."
    
    local missing_deps=()
    
    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        missing_deps+=("Docker")
    fi
    
    # Vérifier Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        missing_deps+=("Docker Compose")
    fi
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        missing_deps+=("Node.js")
    fi
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        missing_deps+=("npm")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Dépendances manquantes: ${missing_deps[*]}"
        echo ""
        echo "Veuillez installer les dépendances manquantes:"
        echo "- Docker: https://docs.docker.com/install/"
        echo "- Node.js: https://nodejs.org/"
        exit 1
    fi
    
    log_success "Tous les prérequis sont installés"
}

# Configuration de l'environnement
setup_environment() {
    log_step "2" "Configuration de l'environnement..."
    
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
            log_success "Fichier .env créé à partir de .env.example"
        else
            log_error "Fichier .env.example introuvable"
            exit 1
        fi
    else
        log_warning "Fichier .env existe déjà"
    fi
    
    # Générer une clé secrète aléatoire
    if command -v openssl &> /dev/null; then
        SECRET_KEY=$(openssl rand -hex 32)
        sed -i.bak "s/SESSION_SECRET=.*/SESSION_SECRET=${SECRET_KEY}/" .env 2>/dev/null || \
        sed -i "s/SESSION_SECRET=.*/SESSION_SECRET=${SECRET_KEY}/" .env
        log_success "Clé secrète générée automatiquement"
    else
        log_warning "OpenSSL non disponible, veuillez modifier SESSION_SECRET manuellement"
    fi
}

# Installation des dépendances
install_dependencies() {
    log_step "3" "Installation des dépendances Node.js..."
    
    if [ -d "src" ] && [ -f "src/package.json" ]; then
        cd src
        npm install --silent
        cd ..
        log_success "Dépendances Node.js installées"
    else
        log_error "Dossier src ou package.json introuvable"
        exit 1
    fi
}

# Permissions des scripts
setup_permissions() {
    log_step "4" "Configuration des permissions..."
    
    if [ -d "scripts" ]; then
        chmod +x scripts/*.sh
        log_success "Permissions des scripts configurées"
    else
        log_warning "Dossier scripts introuvable"
    fi
}

# Construction des images Docker
build_images() {
    log_step "5" "Construction des images Docker..."
    
    if [ -f "deployment/docker/Dockerfile" ]; then
        cd deployment/docker
        docker-compose build --no-cache
        cd ../..
        log_success "Images Docker construites"
    else
        log_error "Dockerfile introuvable"
        exit 1
    fi
}

# Test de l'installation
test_installation() {
    log_step "6" "Test de l'installation..."
    
    cd deployment/docker
    docker-compose -f docker-compose-simple.yml up -d
    
    # Attendre que l'application démarre
    log_info "Attente du démarrage de l'application..."
    sleep 30
    
    # Test du health check
    if curl -f http://localhost:3000/health &> /dev/null; then
        log_success "Application fonctionnelle !"
    else
        log_error "L'application ne répond pas"
        docker-compose -f docker-compose-simple.yml logs
        exit 1
    fi
    
    docker-compose -f docker-compose-simple.yml down
    cd ../..
}

# Instructions finales
show_instructions() {
    log_step "7" "Installation terminée !"
    
    echo ""
    echo -e "${GREEN}${BOLD}🎉 INSTALLATION RÉUSSIE !${NC}"
    echo ""
    echo -e "${BLUE}Commandes utiles :${NC}"
    echo ""
    echo -e "  ${YELLOW}make start${NC}           # Démarrer l'application"
    echo -e "  ${YELLOW}make status${NC}          # Vérifier le statut"
    echo -e "  ${YELLOW}make logs${NC}            # Voir les logs"
    echo -e "  ${YELLOW}make stop${NC}            # Arrêter l'application"
    echo -e "  ${YELLOW}make help${NC}            # Voir toutes les commandes"
    echo ""
    echo -e "${BLUE}Accès :${NC}"
    echo ""
    echo -e "  ${YELLOW}Application${NC}          http://localhost:3000"
    echo -e "  ${YELLOW}Health Check${NC}         http://localhost:3000/health"
    echo ""
    echo -e "${GREEN}Prêt pour la production ! 🚀${NC}"
    echo ""
}

# Fonction principale
main() {
    show_logo
    check_prerequisites
    setup_environment
    install_dependencies
    setup_permissions
    build_images
    test_installation
    show_instructions
}

# Gestion des erreurs
trap 'log_error "Installation interrompue"; exit 1' ERR

# Exécution
main "$@"
