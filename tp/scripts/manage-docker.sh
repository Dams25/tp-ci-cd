#!/bin/bash

# ==============================================================================
# SCRIPT DE GESTION DOCKER-COMPOSE PRODUCTION - TO-DO LIST
# ==============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
COMPOSE_FILE="../deployment/docker/docker-compose.yml"
COMPOSE_SIMPLE="../deployment/docker/docker-compose-simple.yml"
ENV_FILE=".env"
PROJECT_NAME="todolist-prod"

# Fonctions utilitaires
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker n'est pas installé"
        exit 1
    fi
    
    # Vérifier Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose n'est pas installé"
        exit 1
    fi
    
    # Vérifier le fichier .env
    if [ ! -f "$ENV_FILE" ]; then
        log_warning "Fichier .env non trouvé. Copie depuis .env.example..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            log_warning "Veuillez éditer le fichier .env avec vos valeurs avant de continuer"
            exit 1
        else
            log_error "Fichier .env.example non trouvé"
            exit 1
        fi
    fi
    
    log_success "Prérequis vérifiés"
}

# Démarrage de l'application
start() {
    log_info "Démarrage de l'application TO-DO List..."
    
    # Créer les répertoires nécessaires
    mkdir -p data/mongodb
    
    # Démarrer les services
    docker-compose -f $COMPOSE_FILE --project-name $PROJECT_NAME up -d
    
    log_success "Application démarrée"
    log_info "Attendez 30 secondes pour l'initialisation complète..."
    sleep 30
    
    # Vérifier l'état des services
    status
}

# Arrêt de l'application
stop() {
    log_info "Arrêt de l'application..."
    docker-compose -f $COMPOSE_FILE --project-name $PROJECT_NAME stop
    log_success "Application arrêtée"
}

# Arrêt et suppression des conteneurs
down() {
    log_info "Arrêt et suppression des conteneurs..."
    docker-compose -f $COMPOSE_FILE --project-name $PROJECT_NAME down
    log_success "Conteneurs supprimés"
}

# Redémarrage
restart() {
    log_info "Redémarrage de l'application..."
    stop
    start
}

# Affichage des logs
logs() {
    service=${1:-""}
    if [ -z "$service" ]; then
        docker-compose -f $COMPOSE_FILE --project-name $PROJECT_NAME logs -f
    else
        docker-compose -f $COMPOSE_FILE --project-name $PROJECT_NAME logs -f "$service"
    fi
}

# Statut des services
status() {
    log_info "Statut des services:"
    docker-compose -f $COMPOSE_FILE --project-name $PROJECT_NAME ps
    
    echo ""
    log_info "Health checks:"
    
    # Vérifier l'application
    if curl -f http://localhost:3000/health > /dev/null 2>&1; then
        log_success "✅ Application TO-DO List : Healthy"
    else
        log_error "❌ Application TO-DO List : Unhealthy"
    fi
    
    # Vérifier MongoDB
    if docker exec todolist-mongodb-prod mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        log_success "✅ MongoDB : Healthy"
    else
        log_error "❌ MongoDB : Unhealthy"
    fi
    
    # Vérifier Nginx (si activé)
    if docker ps | grep -q todolist-nginx-prod; then
        if curl -f http://localhost:80/health > /dev/null 2>&1; then
            log_success "✅ Nginx : Healthy"
        else
            log_error "❌ Nginx : Unhealthy"
        fi
    fi
}

# Backup de la base de données
backup() {
    log_info "Sauvegarde de la base de données..."
    
    BACKUP_DIR="./backups"
    BACKUP_FILE="todolist-backup-$(date +%Y%m%d-%H%M%S).gz"
    
    mkdir -p $BACKUP_DIR
    
    docker exec todolist-mongodb-prod mongodump --db todolist --gzip --archive > "$BACKUP_DIR/$BACKUP_FILE"
    
    log_success "Sauvegarde créée: $BACKUP_DIR/$BACKUP_FILE"
}

# Restoration de la base de données
restore() {
    backup_file=$1
    
    if [ -z "$backup_file" ]; then
        log_error "Usage: $0 restore <fichier_backup>"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        log_error "Fichier de sauvegarde non trouvé: $backup_file"
        exit 1
    fi
    
    log_info "Restauration de la base de données depuis $backup_file..."
    
    docker exec -i todolist-mongodb-prod mongorestore --db todolist --gzip --archive < "$backup_file"
    
    log_success "Restauration terminée"
}

# Nettoyage
cleanup() {
    log_info "Nettoyage des ressources Docker..."
    
    # Arrêter et supprimer les conteneurs
    down
    
    # Supprimer les images
    docker rmi todolist-app:production 2>/dev/null || true
    
    # Nettoyer les volumes (ATTENTION: supprime les données!)
    read -p "Supprimer les volumes de données? (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose -f $COMPOSE_FILE --project-name $PROJECT_NAME down -v
        log_warning "Volumes supprimés"
    fi
    
    log_success "Nettoyage terminé"
}

# Affichage de l'aide
help() {
    echo "Usage: $0 {start|stop|restart|down|logs|status|backup|restore|cleanup|help}"
    echo ""
    echo "Commandes:"
    echo "  start    - Démarrer l'application"
    echo "  stop     - Arrêter l'application"
    echo "  restart  - Redémarrer l'application"
    echo "  down     - Arrêter et supprimer les conteneurs"
    echo "  logs     - Afficher les logs (optionnel: nom du service)"
    echo "  status   - Afficher le statut des services"
    echo "  backup   - Sauvegarder la base de données"
    echo "  restore  - Restaurer la base de données"
    echo "  cleanup  - Nettoyer les ressources Docker"
    echo "  help     - Afficher cette aide"
    echo ""
    echo "Exemples:"
    echo "  $0 start"
    echo "  $0 logs todolist-app"
    echo "  $0 restore ./backups/todolist-backup-20241206-120000.gz"
}

# Script principal
main() {
    case "$1" in
        start)
            check_prerequisites
            start
            ;;
        stop)
            stop
            ;;
        restart)
            check_prerequisites
            restart
            ;;
        down)
            down
            ;;
        logs)
            logs "$2"
            ;;
        status)
            status
            ;;
        backup)
            backup
            ;;
        restore)
            restore "$2"
            ;;
        cleanup)
            cleanup
            ;;
        help|--help|-h)
            help
            ;;
        *)
            log_error "Commande inconnue: $1"
            help
            exit 1
            ;;
    esac
}

# Exécution du script principal
main "$@"
