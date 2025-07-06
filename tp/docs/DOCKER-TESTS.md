# 🧪 TESTS ET VÉRIFICATION DOCKER PRODUCTION

## 📋 Checklist de vérification

### 1. Build et taille de l'image
```bash
# Build production
docker build --target production -t todo-app:prod .

# Vérifier la taille (doit être < 200MB)
docker images todo-app:prod --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Historique des layers
docker history todo-app:prod
```

### 2. Test de sécurité
```bash
# Scan avec Trivy (recommandé)
trivy image todo-app:prod

# Vérifier l'utilisateur non-root
docker run --rm todo-app:prod id
# Résultat attendu: uid=1001(nodejs) gid=1001(nodejs)

# Test des capabilities
docker run --rm todo-app:prod capsh --print
```

### 3. Test fonctionnel
```bash
# Run en mode production
docker run -d -p 4000:4000 \
  -e NODE_ENV=production \
  -e START_MESSAGE="Production Test" \
  --name todo-test \
  todo-app:prod

# Attendre le démarrage
sleep 15

# Test healthcheck
curl -f http://localhost:4000/ || echo "❌ Health check failed"

# Vérifier les logs
docker logs todo-test

# Nettoyer
docker stop todo-test && docker rm todo-test
```

### 4. Test avec docker-compose
```bash
# Production stack complète
docker-compose -f docker-compose.prod.yml up -d

# Vérifier tous les services
docker-compose -f docker-compose.prod.yml ps

# Test de l'application
curl -f http://localhost:4000/

# Arrêt propre
docker-compose -f docker-compose.prod.yml down
```

### 5. Performance et monitoring
```bash
# Stats des ressources
docker stats todo-app-prod

# Inspection de l'image
docker inspect todo-app:prod | jq '.[0].Config.Env'

# Test de charge simple
ab -n 100 -c 10 http://localhost:4000/
```

## 🎯 Résultats attendus

- **Taille image**: 100-150MB
- **Démarrage**: < 10 secondes
- **Healthcheck**: ✅ après 10-15s
- **Utilisateur**: nodejs (1001)
- **Vulnérabilités**: 0 HIGH/CRITICAL
- **Performance**: > 50 req/s (test local)

## 🚨 Troubleshooting

### Image trop lourde
```bash
# Analyser les layers
docker history todo-app:prod

# Nettoyer le cache npm
RUN npm cache clean --force

# Supprimer node_modules dev
RUN rm -rf node_modules && npm ci --only=production
```

### Problèmes de permissions
```bash
# Vérifier ownership
docker run --rm todo-app:prod ls -la /app

# Fix dans Dockerfile
COPY --chown=nodejs:nodejs . .
```

### Healthcheck qui échoue
```bash
# Debug dans le container
docker exec -it todo-test curl -v http://localhost:4000/

# Vérifier les variables d'env
docker exec todo-test env | grep PORT
```
