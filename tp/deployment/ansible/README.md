# 🚀 Infrastructure Ansible Docker - Solution Complète

## 📋 Vue d'ensemble

Cette solution Ansible automatise complètement la préparation d'une infrastructure Docker sécurisée pour le déploiement de l'application TodoList en production. Elle est conçue pour être **idempotente**, **sécurisée** et **prête pour la production**.

## ✨ Fonctionnalités Principales

### 🔧 Installation Automatisée
- ✅ **Docker Engine** + **Docker Compose** (dernières versions stables)
- ✅ **Utilisateur Docker** dédié avec permissions appropriées
- ✅ **Firewall UFW** configuré avec règles de sécurité
- ✅ **Structure de répertoires** organisée pour la production
- ✅ **Scripts utilitaires** de gestion et maintenance
- ✅ **Monitoring tools** (optionnel)

### 🔒 Sécurité Renforcée
- 🛡️ **Firewall** avec règles restrictives (ports 22, 3000, 4000, 80, 443)
- 🔐 **SSH sécurisé** (pas de root, clés uniquement)
- 👤 **Utilisateur non-root** pour Docker
- 🔄 **Mises à jour automatiques** de sécurité
- 🚫 **Fail2ban** (optionnel) contre les attaques

### 📊 Compatibilité
- ✅ **Ubuntu 20.04+** et **Debian 11+**
- ✅ **Architectures** x86_64, ARM64, ARMv7
- ✅ **Idempotence** garantie (exécution multiple sans effet de bord)
- ✅ **Rollback** en cas d'échec

## 🚀 Installation Rapide

### ⚡ Méthode 1 : Script Interactif (Recommandé)

```bash
# Cloner le projet
git clone https://github.com/votre-username/tp-ci-cd.git
cd tp-ci-cd/tp/deployment/ansible

# Installation interactive
./quick-install.sh
```

### 🔧 Méthode 2 : Makefile

```bash
# Configuration automatique
make setup

# Éditez inventory.ini avec vos serveurs
nano inventory.ini

# Test de connectivité
make check

# Déploiement complet
make deploy

# Vérification
make verify
```

### 🛠️ Méthode 3 : Manuel

```bash
# 1. Configuration
cp inventory.ini.example inventory.ini
# Éditez inventory.ini

# 2. Test connectivité
ansible docker_servers -i inventory.ini -m ping

# 3. Déploiement
ansible-playbook -i inventory.ini playbook-infrastructure.yml

# 4. Vérification
ansible docker_servers -i inventory.ini -m command -a "docker --version"
```

## 📁 Structure Créée sur le Serveur

```
/opt/todolist/                 # Répertoire principal
├── config/                    # Configuration application
│   ├── .env                   # Variables d'environnement
│   └── docker-compose.yml     # Composition Docker
├── data/                      # Données persistantes
│   ├── mongodb/               # Base de données
│   ├── nginx/                 # Proxy reverse
│   └── app/                   # Application
├── logs/                      # Logs centralisés
├── backups/                   # Sauvegardes automatiques
│   ├── daily/                 # Sauvegardes quotidiennes
│   ├── weekly/                # Sauvegardes hebdomadaires
│   └── scripts/               # Scripts de sauvegarde
├── scripts/                   # Scripts de gestion
│   ├── deploy.sh              # Déploiement application
│   ├── backup.sh              # Sauvegarde
│   └── maintenance.sh         # Maintenance système
└── monitoring/                # Outils de monitoring (optionnel)
```

## 🎛️ Configuration

### 📊 Variables Principales

```yaml
# Utilisateur et répertoires
docker_user: "deploy"
app_directory: "/opt/todolist"
app_name: "todolist-production"

# Sécurité
firewall_enabled: true
update_system: true
ssh_security_config:
  permit_root_login: false
  password_authentication: false

# Monitoring (optionnel)
monitoring_enabled: false
cadvisor_enabled: false
```

### 🌐 Inventaire

```ini
[docker_servers]
production-server ansible_host=YOUR_IP ansible_user=ubuntu

[docker_servers:vars]
docker_user=deploy
app_directory=/opt/todolist
firewall_enabled=true
monitoring_enabled=false
```

## 🏗️ Architecture des Rôles

### 1. `system-update`
- Mise à jour complète du système
- Installation paquets essentiels
- Configuration fuseau horaire
- Modules Python pour Ansible

### 2. `docker-installation`
- Suppression anciennes versions
- Ajout dépôt officiel Docker
- Installation Docker + Compose
- Configuration daemon
- Tests fonctionnels

### 3. `user-configuration`
- Création utilisateur dédié
- Permissions sudo appropriées
- Ajout au groupe docker
- Configuration SSH et bashrc
- Aliases utiles

### 4. `firewall-security`
- Installation UFW
- Règles de sécurité
- SSH sécurisé
- Fail2ban (optionnel)
- Mises à jour automatiques

### 5. `directory-structure`
- Création structure répertoires
- Scripts utilitaires
- Configuration logs
- Documentation automatique
- Permissions appropriées

### 6. `monitoring-tools` (optionnel)
- Outils système (htop, iotop)
- Monitoring Docker (ctop, dive)
- cAdvisor + Node Exporter
- Scripts personnalisés
- Dashboard simple

## 🔧 Scripts Générés

