#!/bin/bash

# ============================================
# SCRIPT: Validation de la solution Ansible
# DESCRIPTION: Vérifie la complétude et cohérence
# VERSION: 1.0
# ============================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0
WARNINGS=0

# Fonctions utilitaires
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((ERRORS++))
}

# Vérification de la structure des répertoires
check_directory_structure() {
    log_info "Vérification de la structure des répertoires..."
    
    local required_dirs=(
        "roles/deployment/pre-deployment/tasks"
        "roles/deployment/file-transfer/tasks"
        "roles/deployment/secrets-management/tasks"
        "roles/deployment/docker-build/tasks"
        "roles/deployment/service-deployment/tasks"
        "roles/deployment/health-checks/tasks"
        "roles/deployment/post-deployment/tasks"
        "roles/deployment/handlers"
        "roles/deployment/templates"
        "vars"
        "inventory"
        "logs"
        "scripts"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            log_success "Répertoire trouvé: $dir"
        else
            log_error "Répertoire manquant: $dir"
        fi
    done
}

# Vérification des fichiers essentiels
check_essential_files() {
    log_info "Vérification des fichiers essentiels..."
    
    local required_files=(
        "playbook-deploy.yml"
        "vars/deploy.yml"
        "inventory.ini"
        "ansible.cfg"
        "Makefile"
        "GUIDE-DEPLOIEMENT.md"
        "README-INFRASTRUCTURE.md"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            log_success "Fichier trouvé: $file"
        else
            log_error "Fichier manquant: $file"
        fi
    done
}

# Vérification des rôles de déploiement
check_deployment_roles() {
    log_info "Vérification des rôles de déploiement..."
    
    local roles=(
        "pre-deployment"
        "file-transfer"
        "secrets-management"
        "docker-build"
        "service-deployment"
        "health-checks"
        "post-deployment"
    )
    
    for role in "${roles[@]}"; do
        local main_file="roles/deployment/$role/tasks/main.yml"
        if [ -f "$main_file" ]; then
            log_success "Rôle trouvé: $role"
            
            # Vérification de la syntaxe YAML basique
            if command -v yamllint &> /dev/null; then
                if yamllint "$main_file" &> /dev/null; then
                    log_success "Syntaxe YAML valide: $role"
                else
                    log_warning "Problème de syntaxe YAML: $role"
                fi
            fi
        else
            log_error "Rôle manquant: $role"
        fi
    done
}

# Vérification des templates
check_templates() {
    log_info "Vérification des templates..."
    
    local templates=(
        ".env.j2"
        "docker-compose.yml.j2"
        "rollback.sh.j2"
        "health-report.txt.j2"
        "final-deployment-report.md.j2"
    )
    
    for template in "${templates[@]}"; do
        local template_file="roles/deployment/templates/$template"
        if [ -f "$template_file" ]; then
            log_success "Template trouvé: $template"
        else
            log_warning "Template manquant: $template"
        fi
    done
}

# Vérification des handlers
check_handlers() {
    log_info "Vérification des handlers..."
    
    local handlers_file="roles/deployment/handlers/main.yml"
    if [ -f "$handlers_file" ]; then
        log_success "Handlers trouvés"
        
        # Vérification des handlers essentiels
        local essential_handlers=(
            "docker build required"
            "services restart required"
            "trigger rollback"
            "send deployment success notification"
            "send deployment failure notification"
            "send health alert"
        )
        
        for handler in "${essential_handlers[@]}"; do
            if grep -q "$handler" "$handlers_file"; then
                log_success "Handler trouvé: $handler"
            else
                log_warning "Handler manquant: $handler"
            fi
        done
    else
        log_error "Fichier handlers manquant"
    fi
}

# Vérification de la configuration
check_configuration() {
    log_info "Vérification de la configuration..."
    
    # Vérification du playbook principal
    local playbook="playbook-deploy.yml"
    if [ -f "$playbook" ]; then
        if grep -q "pre-deployment" "$playbook" && \
           grep -q "file-transfer" "$playbook" && \
           grep -q "secrets-management" "$playbook" && \
           grep -q "docker-build" "$playbook" && \
           grep -q "service-deployment" "$playbook" && \
           grep -q "health-checks" "$playbook" && \
           grep -q "post-deployment" "$playbook"; then
            log_success "Playbook principal complet"
        else
            log_error "Playbook principal incomplet - rôles manquants"
        fi
    fi
    
    # Vérification des variables
    local vars_file="vars/deploy.yml"
    if [ -f "$vars_file" ]; then
        local essential_vars=(
            "app_version"
            "app_environment"
            "deployment"
            "docker"
            "mongodb"
            "health_checks"
            "rollback"
            "monitoring"
            "notifications"
        )
        
        for var in "${essential_vars[@]}"; do
            if grep -q "$var:" "$vars_file"; then
                log_success "Variable trouvée: $var"
            else
                log_warning "Variable manquante: $var"
            fi
        done
    fi
}

# Vérification des outils requis
check_required_tools() {
    log_info "Vérification des outils requis..."
    
    local tools=(
        "ansible-playbook"
        "ansible-vault"
        "make"
        "git"
    )
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            log_success "Outil trouvé: $tool"
        else
            log_warning "Outil manquant: $tool"
        fi
    done
}

# Vérification de la syntaxe Ansible
check_ansible_syntax() {
    log_info "Vérification de la syntaxe Ansible..."
    
    if command -v ansible-playbook &> /dev/null; then
        if [ -f "playbook-deploy.yml" ]; then
            if ansible-playbook playbook-deploy.yml --syntax-check &> /dev/null; then
                log_success "Syntaxe Ansible valide"
            else
                log_error "Erreur de syntaxe Ansible"
            fi
        fi
    else
        log_warning "Ansible non installé - impossible de vérifier la syntaxe"
    fi
}

# Vérification du Makefile
check_makefile() {
    log_info "Vérification du Makefile..."
    
    if [ -f "Makefile" ]; then
        local essential_targets=(
            "help"
            "deploy"
            "rollback"
            "health-check"
            "backup"
            "clean"
        )
        
        for target in "${essential_targets[@]}"; do
            if grep -q "^$target:" "Makefile"; then
                log_success "Target Makefile trouvé: $target"
            else
                log_warning "Target Makefile manquant: $target"
            fi
        done
    fi
}

# Vérification de la documentation
check_documentation() {
    log_info "Vérification de la documentation..."
    
    local docs=(
        "GUIDE-DEPLOIEMENT.md"
        "README-INFRASTRUCTURE.md"
    )
    
    for doc in "${docs[@]}"; do
        if [ -f "$doc" ]; then
            log_success "Documentation trouvée: $doc"
            
            # Vérification du contenu minimal
            if grep -q "Installation" "$doc" && \
               grep -q "Configuration" "$doc" && \
               grep -q "Déploiement" "$doc"; then
                log_success "Contenu documentation complet: $doc"
            else
                log_warning "Contenu documentation incomplet: $doc"
            fi
        else
            log_error "Documentation manquante: $doc"
        fi
    done
}

# Génération du rapport final
generate_report() {
    echo ""
    echo "=============================================="
    echo "           RAPPORT DE VALIDATION"
    echo "=============================================="
    echo ""
    
    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        log_success "✨ PARFAIT! Solution complète et fonctionnelle"
        echo ""
        echo "🎉 La solution Ansible de déploiement est prête à l'utilisation!"
        echo ""
        echo "📋 Prochaines étapes:"
        echo "1. Configurer l'inventaire (inventory.ini)"
        echo "2. Créer les secrets avec ansible-vault"
        echo "3. Adapter les variables dans vars/deploy.yml"
        echo "4. Tester avec: make dry-run"
        echo "5. Déployer avec: make deploy"
        
    elif [ $ERRORS -eq 0 ]; then
        log_warning "⚠️  Solution fonctionnelle avec $WARNINGS avertissement(s)"
        echo ""
        echo "La solution peut être utilisée mais des améliorations sont recommandées."
        
    else
        log_error "❌ Solution incomplète: $ERRORS erreur(s), $WARNINGS avertissement(s)"
        echo ""
        echo "Des corrections sont nécessaires avant utilisation."
    fi
    
    echo ""
    echo "📊 Résumé:"
    echo "- Erreurs: $ERRORS"
    echo "- Avertissements: $WARNINGS"
    echo "- Date: $(date)"
    echo ""
    
    return $ERRORS
}

# Point d'entrée principal
main() {
    echo "🔍 Validation de la solution Ansible de déploiement"
    echo "=================================================="
    echo ""
    
    cd "$SCRIPT_DIR"
    
    check_directory_structure
    echo ""
    
    check_essential_files
    echo ""
    
    check_deployment_roles
    echo ""
    
    check_templates
    echo ""
    
    check_handlers
    echo ""
    
    check_configuration
    echo ""
    
    check_required_tools
    echo ""
    
    check_ansible_syntax
    echo ""
    
    check_makefile
    echo ""
    
    check_documentation
    echo ""
    
    generate_report
}

# Exécution si appelé directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
