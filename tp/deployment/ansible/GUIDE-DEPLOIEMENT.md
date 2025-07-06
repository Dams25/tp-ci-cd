# 🚀 Guide de Déploiement - TODO List Application

## Vue d'ensemble

Ce guide décrit l'utilisation de la solution Ansible complète pour le déploiement automatisé de l'application TODO List Node.js/Express avec MongoDB en production.

## 📋 Prérequis

### Système de contrôle (machine locale)
- Ansible >= 2.9
- Git
- Make
- Python 3.8+
- SSH configuré avec clés

### Serveurs cibles
- Ubuntu/Debian (18.04+)
- Docker et Docker Compose installés
- Utilisateur dédié `todolist` avec sudo
- Structure `/opt/todolist/` créée
- Firewall UFW configuré
- Ports ouverts : 22 (SSH), 80 (HTTP), 443 (HTTPS), 3000 (App)

## 🔧 Configuration Initiale

### 1. Configuration des secrets

```bash
# Créer le fichier de mot de passe vault
echo "votre_mot_de_passe_vault" > .vault_pass
chmod 600 .vault_pass

# Créer/éditer le vault des secrets
make init-vault
# ou
make edit-vault
```

Structure des secrets dans le vault :
```yaml
secrets:
  mongodb:
    username: "admin"
    password: "super_secure_password"
    database: "todolist"
  
  app:
    jwt_secret: "your_jwt_secret_here"
    session_secret: "your_session_secret"
    api_key: "your_api_key"
  
  notifications:
    slack:
      webhook_url: "https://hooks.slack.com/services/..."
    email:
      smtp_password: "email_password"
```

### 2. Configuration de l'inventaire

Éditez `inventory.ini` :
```ini
[production]
server1 ansible_host=192.168.1.100 ansible_user=todolist
server2 ansible_host=192.168.1.101 ansible_user=todolist

[staging]
staging-server ansible_host=192.168.1.200 ansible_user=todolist

[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

### 3. Adaptation des variables

Modifiez `vars/deploy.yml` selon vos besoins :
```yaml
# Version et environnement
app_version: "1.0.0"
app_environment: "production"

# Configuration réseau
deployment:
  app_port: 3000
  strategy: "blue-green"  # ou "rolling" ou "recreate"

# Monitoring
monitoring:
  enabled: true
  prometheus_enabled: true
  grafana_enabled: true

# Notifications
notifications:
  slack:
    enabled: true
    channel: "#deployments"
  email:
    enabled: true
    recipients: ["admin@example.com"]
```

## 🚀 Déploiement

### Commandes principales

```bash
# Afficher l'aide
make help

# Vérifier la configuration
make check-requirements
make syntax-check

# Simulation de déploiement
make dry-run

# Déploiement complet
make deploy APP_VERSION=1.2.3

# Déploiement en staging
make deploy-staging APP_VERSION=1.2.3

# Déploiement en production (avec confirmation)
make deploy-production APP_VERSION=1.2.3
```

### Processus de déploiement

1. **Pré-déploiement** (`pre-deployment`)
   - Vérification de l'état des services
   - Sauvegarde MongoDB et configurations
   - Nettoyage des images obsolètes
   - Validation des prérequis

2. **Transfert** (`file-transfer`)
   - Synchronisation des sources
   - Transfert des configurations
   - Mise à jour des templates

3. **Gestion des secrets** (`secrets-management`)
   - Génération du fichier `.env`
   - Configuration des certificats SSL
   - Gestion des tokens de sécurité

4. **Build Docker** (`docker-build`)
   - Construction de l'image optimisée
   - Tests de sécurité
   - Taggage et versioning

5. **Déploiement** (`service-deployment`)
   - Déploiement selon la stratégie choisie
   - Configuration des services
   - Tests de connectivité

6. **Tests de santé** (`health-checks`)
   - Vérifications système et application
   - Tests fonctionnels complets
   - Tests de charge basiques

7. **Post-déploiement** (`post-deployment`)
   - Nettoyage des ressources
   - Configuration du monitoring
   - Notifications et rapports

## 🔄 Stratégies de déploiement

### Blue-Green
```yaml
deployment:
  strategy: "blue-green"
  blue_port: 3000
  green_port: 3001
```

- Déploiement sans interruption
- Bascule instantanée du trafic
- Rollback immédiat possible

### Rolling Update
```yaml
deployment:
  strategy: "rolling"
  services_order: ["mongo", "app", "nginx"]
  stabilization_time: 30
```

- Mise à jour progressive
- Disponibilité continue
- Validation à chaque étape

### Recreate
```yaml
deployment:
  strategy: "recreate"
  shutdown_timeout: 30
  startup_timeout: 60
```

- Arrêt puis redémarrage complet
- Plus simple mais avec interruption
- Recommandé pour les environnements de test

## 🔙 Rollback

### Rollback manuel
```bash
# Rollback vers une version spécifique
make rollback ROLLBACK_TO=1.2.2

