# ============================================
# MAKEFILE: Automatisation des tâches de déploiement
# DESCRIPTION: Interface unifiée pour toutes les opérations
# VERSION: 1.0
# ============================================

.PHONY: help deploy rollback health-check logs backup clean test docs

# Variables par défaut
APP_VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "latest")
ENVIRONMENT ?= production
INVENTORY ?= inventory.ini
PLAYBOOK ?= playbook-deploy.yml
ANSIBLE_CONFIG ?= ansible.cfg

# Configuration
ANSIBLE_OPTS := -i $(INVENTORY) --extra-vars "app_version=$(APP_VERSION)" --extra-vars "app_environment=$(ENVIRONMENT)"
ANSIBLE_VAULT_FILE := vars/vault.yml
LOG_DIR := logs
BACKUP_DIR := backup

# Couleurs pour l'affichage
BLUE := \033[34m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

help: ## Affiche l'aide
	@echo "$(BLUE)🚀 Système de déploiement TODO List$(RESET)"
	@echo ""
	@echo "$(GREEN)Commandes disponibles:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Variables d'environnement:$(RESET)"
	@echo "  APP_VERSION   Version à déployer (défaut: $(APP_VERSION))"
	@echo "  ENVIRONMENT   Environnement cible (défaut: $(ENVIRONMENT))"
	@echo "  INVENTORY     Fichier d'inventaire (défaut: $(INVENTORY))"
	@echo ""
	@echo "$(YELLOW)Exemples:$(RESET)"
	@echo "  make deploy APP_VERSION=1.2.3 ENVIRONMENT=staging"
	@echo "  make rollback ROLLBACK_TO=1.2.2"
	@echo "  make health-check"

# Vérifications préliminaires
check-requirements: ## Vérifie les prérequis
	@echo "$(BLUE)🔍 Vérification des prérequis...$(RESET)"
	@command -v ansible-playbook >/dev/null || (echo "$(RED)❌ Ansible non installé$(RESET)" && exit 1)
	@command -v git >/dev/null || (echo "$(RED)❌ Git non installé$(RESET)" && exit 1)
	@test -f $(INVENTORY) || (echo "$(RED)❌ Fichier d'inventaire manquant: $(INVENTORY)$(RESET)" && exit 1)
	@test -f $(PLAYBOOK) || (echo "$(RED)❌ Playbook manquant: $(PLAYBOOK)$(RESET)" && exit 1)
	@echo "$(GREEN)✅ Tous les prérequis sont satisfaits$(RESET)"

check-vault: ## Vérifie l'accès au vault Ansible
	@echo "$(BLUE)🔐 Vérification du vault...$(RESET)"
	@ansible-vault view $(ANSIBLE_VAULT_FILE) --vault-password-file .vault_pass >/dev/null 2>&1 || \
		(echo "$(RED)❌ Impossible d'accéder au vault. Vérifiez le mot de passe.$(RESET)" && exit 1)
	@echo "$(GREEN)✅ Vault accessible$(RESET)"

syntax-check: check-requirements ## Vérifie la syntaxe du playbook
	@echo "$(BLUE)📝 Vérification de la syntaxe...$(RESET)"
	@ansible-playbook $(PLAYBOOK) $(ANSIBLE_OPTS) --syntax-check
	@echo "$(GREEN)✅ Syntaxe correcte$(RESET)"

dry-run: check-requirements check-vault ## Simulation de déploiement (dry-run)
	@echo "$(BLUE)🧪 Simulation de déploiement...$(RESET)"
	@ansible-playbook $(PLAYBOOK) $(ANSIBLE_OPTS) --check --diff --vault-password-file .vault_pass

deploy: check-requirements check-vault syntax-check ## Déploie l'application
	@echo "$(BLUE)🚀 Déploiement de $(APP_VERSION) en $(ENVIRONMENT)...$(RESET)"
	@mkdir -p $(LOG_DIR)
	@ansible-playbook $(PLAYBOOK) $(ANSIBLE_OPTS) \
		--vault-password-file .vault_pass \
		--extra-vars "deployment_start_time=$(shell date +%s)" \
		| tee $(LOG_DIR)/deploy-$(APP_VERSION)-$(shell date +%s).log
	@echo "$(GREEN)✅ Déploiement terminé$(RESET)"

deploy-staging: ## Déploiement en staging
	@$(MAKE) deploy ENVIRONMENT=staging INVENTORY=inventory-staging.ini

deploy-production: ## Déploiement en production
	@echo "$(YELLOW)⚠️  Déploiement en PRODUCTION$(RESET)"
	@read -p "Êtes-vous sûr de vouloir déployer $(APP_VERSION) en production? [y/N] " confirm && \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			$(MAKE) deploy ENVIRONMENT=production; \
		else \
			echo "$(YELLOW)Déploiement annulé$(RESET)"; \
		fi

rollback: ## Effectue un rollback (ROLLBACK_TO=version)
	@if [ -z "$(ROLLBACK_TO)" ]; then \
		echo "$(RED)❌ Variable ROLLBACK_TO requise$(RESET)"; \
		echo "Exemple: make rollback ROLLBACK_TO=1.2.2"; \
		exit 1; \
	fi
	@echo "$(YELLOW)🔄 Rollback vers $(ROLLBACK_TO)...$(RESET)"
	@ansible-playbook playbooks/rollback.yml $(ANSIBLE_OPTS) \
		--extra-vars "rollback_to_version=$(ROLLBACK_TO)" \
		--vault-password-file .vault_pass
	@echo "$(GREEN)✅ Rollback terminé$(RESET)"

emergency-rollback: ## Rollback d'urgence vers la dernière version stable
	@echo "$(RED)🚨 ROLLBACK D'URGENCE$(RESET)"
	@ansible-playbook playbooks/emergency-rollback.yml $(ANSIBLE_OPTS) \
		--vault-password-file .vault_pass

health-check: ## Vérifie la santé de l'application
	@echo "$(BLUE)🏥 Vérification de santé...$(RESET)"
	@ansible-playbook playbooks/health-check.yml $(ANSIBLE_OPTS) \
		--vault-password-file .vault_pass

status: ## Affiche le statut actuel du déploiement
	@echo "$(BLUE)📊 Statut du déploiement...$(RESET)"
	@ansible-playbook playbooks/status.yml $(ANSIBLE_OPTS) \
		--vault-password-file .vault_pass

logs: ## Affiche les logs de l'application
	@echo "$(BLUE)📋 Logs de l'application...$(RESET)"
	@ansible all $(ANSIBLE_OPTS) -m shell \
		-a "cd {{ app_directory }} && docker-compose logs --tail=100 -f app"

logs-follow: ## Suit les logs en temps réel
	@echo "$(BLUE)📋 Suivi des logs en temps réel...$(RESET)"
	@ansible all $(ANSIBLE_OPTS) -m shell \
		-a "cd {{ app_directory }} && docker-compose logs -f"

backup: ## Effectue une sauvegarde manuelle
	@echo "$(BLUE)💾 Sauvegarde manuelle...$(RESET)"
	@ansible-playbook playbooks/backup.yml $(ANSIBLE_OPTS) \
		--vault-password-file .vault_pass

restore: ## Restaure depuis une sauvegarde (BACKUP_DATE=YYYY-MM-DD)
	@if [ -z "$(BACKUP_DATE)" ]; then \
		echo "$(RED)❌ Variable BACKUP_DATE requise$(RESET)"; \
		echo "Exemple: make restore BACKUP_DATE=2024-01-15"; \
		exit 1; \
	fi
	@echo "$(YELLOW)📥 Restauration depuis $(BACKUP_DATE)...$(RESET)"
	@ansible-playbook playbooks/restore.yml $(ANSIBLE_OPTS) \
		--extra-vars "backup_date=$(BACKUP_DATE)" \
		--vault-password-file .vault_pass

test: ## Lance les tests sur l'application déployée
	@echo "$(BLUE)🧪 Lancement des tests...$(RESET)"
	@ansible-playbook playbooks/test.yml $(ANSIBLE_OPTS) \
		--vault-password-file .vault_pass

clean: ## Nettoie les ressources Docker
	@echo "$(BLUE)🧹 Nettoyage des ressources...$(RESET)"
	@ansible-playbook playbooks/cleanup.yml $(ANSIBLE_OPTS) \
		--vault-password-file .vault_pass

# Par défaut, afficher l'aide
.DEFAULT_GOAL := help

## Configuration initiale
setup:
	@echo "$(BLUE)📋 Configuration initiale...$(NC)"
	@if [ ! -f $(INVENTORY) ]; then \
		cp inventory.ini.example $(INVENTORY); \
		echo "$(GREEN)✅ Fichier d'inventaire créé: $(INVENTORY)$(NC)"; \
		echo "$(YELLOW)⚠️  Éditez $(INVENTORY) avec vos serveurs !$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Fichier $(INVENTORY) existe déjà$(NC)"; \
	fi
	@chmod +x quick-install.sh
	@echo "$(GREEN)✅ Configuration terminée$(NC)"

## Test de connectivité
check:
	@echo "$(BLUE)🔗 Test de connectivité...$(NC)"
	@if [ ! -f $(INVENTORY) ]; then \
		echo "$(YELLOW)⚠️  Lancez d'abord: make setup$(NC)"; \
		exit 1; \
	fi
	ansible docker_servers -i $(INVENTORY) -m ping
	@echo "$(GREEN)✅ Connectivité validée$(NC)"

## Déploiement infrastructure complète
deploy:
	@echo "$(BLUE)🚀 Déploiement infrastructure...$(NC)"
	@if [ ! -f $(INVENTORY) ]; then \
		echo "$(YELLOW)⚠️  Lancez d'abord: make setup$(NC)"; \
		exit 1; \
	fi
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK)
	@echo "$(GREEN)✅ Déploiement terminé$(NC)"