### `deploy.sh` - Gestion Application
```bash
./deploy.sh start      # Démarrer
./deploy.sh stop       # Arrêter
./deploy.sh restart    # Redémarrer
./deploy.sh status     # Statut
./deploy.sh logs       # Logs
./deploy.sh update     # Mise à jour
./deploy.sh backup     # Sauvegarde
```

### `maintenance.sh` - Maintenance Système
```bash
./maintenance.sh cleanup  # Nettoyage Docker
./maintenance.sh logs     # Rotation logs
./maintenance.sh disk     # Espace disque
./maintenance.sh health   # Santé conteneurs
./maintenance.sh all      # Maintenance complète
```

### `backup.sh` - Sauvegarde Automatique
```bash
./backup.sh              # Sauvegarde complète
# - MongoDB (mongodump)
# - Configurations
# - Logs récents
# - Nettoyage automatique (7 jours)
```

## 🎯 Commandes Utiles

### 📋 Déploiement
```bash
# Déploiement complet
make deploy

# Simulation
make deploy-check

# Tags spécifiques
make deploy-tags TAGS=docker,security

# Production sécurisée
make production
```

### 🔍 Vérification
```bash
# Test connectivité
make check

# Vérification post-installation
make verify

# Statut des services
make status
```

### 🎛️ Modules Spécifiques
```bash
# Docker uniquement
make docker

# Sécurité uniquement
make security

# Monitoring
make monitoring
```

## ✅ Vérifications Post-Installation

### 🐳 Docker
```bash
# Version et fonctionnement
ssh deploy@SERVER "docker --version"
ssh deploy@SERVER "docker compose version"
ssh deploy@SERVER "docker ps"
```

### 🔥 Firewall
```bash
# Statut UFW
ssh deploy@SERVER "sudo ufw status verbose"

# Ports ouverts
ssh deploy@SERVER "netstat -tlnp"
```

### 📁 Structure
```bash
# Répertoires créés
ssh deploy@SERVER "tree /opt/todolist"

# Scripts disponibles
ssh deploy@SERVER "ls -la /opt/todolist/scripts/"
```

## 🔧 Personnalisation

### 🎛️ Variables Configurables
```yaml
# infrastructure.yml
docker_user: "myuser"           # Utilisateur personnalisé
app_directory: "/app/custom"    # Répertoire personnalisé
timezone: "America/New_York"    # Fuseau horaire

# security.yml
firewall_enabled: false        # Désactiver firewall
fail2ban_enabled: true         # Activer fail2ban
monitoring_enabled: true       # Activer monitoring
```

### 🌐 Multi-environnements
```bash
# Inventaires séparés
make deploy INVENTORY=production.ini
make deploy INVENTORY=staging.ini
make deploy INVENTORY=development.ini
```

## 🚨 Dépannage

### ❗ Problèmes Courants

#### Permissions Docker
```bash
# Reconnexion nécessaire après installation
ssh deploy@SERVER
docker ps  # Devrait fonctionner
```

#### Firewall bloque
```bash
# Vérifier règles
sudo ufw status verbose

# Autoriser temporairement
sudo ufw allow from YOUR_IP
```

#### Espace disque
```bash
# Nettoyage
./scripts/maintenance.sh cleanup

# Vérification
df -h
```

## 📊 Monitoring et Supervision

### 🔍 Outils Installés
- **htop** : Monitoring système
- **iotop** : Monitoring I/O
- **ctop** : Monitoring containers
- **dive** : Analyse images Docker

### 📈 Monitoring Avancé (optionnel)
- **cAdvisor** : http://localhost:8080
- **Node Exporter** : http://localhost:9100
- **Prometheus** compatible

## 🔄 Maintenance

### 📅 Tâches Automatiques
- Rotation des logs (logrotate)
- Mises à jour sécurité (unattended-upgrades)
- Nettoyage Docker (scripts)
- Sauvegardes (cron optionnel)

### 🛠️ Maintenance Manuelle
```bash
# Maintenance complète
ssh deploy@SERVER "/opt/todolist/scripts/maintenance.sh all"

# Mise à jour infrastructure
ansible-playbook -i inventory.ini playbook-infrastructure.yml
```

## 📚 Documentation

- **README-INFRASTRUCTURE.md** : Guide détaillé
- **vars/infrastructure.yml** : Variables documentées
- **vars/security.yml** : Configuration sécurité
- **Makefile** : Commandes disponibles

## 🤝 Support

### 🐛 Signaler un Bug
1. Vérifiez les logs : `make logs`
2. Testez en mode check : `make deploy-check`
3. Vérifiez la compatibilité OS
4. Ouvrez une issue GitHub

### 💡 Contribuer
1. Fork du projet
2. Branche feature : `git checkout -b feature/improvement`
3. Tests sur Ubuntu/Debian
4. Pull request avec description

---

## 🎉 Résultat Final

Après exécution, vous obtenez :

✅ **Serveur Docker** prêt pour la production  
✅ **Infrastructure sécurisée** avec firewall  
✅ **Utilisateur dédié** avec permissions appropriées  
✅ **Structure organisée** pour l'application  
✅ **Scripts de gestion** automatiques  
✅ **Monitoring** et supervision  
✅ **Documentation** complète  

**🚀 Votre infrastructure est prête pour déployer l'application TodoList ! 🚀**

---

<div align="center">

**Made with ❤️ for Production Docker Infrastructure**

</div>
