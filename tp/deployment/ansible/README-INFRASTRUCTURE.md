# 🚀 Guide d'Infrastructure Ansible - Production Docker

## 📋 Vue d'ensemble

Ce playbook Ansible configure automatiquement une infrastructure Docker complète pour le déploiement de l'application TodoList en production. Il installe et configure tous les composants nécessaires de manière sécurisée et idempotente.

## 🎯 Fonctionnalités

### ✅ Installation et Configuration
- **Docker Engine** dernière version stable + Docker Compose
- **Utilisateur dédié** avec permissions Docker appropriées
- **Firewall UFW** configuré avec règles de sécurité
- **Structure de répertoires** organisée pour la production
- **Scripts utilitaires** pour la gestion et maintenance
- **Monitoring tools** (optionnel) pour supervision

### 🔒 Sécurité Intégrée
- Firewall configuré (ports 22, 3000, 4000, 80, 443)
- SSH sécurisé (désactivation root, clés uniquement)
- Utilisateur non-root pour Docker
- Mises à jour automatiques de sécurité
- Fail2ban (optionnel) contre les attaques

### 📁 Structure Créée
```
/opt/todolist/
├── config/           # Configuration application
├── data/            # Données persistantes
│   ├── mongodb/     # Données MongoDB  
│   ├── nginx/       # Configuration Nginx
│   └── app/         # Données application
├── logs/            # Logs centralisés
├── backups/         # Sauvegardes automatiques
├── scripts/         # Scripts de gestion
│   ├── deploy.sh    # Déploiement
│   ├── backup.sh    # Sauvegarde
│   └── maintenance.sh # Maintenance
└── monitoring/      # Outils de monitoring
```

## 🚀 Installation et Utilisation

### 📋 Prérequis

```bash
# Sur votre machine de contrôle
sudo apt update && sudo apt install ansible
pip3 install ansible

# Vérification
ansible --version  # >= 2.9
```

### ⚡ Déploiement Rapide

```bash
# 1️⃣ Configuration de l'inventaire
cp inventory.ini.example inventory.ini
# Éditez inventory.ini avec vos serveurs

# 2️⃣ Test de connectivité
ansible docker_servers -i inventory.ini -m ping

# 3️⃣ Déploiement infrastructure complète
ansible-playbook -i inventory.ini playbook-infrastructure.yml

# 4️⃣ Vérification
ansible docker_servers -i inventory.ini -m command -a "docker --version"
```

### 🔧 Commandes Détaillées

#### Test et Vérification
```bash
# Test de connectivité
ansible docker_servers -i inventory.ini -m ping

# Vérification système
ansible docker_servers -i inventory.ini -m setup | grep ansible_distribution

# Mode simulation (--check)
ansible-playbook -i inventory.ini playbook-infrastructure.yml --check

# Exécution avec tags spécifiques
ansible-playbook -i inventory.ini playbook-infrastructure.yml --tags "docker,security"
```

#### Variables Personnalisées
```bash
# Utilisateur personnalisé
ansible-playbook -i inventory.ini playbook-infrastructure.yml \
  -e "docker_user=myuser"

# Répertoire personnalisé
ansible-playbook -i inventory.ini playbook-infrastructure.yml \
  -e "app_directory=/app/todolist"

# Désactiver firewall
ansible-playbook -i inventory.ini playbook-infrastructure.yml \
  -e "firewall_enabled=false"

# Activer monitoring
ansible-playbook -i inventory.ini playbook-infrastructure.yml \
  -e "monitoring_enabled=true"
```

## ⚙️ Configuration

### 🎛️ Variables Principales

#### infrastructure.yml
```yaml
# Utilisateur Docker
docker_user: "deploy"                    # Utilisateur dédié
docker_group: "docker"                   # Groupe Docker

# Répertoires
app_directory: "/opt/todolist"           # Répertoire principal
app_name: "todolist-production"          # Nom de l'application

# Système
update_system: true                      # Mise à jour système
timezone: "Europe/Paris"                 # Fuseau horaire
```

#### security.yml
```yaml
# Firewall
firewall_enabled: true                  # Activation firewall
allowed_ports:                          # Ports autorisés
  - port: 22                            # SSH
  - port: 3000                          # Application
  - port: 80                            # HTTP
  - port: 443                           # HTTPS

# SSH sécurisé
ssh_security_config:
  permit_root_login: false              # Pas de root SSH
  password_authentication: false        # Clés uniquement
```

### 📝 Inventaire

#### Structure de l'inventaire
```ini
[docker_servers]
prod-server    ansible_host=IP_PROD    ansible_user=ubuntu
staging-server ansible_host=IP_STAGING ansible_user=ubuntu

[docker_servers:vars]
docker_user=deploy
app_directory=/opt/todolist
firewall_enabled=true
monitoring_enabled=false
```

