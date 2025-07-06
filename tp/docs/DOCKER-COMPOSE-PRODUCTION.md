# 🐳 ORCHESTRATION DOCKER PRODUCTION - TO-DO LIST

## 🎯 Architecture Production

### 🏗️ Composition des Services

```yaml
├── todolist-app (Node.js)     # Application principale sur port 3000
├── mongodb (MongoDB 7)         # Base de données avec persistance
├── nginx (Reverse Proxy)       # Load balancer et SSL termination
└── healthcheck (Monitoring)    # Surveillance continue des services
```

### 🔒 Sécurité Réseau

- **Réseau interne** : `todolist-internal` (App ↔ MongoDB)
- **Réseau externe** : `todolist-external` (Nginx ↔ App)
- **Isolation** : MongoDB non accessible depuis l'extérieur
- **Rate limiting** : Protection anti-DDoS avec Nginx

## 🚀 Déploiement Production

### 1. Préparation
```bash
# Copier les variables d'environnement
cp .env.example .env

# Éditer les valeurs de production
nano .env

# Créer les répertoires de données
mkdir -p data/mongodb
```

### 2. Démarrage
```bash
# Méthode simple
docker-compose up -d

# Méthode avec script de gestion
chmod +x manage-docker.sh
./manage-docker.sh start
```

### 3. Vérification
```bash
# Vérifier les services
./manage-docker.sh status

# Consulter les logs
./manage-docker.sh logs

# Test de l'application
curl http://localhost:3000/health
```

## 📊 Monitoring et Healthchecks

### Services intégrés
- **Application** : `GET /health` - Vérification complète
- **MongoDB** : `mongosh ping` - Test de connectivité DB
- **Nginx** : `curl localhost:80` - Proxy fonctionnel

### Métriques disponibles
```json
{
  "status": "OK",
  "timestamp": "2025-01-06T10:30:00Z",
  "uptime": 3600,
  "environment": "production",
  "database": "connected",
  "memory": {...},
  "pid": 1
}
```

## 🔧 Gestion des Variables

### Variables critiques (.env)
```bash
# Application
NODE_ENV=production
APP_PORT=3000
SESSION_SECRET=your-super-secret-32chars-min

# Base de données
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=SecurePassword123!
MONGO_INITDB_DATABASE=todolist

# Nginx
NGINX_HTTP_PORT=80
NGINX_HTTPS_PORT=443
```

### Sécurité des secrets
- ✅ Fichier `.env` avec permissions 600
- ✅ Secrets non commités dans Git
- ✅ Rotation périodique des mots de passe
- ✅ Chiffrement des variables sensibles avec Ansible Vault

## 🔄 Restart Policies

```yaml
restart: unless-stopped
```
- **Redémarrage automatique** en cas de crash
- **Persistance** après reboot du serveur
- **Arrêt manuel** respecté (pas de redémarrage forcé)

## 💾 Persistance des Données

### Volumes MongoDB
```yaml
volumes:
  mongodb-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ./data/mongodb
```

### Stratégie de sauvegarde
```bash
# Sauvegarde automatique
./manage-docker.sh backup

# Restauration
./manage-docker.sh restore backup-file.gz

# Sauvegarde programmée (cron)
0 2 * * * /opt/todolist/manage-docker.sh backup
```

## 📋 Commandes d'Usage

### Gestion quotidienne
```bash
# Démarrage
./manage-docker.sh start

# Arrêt propre
./manage-docker.sh stop

# Redémarrage
./manage-docker.sh restart

# Logs en temps réel
./manage-docker.sh logs

# Statut complet
./manage-docker.sh status
```

### Maintenance
```bash
# Sauvegarde DB
./manage-docker.sh backup

# Nettoyage complet
./manage-docker.sh cleanup

# Logs d'un service spécifique
./manage-docker.sh logs todolist-app
```

## 🏭 Intégration Ansible

### Playbook de déploiement
```yaml
- name: Déployer TO-DO List
  include: ansible-deploy.yml
  vars:
    environment: production
    backup_before_deploy: true
```

### Variables Ansible requises
```yaml
# Dans group_vars/production.yml
vault_mongodb_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256;...

vault_session_secret: !vault |
  $ANSIBLE_VAULT;1.1;AES256;...
```

### Déploiement automatisé
```bash
# Déploiement complet
ansible-playbook -i inventory ansible-deploy.yml --ask-vault-pass

# Déploiement avec tags
ansible-playbook -i inventory ansible-deploy.yml --tags "deploy" --ask-vault-pass
```

## ⚡ Performance et Optimisations

### Limites de ressources
```yaml
deploy:
  resources:
    limits:
      cpus: '1.0'
      memory: 512M
    reservations:
      cpus: '0.5'
      memory: 256M
```

### Cache et compression
- **Nginx** : Compression gzip activée
- **Static files** : Cache 1 an
- **API calls** : Rate limiting 20 req/s

### Logs optimisés
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

## 🚨 Troubleshooting

### Problèmes courants

#### Application ne démarre pas
```bash
# Vérifier les logs
./manage-docker.sh logs todolist-app

# Vérifier les variables d'environnement
docker exec todolist-app-prod env | grep NODE_ENV
```

#### MongoDB inaccessible
```bash
# Test de connectivité
docker exec todolist-mongodb-prod mongosh --eval "db.adminCommand('ping')"

# Vérifier les volumes
docker volume inspect todolist-prod_mongodb-data
```

#### Problèmes de réseau
```bash
# Inspecter les réseaux
docker network ls
docker network inspect todolist-prod_todolist-internal

# Test de connectivité inter-services
docker exec todolist-app-prod ping mongodb
```

### Recovery procedures

#### Restauration complète
```bash
# 1. Arrêter les services
./manage-docker.sh stop

# 2. Restaurer la base de données
./manage-docker.sh restore latest-backup.gz

# 3. Redémarrer
./manage-docker.sh start

# 4. Vérifier
./manage-docker.sh status
```

## 📈 Métriques de Production

### Objectifs de performance
- **Uptime** : > 99.9%
- **Response time** : < 200ms (p95)
- **Database connections** : < 100 simultanées
- **Memory usage** : < 512MB par service

### Monitoring externe
```bash
# Intégration avec Prometheus/Grafana
# Métriques exposées sur /metrics (à implémenter)

# Alerting avec PagerDuty/Slack
# Notifications automatiques en cas de panne
```

---

## 🎉 Production Ready !

Cette architecture Docker Compose est **optimisée pour la production** avec :

✅ **Haute disponibilité** - Restart policies et healthchecks  
✅ **Sécurité renforcée** - Réseaux isolés et secrets chiffrés  
✅ **Monitoring complet** - Healthchecks et logs centralisés  
✅ **Sauvegarde automatique** - Persistance et recovery  
✅ **Déploiement Ansible** - Automation complète  
✅ **Performance optimisée** - Limites et cache appropriés  

🚀 **Prêt pour la mise en production !**
