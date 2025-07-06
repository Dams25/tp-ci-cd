# =============================================================================
# MAKEFILE - TODOLIST PRODUCTION
# =============================================================================

.PHONY: help install start stop status logs clean test build deploy

# Variables
DOCKER_COMPOSE_DIR = deployment/docker
ANSIBLE_DIR = deployment/ansible
SRC_DIR = src
SCRIPTS_DIR = scripts

# Couleurs
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m

help: ## Afficher l'aide
	@echo "$(GREEN)TodoList Production - Commandes disponibles:$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Installer les dépendances
	@echo "$(GREEN)Installation des dépendances...$(NC)"
	cd $(SRC_DIR) && npm install
	chmod +x $(SCRIPTS_DIR)/*.sh

start: ## Démarrer l'application
	@echo "$(GREEN)Démarrage de l'application...$(NC)"
	cd $(DOCKER_COMPOSE_DIR) && docker-compose up -d

start-simple: ## Démarrer la version simplifiée
	@echo "$(GREEN)Démarrage de la version simplifiée...$(NC)"
	cd $(DOCKER_COMPOSE_DIR) && docker-compose -f docker-compose-simple.yml up -d

stop: ## Arrêter l'application
	@echo "$(GREEN)Arrêt de l'application...$(NC)"
	cd $(DOCKER_COMPOSE_DIR) && docker-compose down

status: ## Vérifier le statut
	@echo "$(GREEN)Vérification du statut...$(NC)"
	bash $(SCRIPTS_DIR)/manage-docker.sh status

logs: ## Afficher les logs
	@echo "$(GREEN)Affichage des logs...$(NC)"
	cd $(DOCKER_COMPOSE_DIR) && docker-compose logs -f

test: ## Lancer les tests
	@echo "$(GREEN)Lancement des tests...$(NC)"
	cd $(SRC_DIR) && npm test

build: ## Construire les images Docker
	@echo "$(GREEN)Construction des images Docker...$(NC)"
	cd $(DOCKER_COMPOSE_DIR) && docker-compose build

clean: ## Nettoyer les conteneurs et volumes
	@echo "$(GREEN)Nettoyage...$(NC)"
	bash $(SCRIPTS_DIR)/manage-docker.sh clean

backup: ## Sauvegarder les données
	@echo "$(GREEN)Sauvegarde...$(NC)"
	bash $(SCRIPTS_DIR)/manage-docker.sh backup

deploy: ## Déployer avec Ansible
	@echo "$(GREEN)Déploiement avec Ansible...$(NC)"
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.ini $(ANSIBLE_DIR)/ansible-deploy.yml

dev: ## Mode développement
	@echo "$(GREEN)Mode développement...$(NC)"
	cd $(SRC_DIR) && npm run dev

healthcheck: ## Vérifier la santé de l'application
	@echo "$(GREEN)Health check...$(NC)"
	curl -f http://localhost:3000/health || echo "Application non accessible"

# Commandes Docker avancées
docker-rebuild: ## Reconstruire et redémarrer
	@echo "$(GREEN)Reconstruction et redémarrage...$(NC)"
	$(MAKE) stop
	$(MAKE) build
	$(MAKE) start

docker-reset: ## Reset complet (ATTENTION: supprime tout)
	@echo "$(GREEN)Reset complet...$(NC)"
	cd $(DOCKER_COMPOSE_DIR) && docker-compose down -v --rmi all
	docker system prune -f

# Commandes de développement
lint: ## Vérifier le code
	@echo "$(GREEN)Vérification du code...$(NC)"
	cd $(SRC_DIR) && npm run lint || echo "Linter non configuré"

format: ## Formater le code
	@echo "$(GREEN)Formatage du code...$(NC)"
	cd $(SRC_DIR) && npm run format || echo "Formateur non configuré"

# Commandes de monitoring
monitor: ## Surveiller les ressources
	@echo "$(GREEN)Surveillance des ressources...$(NC)"
	docker stats

ps: ## Lister les conteneurs
	@echo "$(GREEN)Conteneurs en cours d'exécution:$(NC)"
	docker ps

# Aide avancée
setup: ## Configuration initiale complète
	@echo "$(GREEN)Configuration initiale...$(NC)"
	cp .env.example .env
	@echo "$(YELLOW)⚠️  N'oubliez pas d'éditer le fichier .env !$(NC)"
	$(MAKE) install
	$(MAKE) build

quick-start: ## Démarrage rapide complet
	@echo "$(GREEN)Démarrage rapide...$(NC)"
	$(MAKE) setup
	$(MAKE) start-simple
	@echo "$(GREEN)✅ Application démarrée sur http://localhost:3000$(NC)"