## Simulation du déploiement
deploy-check:
	@echo "$(BLUE)🧪 Simulation du déploiement...$(NC)"
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --check

## Déploiement avec tags spécifiques
deploy-tags:
	@echo "$(BLUE)🎯 Déploiement avec tags: $(TAGS)$(NC)"
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --tags "$(TAGS)"

## Installation Docker uniquement
docker:
	@echo "$(BLUE)🐳 Installation Docker...$(NC)"
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --tags "docker"

## Configuration sécurité uniquement
security:
	@echo "$(BLUE)🔒 Configuration sécurité...$(NC)"
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --tags "security,firewall"

## Installation monitoring
monitoring:
	@echo "$(BLUE)📊 Installation monitoring...$(NC)"
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --tags "monitoring" -e "monitoring_enabled=true"

## Vérification post-installation
verify:
	@echo "$(BLUE)✅ Vérification post-installation...$(NC)"
	@echo "$(YELLOW)🐳 Version Docker:$(NC)"
	ansible docker_servers -i $(INVENTORY) -m command -a "docker --version"
	@echo "$(YELLOW)🔧 Version Docker Compose:$(NC)"
	ansible docker_servers -i $(INVENTORY) -m command -a "docker compose version"
	@echo "$(YELLOW)👤 Test permissions:$(NC)"
	ansible docker_servers -i $(INVENTORY) -m command -a "docker ps" --become-user=deploy
	@echo "$(GREEN)✅ Vérification terminée$(NC)"

