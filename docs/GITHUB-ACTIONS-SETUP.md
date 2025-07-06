# 🚀 Guide Configuration CI/CD GitHub Actions

## 📋 Configuration des Secrets

### Secrets obligatoires à configurer dans GitHub

Allez dans **Settings > Secrets and variables > Actions** de votre repository :

#### 🔐 Authentification & Registry
```
GITHUB_TOKEN          # Automatique (fourni par GitHub)
DOCKER_USERNAME       # Votre nom d'utilisateur Docker Hub
DOCKER_PASSWORD       # Votre token Docker Hub
```

#### 📱 Notifications
```
SLACK_WEBHOOK         # URL webhook Slack pour notifications
DISCORD_WEBHOOK       # URL webhook Discord pour notifications
```

#### 🛡️ Sécurité & Monitoring
```
CODECOV_TOKEN         # Token Codecov pour upload coverage
SNYK_TOKEN           # Token Snyk pour scans sécurité
ANSIBLE_VAULT_PASSWORD # Mot de passe Ansible Vault
```

#### 🎯 Optionnels
```
GITLEAKS_LICENSE     # Licence GitLeaks Pro (optionnel)
SONAR_TOKEN          # Token SonarCloud (si utilisé)
```

## 🚀 Démarrage Rapide

### 1. Fork ou cloner le repository
```bash
git clone https://github.com/YOUR-USERNAME/tp-ci-cd.git
cd tp-ci-cd
```

### 2. Configurer les secrets GitHub
1. Aller dans **Settings > Secrets and variables > Actions**
2. Ajouter les secrets listés ci-dessus
3. Remplacer `YOUR-USERNAME` dans les fichiers par votre nom d'utilisateur

### 3. Activer les workflows
Les workflows se déclenchent automatiquement sur :
- **Push** sur `main` ou `develop`
- **Pull Request** vers `main`
- **Release** créée
- **Déclenchement manuel** dans l'onglet Actions

### 4. Vérifier l'exécution
1. Aller dans l'onglet **Actions** de votre repository
2. Voir les workflows s'exécuter automatiquement
3. Consulter les rapports générés

## 🎛️ Configuration Avancée

### Variables d'environnement personnalisables

Dans `.github/workflows/ci-cd.yml` :
```yaml
env:
  NODE_ENV: test
  MONGODB_URI: mongodb://localhost:27017/todolist-test
  DOCKER_REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}/todolist-app
```

### Matrice de tests Node.js

Modifiez les versions dans le workflow :
```yaml
strategy:
  matrix:
    node-version: [16.x, 18.x, 20.x]  # Ajoutez/supprimez des versions
```

### Triggers personnalisés

#### Ignorer certains fichiers
```yaml
paths-ignore:
  - '*.md'
  - 'docs/**'
  - '.gitignore'
```

#### Déclencher sur tags spécifiques
```yaml
push:
  tags:
    - 'v*.*.*'     # Versions sémantiques
    - 'release-*'  # Tags de release
```

## 🔧 Personnalisation des Workflows

### Ajouter un nouveau job

```yaml
my-custom-job:
  name: 🎯 Custom Job
  runs-on: ubuntu-latest
  needs: [tests]  # Dépendance optionnelle
  
  steps:
    - name: 📥 Checkout code
      uses: actions/checkout@v4
    
    - name: 🔧 Custom step
      run: |
        echo "Mon job personnalisé"
```

### Modifier les notifications

Dans le job `monitoring` :
```yaml
- name: 📱 Custom notification
  run: |
    curl -X POST YOUR_WEBHOOK_URL \
         -H "Content-Type: application/json" \
         -d '{"message": "Build completed!"}'
```

## 🛡️ Configuration Sécurité

### CodeQL personnalisé

```yaml
- name: 🔍 Initialize CodeQL
  uses: github/codeql-action/init@v2
  with:
    languages: javascript
    queries: +security-and-quality
    config-file: .github/codeql/codeql-config.yml  # Config personnalisée
```

### Trivy configuration

```yaml
- name: 🛡️ Run Trivy scan
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: my-image:latest
    format: 'sarif'
    severity: 'CRITICAL,HIGH'  # Seulement les vulnérabilités critiques
```

## 📊 Monitoring & Métriques

### Badges de statut

Ajoutez dans votre README.md :
```markdown
![CI/CD](https://github.com/YOUR-USERNAME/tp-ci-cd/workflows/🚀%20CI/CD%20Pipeline/badge.svg)
![Security](https://github.com/YOUR-USERNAME/tp-ci-cd/workflows/🛡️%20Security%20Scanning/badge.svg)
[![codecov](https://codecov.io/gh/YOUR-USERNAME/tp-ci-cd/branch/main/graph/badge.svg)](https://codecov.io/gh/YOUR-USERNAME/tp-ci-cd)
```

### Rapports personnalisés

```yaml
- name: 📊 Generate custom report
  run: |
    echo "## 📈 Mon Rapport" >> $GITHUB_STEP_SUMMARY
    echo "- Métrique 1: ${{ steps.mon-step.outputs.metrique1 }}" >> $GITHUB_STEP_SUMMARY
```

## 🚨 Dépannage

### Erreurs communes

#### 1. **Secret non configuré**
```
Error: Secret SLACK_WEBHOOK not found
```
**Solution :** Configurer le secret dans Settings > Secrets

#### 2. **Permissions insuffisantes**
```
Error: Permission denied to write packages
```
**Solution :** Vérifier les permissions dans le workflow :
```yaml
permissions:
  contents: read
  packages: write
```

#### 3. **Cache corrompu**
```
Error: Failed to restore cache
```
**Solution :** Nettoyer le cache manuellement dans Actions > Caches

### Debug des workflows

#### Activer les logs détaillés
```yaml
- name: 🔍 Debug step
  run: |
    echo "Debug info:"
    env | sort
    docker images
    docker ps -a
  env:
    DEBUG: true
```

#### Accéder aux artifacts
1. Aller dans l'exécution du workflow
2. Télécharger la section "Artifacts"
3. Consulter les logs et rapports

## 📚 Ressources Additionnelles

- [Documentation GitHub Actions](https://docs.github.com/en/actions)
- [Marketplace Actions](https://github.com/marketplace?type=actions)
- [Guide sécurité GitHub Actions](https://docs.github.com/en/actions/security-guides)
- [Best practices workflows](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions)

## 🤝 Support

Pour toute question ou problème :
1. Consultez la [documentation des workflows](.github/README.md)
2. Vérifiez les [templates de notifications](.github/templates/notifications.md)
3. Consultez les logs d'exécution dans l'onglet Actions
4. Ouvrez une issue avec les détails de l'erreur

---

<div align="center">

**🚀 Votre pipeline CI/CD est maintenant prêt !**

**⭐ N'oubliez pas de star le repository si cette solution vous aide !**

</div>
