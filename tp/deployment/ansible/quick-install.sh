#!/bin/bash

# ==============================================================================
# SCRIPT D'INSTALLATION RAPIDE - INFRASTRUCTURE ANSIBLE
# Configuration automatique d'un serveur pour Docker en production
# ==============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY_FILE="$SCRIPT_DIR/inventory.ini"
PLAYBOOK_FILE="$SCRIPT_DIR/playbook-infrastructure.yml"

# Fonctions d'affichage
print_header() {
    echo -e "${BLUE}${BOLD}"
    echo "========================================================================"
    echo "🚀 INSTALLATION INFRASTRUCTURE DOCKER - ANSIBLE"
    echo "========================================================================"
    echo -e "${NC}"
}

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
    log_info "🔍 Vérification des prérequis..."
    
    # Vérifier Ansible
    if ! command -v ansible &> /dev/null; then
        log_error "Ansible n'est pas installé !"
        echo "Installation: sudo apt install ansible"
        exit 1
    fi
    
    # Vérifier Python
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 n'est pas installé !"
        exit 1
    fi
    
    # Vérifier SSH
    if ! command -v ssh &> /dev/null; then
        log_error "SSH client n'est pas installé !"
        exit 1
    fi
    
    log_success "✅ Prérequis validés"
}

# Configuration interactive
interactive_setup() {
    log_info "⚙️  Configuration interactive..."
    
    echo ""
    echo -e "${YELLOW}Configuration des serveurs cibles:${NC}"
    
    # Demander l'IP du serveur
    read -p "🌐 Adresse IP du serveur cible: " SERVER_IP
    if [[ -z "$SERVER_IP" ]]; then
        log_error "Adresse IP requise !"
        exit 1
    fi
    
    # Demander l'utilisateur SSH
    read -p "👤 Utilisateur SSH (default: ubuntu): " SSH_USER
    SSH_USER=${SSH_USER:-ubuntu}
    
    # Demander la clé SSH
    read -p "🔑 Chemin vers la clé SSH privée (default: ~/.ssh/id_rsa): " SSH_KEY
    SSH_KEY=${SSH_KEY:-~/.ssh/id_rsa}
    
    # Demander l'utilisateur Docker
    read -p "🐳 Nom d'utilisateur Docker (default: deploy): " DOCKER_USER
    DOCKER_USER=${DOCKER_USER:-deploy}
    
    # Demander le répertoire d'installation
    read -p "📁 Répertoire d'installation (default: /opt/todolist): " APP_DIR
    APP_DIR=${APP_DIR:-/opt/todolist}
    
    # Demander options sécurité
    read -p "🔥 Activer le firewall? (y/N): " ENABLE_FIREWALL
    ENABLE_FIREWALL=${ENABLE_FIREWALL:-N}
    
    # Demander monitoring
    read -p "📊 Activer le monitoring? (y/N): " ENABLE_MONITORING
    ENABLE_MONITORING=${ENABLE_MONITORING:-N}
}