# Rollback d'urgence vers la dernière version stable
make emergency-rollback
```

### Rollback automatique

Le système peut effectuer un rollback automatique en cas de :
- Échec des tests de santé
- Timeouts de déploiement
- Erreurs critiques détectées

Configuration dans `vars/deploy.yml` :
```yaml
rollback:
  auto_rollback: true
  max_attempts: 3
  timeout_minutes: 10
  health_check_retries: 5
```

## 🏥 Monitoring et Santé

### Vérifications de santé
```bash
# Tests de santé complets
make health-check

# Statut actuel
make status

# Logs en temps réel
make logs-follow
```

### Métriques surveillées
- Utilisation CPU/Mémoire/Disque
- Temps de réponse application
- Connectivité base de données
- Disponibilité des services
- Tests fonctionnels automatiques

### Seuils d'alerte par défaut
```yaml
health_checks:
  thresholds:
    cpu_max: 80          # % max CPU
    memory_max: 85       # % max mémoire
    disk_max: 90         # % max disque
    response_time_max: 5 # secondes max
    min_health_score: 80 # score minimum
```

## 💾 Sauvegarde et Restauration

### Sauvegarde manuelle
```bash
# Sauvegarde complète
make backup

# Restauration depuis une date
make restore BACKUP_DATE=2024-01-15
```

### Sauvegarde automatique

Les sauvegardes automatiques incluent :
- Base de données MongoDB (quotidienne à 1h)
- Configurations (.env, docker-compose.yml)
- Logs applicatifs
- Images Docker (optionnel)

### Rétention
- Sauvegardes quotidiennes : 7 jours
- Images Docker : 3 dernières versions
- Logs : 30 jours

## 🔒 Sécurité

### Bonnes pratiques implémentées
- Chiffrement des secrets avec Ansible Vault
- Permissions restrictives sur les fichiers sensibles
- Rotation automatique des secrets (optionnelle)
- Scan de sécurité des images Docker
- Certificats SSL automatisés

### Audit de sécurité
```bash
# Scan de sécurité complet
make security-scan

# Mise à jour des certificats
make update-certificates
```

## 🧪 Tests

### Tests automatisés
```bash
# Tests complets post-déploiement
make test
```

Les tests incluent :
- Tests unitaires (si configurés)
- Tests d'intégration
- Tests fonctionnels API
- Tests de charge basiques
- Validation de la base de données

## 📊 Rapports et Logs

### Localisation des rapports
- **Logs de déploiement** : `logs/deploy-*.log`
- **Rapports de santé** : `logs/health-report-*.txt`
- **Rapports de build** : `logs/build-report-*.txt`
- **Logs applicatifs** : `/opt/todolist/logs/`

### Génération de documentation
```bash
# Génère la documentation technique
make docs
```

## 🚨 Résolution de problèmes

### Échec de déploiement

1. **Vérifier les logs**
   ```bash
   tail -f logs/deploy-latest.log
   ```

2. **Vérifier l'état des services**
   ```bash
   make status
   ```

3. **Tests de connectivité**
   ```bash
   ansible all -i inventory.ini -m ping
   ```

### Problèmes de santé

1. **Diagnostic complet**
   ```bash
   make health-check
   ```

2. **Vérification ressources**
   ```bash
   ansible all -i inventory.ini -m shell -a "df -h && free -h && top -bn1"
   ```

### Rollback d'urgence

En cas de problème critique :
```bash
# Rollback immédiat
make emergency-rollback

# Ou rollback manuel vers version connue
make rollback ROLLBACK_TO=1.2.2
```

## 🔧 Maintenance

### Tâches régulières automatisées
- Nettoyage quotidien (2h00) : images orphelines, logs anciens
- Sauvegarde quotidienne (1h00) : base de données et configs
- Health checks (toutes les 15 min) : vérifications automatiques
- Renouvellement SSL (mensuel) : certificats automatiques

### Commandes de maintenance
```bash
# Nettoyage des ressources
make clean

# Mise à l'échelle
make scale REPLICAS=3

# Arrêt/démarrage
make stop
make start
make restart
```

## 📞 Support et Contact

En cas de problème critique :
1. Consulter les logs de déploiement
2. Vérifier les alertes Slack/Email
3. Contacter l'équipe DevOps
4. Documentation technique : `docs/generated/`

## 🎯 Bonnes Pratiques

### Avant le déploiement
- ✅ Tester en staging
- ✅ Vérifier les secrets
- ✅ Valider la syntaxe
- ✅ Effectuer un dry-run

### Pendant le déploiement
- ✅ Surveiller les logs
- ✅ Vérifier les métriques
- ✅ Valider les tests de santé
- ✅ Confirmer les notifications

### Après le déploiement
- ✅ Tests fonctionnels manuels
- ✅ Vérification monitoring
- ✅ Documentation des changements
- ✅ Communication aux équipes

---

**Version du guide** : 1.0  
**Dernière mise à jour** : {{ ansible_date_time.iso8601 }}  
**Contact** : Équipe DevOps
