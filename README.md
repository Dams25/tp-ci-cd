# 🚀 TodoList Production - CI/CD avec Docker & Ansible
### 🔧 Fonctionnalités DevOps avancées

Notre solution Ansible robuste et modulaire offre :

#### 🚀 **Déploiement intelligent**
- 🔄 **Zero-downtime deployment** avec stratégies Blue-Green et Rolling
- 🔙 **Rollback automatique** en cas d'échec avec validation de santé
- 📊 **Health checks avancés** avec tests fonctionnels post-déploiement
- 🎯 **Déploiement modulaire** avec 7 rôles Ansible spécialisés

#### 🔐 **Sécurité & Secrets**
- 🔒 **Gestion des secrets** avec Ansible Vault intégré
- 🛡️ **Transfert sécurisé** des fichiers avec validation d'intégrité
- 👤 **Containers non-root** pour sécurité renforcée
- 🔑 **Authentification par clés SSH** pour les connexions serveur

#### 📊 **Monitoring & Observabilité**
- 🏥 **Health checks multi-niveaux** (infrastructure, application, services)
- 📈 **Monitoring intégré** (Prometheus/Grafana ready)
- 🚨 **Notifications automatiques** (Slack/Email/Discord)
- 📝 **Rapports détaillés** de déploiement avec métriques