## Statut des serveurs
status:
	@echo "$(BLUE)📊 Statut des serveurs...$(NC)"
	ansible docker_servers -i $(INVENTORY) -m command -a "systemctl status docker --no-pager"
	ansible docker_servers -i $(INVENTORY) -m command -a "df -h"

## Nettoyage
clean:
	@echo "$(BLUE)🧹 Nettoyage...$(NC)"
	@rm -f *.retry
	@rm -rf __pycache__
	@find . -name "*.pyc" -delete
	@echo "$(GREEN)✅ Nettoyage terminé$(NC)"

## Afficher les logs
logs:
	@echo "$(BLUE)📝 Logs récents...$(NC)"
	@if [ -f ansible.log ]; then \
		tail -50 ansible.log; \
	else \
		echo "$(YELLOW)Aucun fichier de log trouvé$(NC)"; \
	fi

## Installation interactive
interactive:
	@echo "$(BLUE)🔧 Installation interactive...$(NC)"
	./quick-install.sh

## Mode rapide (tout en un)
quick: setup check deploy verify
	@echo "$(GREEN)🎉 Installation rapide terminée !$(NC)"

## Déploiement production sécurisé
production:
	@echo "$(BLUE)🏭 Déploiement production...$(NC)"
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) \
		-e "firewall_enabled=true" \
		-e "monitoring_enabled=true" \
		-e "fail2ban_enabled=true" \
		-e "automatic_updates.enabled=true"
	@echo "$(GREEN)✅ Déploiement production terminé$(NC)"

## Aide détaillée
info:
	@echo "$(BLUE)📚 Informations détaillées:$(NC)"
	@echo ""
	@echo "$(GREEN)Fichiers principaux:$(NC)"
	@echo "  playbook-infrastructure.yml - Playbook principal"
	@echo "  inventory.ini               - Configuration serveurs"
	@echo "  vars/infrastructure.yml     - Variables principales"
	@echo "  vars/security.yml           - Configuration sécurité"
	@echo ""
	@echo "$(GREEN)Rôles disponibles:$(NC)"
	@echo "  system-update     - Mise à jour système"
	@echo "  docker-installation - Installation Docker"
	@echo "  user-configuration - Configuration utilisateur"
	@echo "  firewall-security  - Sécurité et firewall"
	@echo "  directory-structure - Structure répertoires"
	@echo "  monitoring-tools   - Outils de monitoring"
	@echo ""
	@echo "$(GREEN)Documentation:$(NC)"
	@echo "  README-INFRASTRUCTURE.md - Guide complet"
	@echo ""