## 🏗️ Architecture des Rôles

### 1. system-update
- Mise à jour des paquets système
- Installation outils essentiels
- Configuration fuseau horaire
- Modules Python pour Ansible

### 2. docker-installation  
- Suppression anciennes versions Docker
- Ajout dépôt officiel Docker
- Installation Docker Engine + Compose
- Configuration daemon Docker
- Tests fonctionnels

### 3. user-configuration
- Création utilisateur dédié
- Permissions sudo appropriées
- Ajout au groupe docker
- Configuration SSH et bashrc
- Aliases Docker utiles

### 4. firewall-security
- Installation et configuration UFW
- Règles firewall spécifiques
- Sécurisation SSH
- Fail2ban (optionnel)
- Mises à jour automatiques

### 5. directory-structure
- Création structure répertoires
- Scripts utilitaires
- Configuration logs
- Documentation automatique
- Permissions appropriées

### 6. monitoring-tools (optionnel)
- Outils système (htop, iotop, etc.)
- Monitoring Docker (ctop, dive)
- cAdvisor + Node Exporter
- Scripts de monitoring
- Dashboard simple

## 🔧 Scripts Générés

### deploy.sh
```bash
# Gestion de l'application
./deploy.sh start     # Démarrer
./deploy.sh stop      # Arrêter  
./deploy.sh restart   # Redémarrer
./deploy.sh status    # Statut
./deploy.sh logs      # Logs
./deploy.sh update    # Mise à jour
./deploy.sh backup    # Sauvegarde
```

### maintenance.sh
```bash
# Maintenance système
./maintenance.sh cleanup   # Nettoyage Docker
./maintenance.sh logs      # Rotation logs
./maintenance.sh disk      # Espace disque
./maintenance.sh health    # Santé conteneurs
./maintenance.sh all       # Maintenance complète
```

### backup.sh
```bash
# Sauvegarde automatique
./backup.sh               # Sauvegarde complète
# - Base de données MongoDB
# - Configurations
# - Logs récents
# - Nettoyage automatique
```

## 🔍 Vérifications Post-Installation

### ✅ Tests de Validation

```bash
# 1. Vérification Docker
ssh deploy@YOUR_SERVER "docker --version"
ssh deploy@YOUR_SERVER "docker compose version"

# 2. Test permissions
ssh deploy@YOUR_SERVER "docker ps"

# 3. Vérification firewall
ssh deploy@YOUR_SERVER "sudo ufw status"

# 4. Test structure
ssh deploy@YOUR_SERVER "ls -la /opt/todolist/"

# 5. Test scripts
ssh deploy@YOUR_SERVER "/opt/todolist/scripts/deploy.sh help"
```

### 📊 Monitoring

```bash
# Statut système
ssh deploy@YOUR_SERVER "htop"

# Monitoring Docker
ssh deploy@YOUR_SERVER "ctop"

# Logs système
ssh deploy@YOUR_SERVER "tail -f /var/log/auth.log"
```

## 🚨 Dépannage

### ❗ Problèmes Courants

#### Permissions Docker
```bash
# Si erreur permissions Docker
sudo usermod -aG docker $USER
newgrp docker
# Ou redémarrer session SSH
```

#### Firewall bloque connexion
```bash
# Vérifier règles UFW
sudo ufw status verbose

# Autoriser temporairement
sudo ufw allow from YOUR_IP
```

#### Espace disque insuffisant
```bash
# Nettoyage Docker
docker system prune -a

# Vérification espace
df -h
du -sh /opt/todolist/*
```

## 🔄 Mise à Jour Infrastructure

### 📦 Réexécution Playbook

```bash
# Mise à jour complète
ansible-playbook -i inventory.ini playbook-infrastructure.yml

# Mise à jour Docker uniquement
ansible-playbook -i inventory.ini playbook-infrastructure.yml --tags docker

# Mise à jour sécurité uniquement  
ansible-playbook -i inventory.ini playbook-infrastructure.yml --tags security
```

## 📞 Support et Contribution

### 🐛 Signaler un Bug
1. Vérifiez les logs Ansible
2. Testez en mode `--check`
3. Vérifiez la compatibilité OS
4. Ouvrez une issue avec les détails

### 🤝 Contribuer
1. Fork du projet
2. Branche feature
3. Tests sur Ubuntu/Debian
4. Pull request avec description

---

## 📜 Licence

Ce projet est sous licence MIT - voir [LICENSE](LICENSE) pour les détails.

---

<div align="center">

**🚀 Infrastructure Ansible prête pour la production ! 🚀**

Made with ❤️ pour le déploiement Docker sécurisé

</div>