# Génération de l'inventaire
generate_inventory() {
    log_info "📝 Génération de l'inventaire..."
    
    cat > "$INVENTORY_FILE" << EOF
# ==============================================================================
# INVENTORY GÉNÉRÉ AUTOMATIQUEMENT
# $(date)
# ==============================================================================

[docker_servers]
production-server ansible_host=$SERVER_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$SSH_KEY

[docker_servers:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
ansible_python_interpreter=/usr/bin/python3

# Configuration
docker_user=$DOCKER_USER
app_directory=$APP_DIR
firewall_enabled=$([[ "$ENABLE_FIREWALL" =~ ^[Yy]$ ]] && echo "true" || echo "false")
monitoring_enabled=$([[ "$ENABLE_MONITORING" =~ ^[Yy]$ ]] && echo "true" || echo "false")
update_system=true

# Ports de l'application
app_ports=[3000, 4000, 80, 443]
ssh_port=22
EOF
    
    log_success "✅ Inventaire généré: $INVENTORY_FILE"
}

# Test de connectivité
test_connectivity() {
    log_info "🔗 Test de connectivité..."
    
    if ansible docker_servers -i "$INVENTORY_FILE" -m ping; then
        log_success "✅ Connexion au serveur réussie"
    else
        log_error "❌ Impossible de se connecter au serveur"
        echo ""
        echo "Vérifiez:"
        echo "- L'adresse IP du serveur"
        echo "- Les permissions de la clé SSH"
        echo "- La connectivité réseau"
        exit 1
    fi
}

# Exécution du playbook
run_playbook() {
    log_info "🚀 Exécution du playbook d'infrastructure..."
    
    echo ""
    echo -e "${YELLOW}Voulez-vous exécuter en mode simulation d'abord? (y/N):${NC}"
    read -p "" DRY_RUN
    
    if [[ "$DRY_RUN" =~ ^[Yy]$ ]]; then
        log_info "🧪 Mode simulation (--check)..."
        ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" --check
        
        echo ""
        echo -e "${YELLOW}Continuer avec l'installation réelle? (y/N):${NC}"
        read -p "" CONTINUE
        
        if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
            log_info "Installation annulée par l'utilisateur"
            exit 0
        fi
    fi
    
    log_info "⚡ Installation en cours..."
    ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE"
}

# Vérification post-installation
verify_installation() {
    log_info "✅ Vérification post-installation..."
    
    # Test Docker
    log_info "🐳 Test Docker..."
    ansible docker_servers -i "$INVENTORY_FILE" -m command -a "docker --version" -b
    
    # Test Docker Compose
    log_info "🔧 Test Docker Compose..."
    ansible docker_servers -i "$INVENTORY_FILE" -m command -a "docker compose version" -b
    
    # Test permissions utilisateur
    log_info "👤 Test permissions utilisateur..."
    ansible docker_servers -i "$INVENTORY_FILE" -m command -a "docker ps" --become-user="$DOCKER_USER"
    
    log_success "✅ Installation vérifiée avec succès !"
}

# Affichage du résumé
show_summary() {
    echo ""
    echo -e "${GREEN}${BOLD}"
    echo "========================================================================"
    echo "🎉 INSTALLATION TERMINÉE AVEC SUCCÈS !"
    echo "========================================================================"
    echo -e "${NC}"
    
    echo -e "${BLUE}📋 Résumé de l'installation:${NC}"
    echo "• Serveur: $SERVER_IP"
    echo "• Utilisateur Docker: $DOCKER_USER"
    echo "• Répertoire: $APP_DIR"
    echo "• Firewall: $([[ "$ENABLE_FIREWALL" =~ ^[Yy]$ ]] && echo "Activé" || echo "Désactivé")"
    echo "• Monitoring: $([[ "$ENABLE_MONITORING" =~ ^[Yy]$ ]] && echo "Activé" || echo "Désactivé")"
    
    echo ""
    echo -e "${YELLOW}🚀 Prochaines étapes:${NC}"
    echo "1. Connectez-vous au serveur: ssh $DOCKER_USER@$SERVER_IP"
    echo "2. Déployez votre application dans: $APP_DIR"
    echo "3. Utilisez les scripts de gestion:"
    echo "   • $APP_DIR/scripts/deploy.sh"
    echo "   • $APP_DIR/scripts/backup.sh"
    echo "   • $APP_DIR/scripts/maintenance.sh"
    
    echo ""
    echo -e "${GREEN}✨ Infrastructure Docker prête pour la production ! ✨${NC}"
}

# Menu principal
show_menu() {
    echo ""
    echo -e "${BLUE}${BOLD}Options disponibles:${NC}"
    echo "1) Installation complète (recommandé)"
    echo "2) Test de connectivité uniquement"
    echo "3) Génération d'inventaire uniquement"
    echo "4) Exécution playbook avec inventaire existant"
    echo "5) Aide et documentation"
    echo "6) Quitter"
    echo ""
}

# Fonction d'aide
show_help() {
    echo -e "${BLUE}${BOLD}"
    echo "========================================================================"
    echo "📚 AIDE - INSTALLATION INFRASTRUCTURE ANSIBLE"
    echo "========================================================================"
    echo -e "${NC}"
    
    echo "Ce script automatise l'installation d'une infrastructure Docker"
    echo "sécurisée sur un serveur Ubuntu/Debian via Ansible."
    echo ""
    echo -e "${YELLOW}Utilisation:${NC}"
    echo "./quick-install.sh [option]"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "--interactive    : Mode interactif (défaut)"
    echo "--help          : Afficher cette aide"
    echo "--check         : Mode simulation uniquement"
    echo ""
    echo -e "${YELLOW}Prérequis:${NC}"
    echo "• Ansible installé"
    echo "• Accès SSH au serveur cible"
    echo "• Privilèges sudo sur le serveur"
    echo ""
    echo -e "${YELLOW}Fichiers générés:${NC}"
    echo "• inventory.ini : Configuration des serveurs"
    echo "• Logs d'installation dans /tmp/"
    echo ""
    echo -e "${YELLOW}Documentation complète:${NC}"
    echo "Voir: README-INFRASTRUCTURE.md"
}

# Programme principal
main() {
    print_header
    
    case "${1:-interactive}" in
        --help|-h)
            show_help
            exit 0
            ;;
        --check)
            check_prerequisites
            if [[ -f "$INVENTORY_FILE" ]]; then
                ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" --check
            else
                log_error "Fichier d'inventaire non trouvé. Lancez d'abord l'installation interactive."
            fi
            exit 0
            ;;
        --interactive|interactive)
            # Mode interactif par défaut
            check_prerequisites
            
            while true; do
                show_menu
                read -p "Votre choix (1-6): " choice
                
                case $choice in
                    1)
                        interactive_setup
                        generate_inventory
                        test_connectivity
                        run_playbook
                        verify_installation
                        show_summary
                        break
                        ;;
                    2)
                        if [[ -f "$INVENTORY_FILE" ]]; then
                            test_connectivity
                        else
                            log_error "Fichier d'inventaire non trouvé"
                        fi
                        ;;
                    3)
                        interactive_setup
                        generate_inventory
                        ;;
                    4)
                        if [[ -f "$INVENTORY_FILE" ]]; then
                            run_playbook
                            verify_installation
                        else
                            log_error "Fichier d'inventaire non trouvé"
                        fi
                        ;;
                    5)
                        show_help
                        ;;
                    6)
                        log_info "Au revoir !"
                        exit 0
                        ;;
                    *)
                        log_warning "Option invalide"
                        ;;
                esac
            done
            ;;
        *)
            log_error "Option inconnue: $1"
            show_help
            exit 1
            ;;
    esac
}

# Gestion des signaux
trap 'log_warning "Installation interrompue par l utilisateur"; exit 1' INT TERM

# Exécution
main "$@"