#### 🔄 **CI/CD & Automatisation**
- 🐳 **Build Docker optimisé** avec multi-stage et cache intelligent
- 💾 **Sauvegarde automatique** avant chaque déploiement
- 🧹 **Nettoyage automatique** des anciennes images et logs
- 🎮 **Interface Makefile** pour simplifier toutes les opérations
- ✅ **Validation automatique** de la solution avec script intégrés://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Express.js](https://img.shields.io/badge/Express.js-404D59?style=for-the-badge&logo=express&logoColor=white)](https://expressjs.com/)
[![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)

> **Application TodoList moderne et scalable** avec orchestration Docker Compose robuste, déploiement automatisé Ansible et CI/CD prêt pour la production.

## 📋 Table des matières

- [🎯 Vue d'ensemble](#-vue-densemble)
- [✨ Fonctionnalités](#-fonctionnalités)
- [🏗️ Architecture & Structure](#️-architecture--structure)
- [🚀 Démarrage rapide](#-démarrage-rapide)
- [🔧 Configuration](#-configuration)
- [📦 Déploiement & Ansible](#-déploiement--ansible)
- [🏃‍♂️ Développement](#️-développement)
- [📊 Monitoring & Santé](#-monitoring--santé)
- [🧪 Tests](#-tests)
- [📚 Documentation centralisée](#-documentation-centralisée)
- [🤝 Contribution](#-contribution)

## 🎯 Vue d'ensemble

Cette application TodoList est conçue pour démontrer les meilleures pratiques DevOps modernes avec :

- **Architecture microservices** conteneurisée
- **CI/CD pipeline** automatisé
- **Déploiement infrastructure as code** avec Ansible
- **Monitoring et observabilité** intégrés
- **Sécurité renforcée** et bonnes pratiques

### 🛠️ Stack technologique

| Composant | Technologie | Version |
|-----------|-------------|---------|
| **Runtime** | Node.js | 20-alpine |
| **Framework** | Express.js | Latest |
| **Base de données** | MongoDB | 7-jammy |
| **Proxy** | Nginx | Alpine |
| **Orchestration** | Docker Compose | Latest |
| **Automatisation** | Ansible | Latest |
| **OS** | Linux Alpine | Latest |

## ✨ Fonctionnalités

### 🎯 Fonctionnalités applicatives
- ✅ **CRUD complet** pour les tâches
- ✅ **Interface web responsive** (EJS templates)
- ✅ **Gestion des utilisateurs** et authentification
- ✅ **Dashboard** avec statistiques
- ✅ **API REST** complète
- ✅ **Health checks** intégrés

### 🔧 Fonctionnalités DevOps
- 🐳 **Docker multi-stage** optimisé (<200MB)
- 🌐 **Docker Compose** production-ready
- 📊 **Health checks** automatiques
- 🔄 **Restart policies** intelligentes
- 📝 **Logging centralisé** avec rotation
- 🔒 **Sécurité renforcée** (non-root, secrets)
- 🚀 **Déploiement Ansible** complet et robuste
- 🔄 **Zero-downtime deployment** (Blue-Green, Rolling)
- 🔙 **Rollback automatique** en cas d'échec
- 🏥 **Health checks** avancés avec tests fonctionnels
- � **Sauvegarde automatique** avant déploiement
- 🔐 **Gestion des secrets** avec Ansible Vault
- �📈 **Monitoring** intégré (Prometheus/Grafana)
- 🚨 **Notifications** automatiques (Slack/Email)
- 📊 **Rapports** détaillés de déploiement

## 🏗️ Architecture & Structure

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│      Nginx      │────│   TodoList App  │────│    MongoDB      │
│   (Proxy/LB)    │    │   (Node.js)     │    │  (Database)     │
│   Port: 80      │    │   Port: 3000    │    │   Port: 27017   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Docker Host   │
                    │   (Production)  │
                    └─────────────────┘
```

### 🔗 Composants

- **🌐 Nginx** : Proxy inverse, load balancer, SSL termination
- **⚡ App Node.js** : API REST + Interface web
- **🗄️ MongoDB** : Base de données NoSQL avec persistance
- **📊 Health Checks** : Monitoring automatique de santé
- **📝 Logs** : Centralisation avec rotation automatique

### 📁 Structure complète du projet

```
todolist-production/
├── 📂 tp/                           # 🎯 Code source de l'application
│   ├── 📁 assets/                   # Assets statiques (CSS, JS)
│   ├── 📁 config/                   # Configuration (MongoDB, etc.)
│   ├── 📁 controllers/              # Contrôleurs métier
│   ├── 📁 models/                   # Modèles de données
│   ├── 📁 routes/                   # Routes Express
│   ├── 📁 views/                    # Templates EJS
│   ├── 📁 tests/                    # Tests unitaires et d'intégration
│   ├── 📄 app.js                    # Configuration Express
│   ├── 📄 index.js                  # Point d'entrée principal
│   └── 📄 package.json              # Dépendances Node.js
├── 📂 deployment/                   # 🚀 Configuration de déploiement
│   ├── 📁 docker/                   # Orchestration Docker
│   │   ├── 📄 Dockerfile            # Image multi-stage optimisée
│   │   ├── 📄 docker-compose.yml    # Production complète
│   │   └── 📄 docker-compose-simple.yml # Version debug
│   └── 📁 ansible/                  # 🎯 Solution Ansible COMPLÈTE
│       ├── 📄 playbook-deploy.yml   # Playbook principal de déploiement
│       ├── 📁 roles/                # Rôles Ansible modulaires
│       │   └── 📁 deployment/       # 🛠️ Rôles de déploiement avancés
│       │       ├── pre-deployment/  # ✅ Validation & sauvegarde
│       │       ├── file-transfer/   # 📤 Transfert sécurisé des fichiers
│       │       ├── secrets-management/ # 🔐 Gestion des secrets (Vault)
│       │       ├── docker-build/    # 🐳 Build Docker optimisé
│       │       ├── service-deployment/ # 🚀 Déploiement zero-downtime
│       │       ├── health-checks/   # 🏥 Tests de santé complets
│       │       ├── post-deployment/ # 🧹 Nettoyage & monitoring
│       │       ├── handlers/        # ⚡ Handlers avancés (restart, rollback)
│       │       └── templates/       # 📝 Templates Jinja2
│       ├── 📁 vars/                 # 🔧 Variables de configuration
│       ├── 📄 Makefile              # 🎮 Interface de commandes
│       ├── 📄 validate-solution.sh  # ✅ Script de validation
│       ├── 📄 GUIDE-DEPLOIEMENT.md # 📖 Guide complet de déploiement
│       └── 📄 README-INFRASTRUCTURE.md # 📚 Documentation infrastructure
├── 📂 scripts/                      # 🛠️ Scripts utilitaires
├── 📂 docs/                         # 📚 Documentation
└── 📄 README.md                     # 📋 Documentation principale (ce fichier)
```

## 🚀 Démarrage rapide

### 📋 Prérequis

```bash
# Vérifier les dépendances
docker --version          # >= 20.10
docker-compose --version  # >= 2.0
git --version             # >= 2.0
```

### ⚡ Installation en 3 étapes

```bash
# 1️⃣ Cloner le projet
git clone https://github.com/votre-username/tp-ci-cd.git
cd tp-ci-cd

# 2️⃣ Lancement du guide interactif (recommandé)
chmod +x start.sh
./start.sh

# 3️⃣ Ou installation manuelle rapide
cd tp && make start-simple
```

### 🎯 Installation manuelle

```bash
# Configuration
cp .env.example .env
# ⚠️ IMPORTANT: Éditez .env avec vos valeurs !
# Le fichier .env principal se trouve aussi dans deployment/docker/

# Installation
make install
make build

# Démarrage
make start-simple
# Ou pour Windows: .\manage.sh start-simple
```

### 🎯 Vérification

```bash
# Statut des services
make status
# Ou pour Windows: .\manage.sh status

# Tests de fonctionnement
curl http://localhost:3000/health
curl http://localhost:3000/

# Aide complète
make help
# Ou pour Windows: .\manage.sh help
```

**✅ Résultat attendu :**
```json
{
  "status": "OK",
  "database": "connected",
  "uptime": 25.2
}
```

## 🔧 Configuration

### 🔐 Variables d'environnement critiques

| Variable | Description | Exemple | Obligatoire |
|----------|-------------|---------|-------------|
| `SESSION_SECRET` | Clé de session (32+ chars) | `your-super-secret-key-32-chars-min` | ✅ |
| `MONGO_INITDB_ROOT_PASSWORD` | Mot de passe MongoDB | `SecurePass123!` | ✅ |
| `NODE_ENV` | Environnement | `production` | ✅ |
| `PORT` | Port de l'application | `3000` | ❌ |

### 📁 Structure des fichiers

```
todolist-production/
├── � src/                          # Code source de l'application
│   ├── 📁 assets/                   # Assets statiques (CSS, JS)
│   ├── 📁 config/                   # Configuration (MongoDB, etc.)
│   ├── 📁 controllers/              # Contrôleurs métier
│   ├── � models/                   # Modèles de données
│   ├── 📁 routes/                   # Routes Express
│   ├── 📁 views/                    # Templates EJS
│   ├── 📁 tests/                    # Tests unitaires et d'intégration
│   ├── 📄 app.js                    # Configuration Express
│   ├── 📄 index.js                  # Point d'entrée principal
│   └── 📄 package.json              # Dépendances Node.js
├── 📂 deployment/                   # Configuration de déploiement
│   ├── � docker/                   # Orchestration Docker
│   │   ├── 📄 Dockerfile            # Image multi-stage optimisée
│   │   ├── 📄 docker-compose.yml    # Production complète
│   │   └── � docker-compose-simple.yml # Version debug
│   └── 📁 ansible/                  # Déploiement automatisé
│       ├── 📄 ansible-deploy.yml    # Playbook principal
│       └── 📁 roles/                # Rôles Ansible
├── 📂 scripts/                      # Scripts utilitaires
│   ├── 📄 install.sh                # Installation automatique
│   └── 📄 manage-docker.sh          # Gestion Docker
├── 📂 docs/                         # Documentation
│   ├── � README-QUICK-START.md     # Guide de démarrage
│   └── � DOCKER-COMPOSE-PRODUCTION.md # Documentation avancée
├── � Makefile                      # Commandes simplifiées
├── 📄 .env.example                  # Template de configuration
└── � README.md                     # Documentation principale
```

## 📦 Déploiement & Ansible

### 🏠 Déploiement local (développement)

```bash
# Version simple (développement/debug)
cd tp
make start-simple

# Version complète (production locale)
make start

# Avec Docker Compose directement
cd deployment/docker
docker-compose up -d
```

### 🌐 Déploiement serveur avec Ansible - Solution complète

> **🎯 Notre solution Ansible est une plateforme de déploiement robuste, modulaire et prête pour la production !**

#### ⚡ Déploiement rapide

```bash
# 1️⃣ Configuration rapide (une seule fois)
cd deployment/ansible
cp vars/deploy.yml.example vars/deploy.yml  # Éditez vos variables
cp inventory.ini.example inventory.ini      # Configurez vos serveurs

# 2️⃣ Déploiement automatisé complet
make deploy
# 🎯 Cette commande lance le déploiement zero-downtime avec rollback automatique !
```

#### 🛠️ Interface Makefile complète

```bash
# 📋 Voir toutes les commandes disponibles
make help

# 🚀 Opérations de déploiement
make deploy              # Déploiement complet
make deploy-check        # Déploiement avec vérifications étendues
make rollback           # Rollback vers la version précédente
make health-check       # Vérification de santé complète

# 💾 Gestion des sauvegardes
make backup             # Sauvegarde manuelle
make restore            # Restauration depuis sauvegarde
make list-backups       # Liste des sauvegardes disponibles

# 🔧 Maintenance et monitoring
make update-config      # Mise à jour de la configuration
make restart-services   # Redémarrage des services
make clean-old-images   # Nettoyage des anciennes images
make logs              # Consultation des logs centralisés

# ✅ Validation et tests
make validate-solution  # Validation complète de la solution
make test-deployment   # Tests post-déploiement
make security-scan     # Scan de sécurité
```

#### 📚 Guides de déploiement détaillés

| Guide | Description | Lien |
|-------|-------------|------|
| **Guide principal** | Documentation complète de déploiement | [`deployment/ansible/GUIDE-DEPLOIEMENT.md`](deployment/ansible/GUIDE-DEPLOIEMENT.md) |
| **Infrastructure** | Configuration serveurs et prérequis | [`deployment/ansible/README-INFRASTRUCTURE.md`](deployment/ansible/README-INFRASTRUCTURE.md) |
| **Validation** | Script de validation automatique | [`deployment/ansible/validate-solution.sh`](deployment/ansible/validate-solution.sh) |

### ☁️ Déploiement cloud

Le projet est compatible avec :
- 🐳 **Docker Swarm** (orchestration native)
- ☸️ **Kubernetes** (avec adaptations des manifests)
- 🔄 **CI/CD pipelines** (GitHub Actions, GitLab CI, Jenkins)
- ☁️ **Cloud providers** (AWS, Azure, GCP)

## 🏃‍♂️ Développement

### 🛠️ Commandes de développement

```bash
# Gestion avec Makefile (recommandé)
make start              # Démarrer l'application
make stop               # Arrêter l'application  
make status             # Vérifier l'état
make logs               # Voir les logs
make clean              # Nettoyer
make help               # Voir toutes les commandes

# Gestion avec scripts
scripts/manage-docker.sh start     # Démarrer
scripts/manage-docker.sh status    # Statut détaillé
scripts/manage-docker.sh backup    # Sauvegarder

# Développement
make dev                # Mode développement
make test               # Lancer les tests
make lint               # Vérifier le code
```

### 🧪 Mode développement

```bash
# Démarrage avec volumes montés
docker-compose -f docker-compose.dev.yml up -d

# Hot reload activé
npm run dev
```

## 📊 Monitoring & Santé

### 🔍 Health checks

| Endpoint | Description | Réponse |
|----------|-------------|---------|
| `GET /health` | État détaillé | JSON avec métriques |
| `GET /` | État de base | Endpoints disponibles |

### 📈 Métriques disponibles

- ✅ **Statut application** (OK/DEGRADED/ERROR)
- ✅ **Connexion MongoDB** (connected/disconnected)
- ✅ **Utilisation mémoire** (RSS, Heap, External)
- ✅ **Uptime** du processus
- ✅ **PID** et version

### 📝 Logs centralisés

```bash
# Voir tous les logs
docker-compose logs -f

# Logs spécifiques
docker-compose logs -f todolist-app
docker-compose logs -f mongodb

# Avec Ansible (via Makefile)
cd deployment/ansible
make logs
```

### 🚨 Monitoring avancé avec Ansible

```bash
# Surveillance complète des services
make health-check

# Rapports de santé détaillés
make generate-health-report

# Monitoring en temps réel
make monitor-services
```

## 🧪 Tests

### 🔬 Tests automatisés

```bash
# Tests unitaires
npm test

# Tests d'intégration
npm run test:integration

# Coverage
npm run test:coverage
```

### 🎯 Tests manuels

```bash
# Test des endpoints
curl -X GET http://localhost:3000/health
curl -X GET http://localhost:3000/tasks
curl -X POST http://localhost:3000/tasks -H "Content-Type: application/json" -d '{"title":"Test task"}'

# Tests avec Ansible
cd deployment/ansible
make test-deployment     # Tests post-déploiement automatisés
make validate-solution   # Validation complète de la solution
```

## 📚 Documentation centralisée

### 📖 Guides principaux

| Document | Description | Localisation |
|----------|-------------|--------------|
| **📚 Hub documentation** | Index central de toute la documentation | [`docs/README.md`](docs/README.md) |
| **README.md** | Documentation principale (ce fichier) | Racine du projet |
| **CHANGELOG.md** | Historique des versions et évolutions | [`CHANGELOG.md`](CHANGELOG.md) |
| **Guide de déploiement** | Instructions complètes Ansible | [`deployment/ansible/GUIDE-DEPLOIEMENT.md`](deployment/ansible/GUIDE-DEPLOIEMENT.md) |
| **Documentation infrastructure** | Configuration serveurs et prérequis | [`deployment/ansible/README-INFRASTRUCTURE.md`](deployment/ansible/README-INFRASTRUCTURE.md) |

### 🛠️ Scripts et utilitaires

| Script | Description | Utilisation |
|--------|-------------|-------------|
| **start.sh** | 🎯 Guide interactif de démarrage | `./start.sh` |
| **Makefile Ansible** | Interface complète de déploiement | `cd deployment/ansible && make help` |
| **Script de validation** | Validation automatique de la solution | `./deployment/ansible/validate-solution.sh` |
| **Guides d'installation** | Scripts d'installation automatique | `./scripts/install.sh` |

### 🎯 Ressources avancées

- **📊 Monitoring** : Health checks multi-niveaux et rapports de santé
- **🔐 Sécurité** : Gestion des secrets avec Ansible Vault
- **🚀 CI/CD** : Déploiement zero-downtime et rollback automatique
- **📈 Performance** : Optimisations Docker et monitoring des ressources
- **🔄 Maintenance** : Sauvegarde, restauration et nettoyage automatisés

> **💡 Conseil** : Commencez par le [Guide de déploiement](deployment/ansible/GUIDE-DEPLOIEMENT.md) pour un aperçu complet de toutes les fonctionnalités disponibles !

## 🤝 Contribution

### 🌟 Comment contribuer

1. **Fork** le projet
2. **Créer** une branche feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** sur la branche (`git push origin feature/AmazingFeature`)
5. **Ouvrir** une Pull Request

### 📋 Guidelines

- ✅ **Tests** obligatoires pour toute nouvelle fonctionnalité
- ✅ **Documentation** mise à jour
- ✅ **Code style** respecté (ESLint)
- ✅ **Sécurité** vérifiée

## 📜 License

Ce projet est sous licence **MIT** - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Auteurs

- **Sebastian Onise** - *Développement initial* - [@Ctrix;)](https://github.com/SO-Ctrix)

## 🙏 Remerciements

- Express.js pour le framework web
- MongoDB pour la base de données
- Docker pour la conteneurisation
- Ansible pour l'automatisation
- La communauté open-source

---

<div align="center">

**⭐ Si ce projet vous a aidé, n'hésitez pas à lui donner une étoile ! ⭐**

Made with ❤️ and ☕ by [Sebastian ONISE](https://github.com/SO-Ctrix)

</div>