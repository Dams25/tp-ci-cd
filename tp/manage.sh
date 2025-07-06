#!/bin/bash

# ==============================================================================
# SCRIPT PRINCIPAL DE GESTION - TODOLIST PRODUCTION
# ==============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Fonction d'aide
show_help() {
    echo -e "${GREEN}${BOLD}TodoList Production - Commandes disponibles:${NC}"
    echo ""
    echo -e "  ${YELLOW}./manage.sh help${NC}           Afficher cette aide"
    echo -e "  ${YELLOW}./manage.sh install${NC}        Installer les dépendances"
    echo -e "  ${YELLOW}./manage.sh start${NC}          Démarrer l'application"
    echo -e "  ${YELLOW}./manage.sh start-simple${NC}   Démarrer la version simplifiée"
    echo -e "  ${YELLOW}./manage.sh stop${NC}           Arrêter l'application"
    echo -e "  ${YELLOW}./manage.sh status${NC}         Vérifier le statut"
    echo -e "  ${YELLOW}./manage.sh logs${NC}           Afficher les logs"
    echo -e "  ${YELLOW}./manage.sh test${NC}           Lancer les tests"
    echo -e "  ${YELLOW}./manage.sh build${NC}          Construire les images Docker"
    echo -e "  ${YELLOW}./manage.sh clean${NC}          Nettoyer les conteneurs et volumes"
    echo -e "  ${YELLOW}./manage.sh backup${NC}         Sauvegarder les données"
    echo -e "  ${YELLOW}./manage.sh deploy${NC}         Déployer avec Ansible"
    echo -e "  ${YELLOW}./manage.sh dev${NC}            Mode développement"
    echo -e "  ${YELLOW}./manage.sh healthcheck${NC}    Vérifier la santé de l'application"
    echo -e "  ${YELLOW}./manage.sh setup${NC}          Configuration initiale complète"
    echo -e "  ${YELLOW}./manage.sh quick-start${NC}    Démarrage rapide complet"
    echo ""
}

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_COMPOSE_DIR="$SCRIPT_DIR/deployment/docker"
ANSIBLE_DIR="$SCRIPT_DIR/deployment/ansible"
SRC_DIR="$SCRIPT_DIR/src"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} ✅ $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} ❌ $1"
}

# Commandes
case "$1" in
    help)
        show_help
        ;;
    install)
        log_info "Installation des dépendances..."
        cd $SRC_DIR && npm install
        chmod +x $SCRIPTS_DIR/*.sh
        log_success "Dépendances installées"
        ;;
    start)
        log_info "Démarrage de l'application..."
        cd $DOCKER_COMPOSE_DIR && docker-compose up -d
        log_success "Application démarrée"
        ;;
    start-simple)
        log_info "Démarrage de la version simplifiée..."
        cd $DOCKER_COMPOSE_DIR && docker-compose -f docker-compose-simple.yml up -d
        log_success "Version simplifiée démarrée"
        ;;
    stop)
        log_info "Arrêt de l'application..."
        cd $DOCKER_COMPOSE_DIR && docker-compose down
        log_success "Application arrêtée"
        ;;
    status)
        log_info "Vérification du statut..."
        cd $DOCKER_COMPOSE_DIR && docker-compose ps
        echo ""
        log_info "Statut des services:"
        cd $DOCKER_COMPOSE_DIR && docker-compose ps --format="table {{.Name}}\t{{.Status}}\t{{.Ports}}"
        ;;
    logs)
        log_info "Affichage des logs..."
        cd $DOCKER_COMPOSE_DIR && docker-compose logs -f
        ;;
    test)
        log_info "Lancement des tests..."
        cd $SRC_DIR && npm test
        ;;
    build)
        log_info "Construction des images Docker..."
        cd $DOCKER_COMPOSE_DIR && docker-compose build
        log_success "Images construites"
        ;;
    clean)
        log_info "Nettoyage..."
        bash $SCRIPTS_DIR/manage-docker.sh clean
        ;;
    backup)
        log_info "Sauvegarde..."
        bash $SCRIPTS_DIR/manage-docker.sh backup
        ;;
    deploy)
        log_info "Déploiement avec Ansible..."
        ansible-playbook -i $ANSIBLE_DIR/inventory.ini $ANSIBLE_DIR/ansible-deploy.yml
        ;;
    dev)
        log_info "Mode développement..."
        cd $SRC_DIR && npm run dev
        ;;
    healthcheck)
        log_info "Health check..."
        curl -f http://localhost:3000/health || echo "Application non accessible"
        ;;
    setup)
        log_info "Configuration initiale..."
        cp .env.example .env
        echo -e "${YELLOW}⚠️  N'oubliez pas d'éditer le fichier .env !${NC}"
        ./manage.sh install
        ./manage.sh build
        log_success "Configuration terminée"
        ;;
    quick-start)
        log_info "Démarrage rapide..."
        ./manage.sh setup
        ./manage.sh start-simple
        echo -e "${GREEN}✅ Application démarrée sur http://localhost:3000${NC}"
        ;;
    *)
        echo -e "${RED}Commande inconnue: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
