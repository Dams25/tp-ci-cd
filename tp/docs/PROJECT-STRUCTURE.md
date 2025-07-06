# 📁 Structure du Projet TodoList Production

## 🏗️ Vue d'ensemble

```
todolist-production/
├── 📂 src/                          # Code source de l'application
│   ├── 📁 assets/                   # Assets statiques (CSS, JS)
│   ├── 📁 config/                   # Configuration (MongoDB, etc.)
│   ├── 📁 controllers/              # Contrôleurs métier
│   ├── 📁 models/                   # Modèles de données
│   ├── 📁 routes/                   # Routes Express
│   ├── 📁 views/                    # Templates EJS
│   ├── 📁 tests/                    # Tests unitaires et d'intégration
│   ├── 📄 app.js                    # Configuration Express
│   ├── 📄 index.js                  # Point d'entrée principal
│   ├── 📄 package.json              # Dépendances Node.js
│   └── 📄 jest.config.js            # Configuration des tests
├── 📂 deployment/                   # Configuration de déploiement
│   ├── 📁 docker/                   # Configuration Docker
│   │   ├── 📄 Dockerfile            # Image Docker multi-stage
│   │   ├── 📄 .dockerignore         # Exclusions Docker
│   │   ├── 📄 docker-compose.yml    # Production complète
│   │   ├── 📄 docker-compose-simple.yml # Version simplifiée
│   │   ├── 📄 mongo-init.js         # Script d'initialisation MongoDB
│   │   └── 📁 nginx/                # Configuration Nginx
│   │       └── 📄 nginx.conf        # Proxy reverse
│   └── 📁 ansible/                  # Déploiement automatisé
│       ├── 📄 ansible-deploy.yml    # Playbook principal
│       ├── 📄 inventory.ini         # Inventaire des serveurs
│       ├── 📁 roles/                # Rôles Ansible
│       └── 📁 vars/                 # Variables de configuration
├── 📂 scripts/                      # Scripts utilitaires
│   ├── 📄 manage-docker.sh          # Gestion Docker
│   └── 📄 build-docker.sh           # Build automatisé
├── 📂 docs/                         # Documentation
│   ├── 📄 README-QUICK-START.md     # Guide de démarrage rapide
│   ├── 📄 DOCKER-COMPOSE-PRODUCTION.md # Doc Docker avancée
│   └── 📄 DOCKER-TESTS.md           # Guide de tests
├── 📄 .env                          # Variables d'environnement
├── 📄 .env.example                  # Template de configuration
├── 📄 .gitignore                    # Exclusions Git
└── 📄 README.md                     # Documentation principale
```

## 🎯 Principes d'organisation

### 📂 **src/** - Code Source
- **Organisation modulaire** par responsabilité
- **Séparation des préoccupations** (MVC pattern)
- **Tests co-localisés** avec le code métier
- **Configuration centralisée**

### 📂 **deployment/** - Déploiement
- **Docker** : Conteneurisation et orchestration
- **Ansible** : Automatisation et infrastructure as code
- **Séparation environnements** (dev/staging/prod)

### 📂 **scripts/** - Automatisation
- **Scripts de gestion** réutilisables
- **Outils de développement** et de maintenance
- **Automatisation des tâches** répétitives

### 📂 **docs/** - Documentation
- **Guides utilisateur** et développeur
- **Documentation technique** détaillée
- **Exemples** et tutoriels

## 🔄 Flux de développement

```
1. Code Source (src/) 
   ↓
2. Tests (src/tests/)
   ↓  
3. Build Docker (deployment/docker/)
   ↓
4. Déploiement local (scripts/)
   ↓
5. Déploiement automatisé (deployment/ansible/)
```

## 🚀 Avantages de cette structure

- ✅ **Séparation claire** des responsabilités
- ✅ **Scalabilité** pour les grandes équipes
- ✅ **Maintenance facilitée**
- ✅ **Documentation centralisée**
- ✅ **Déploiement reproductible**
- ✅ **Standards industriels** respectés

Cette structure suit les meilleures pratiques DevOps et permet une collaboration efficace en équipe.
