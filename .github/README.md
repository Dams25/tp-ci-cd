# 🚀 Guide GitHub Actions CI/CD - TodoList Production

> **Documentation complète des pipelines CI/CD avec GitHub Actions**

## 📋 Vue d'ensemble

Ce projet utilise GitHub Actions pour automatiser complètement le cycle de développement avec trois workflows principaux :

- **🚀 CI/CD Pipeline** (`ci-cd.yml`) - Tests, build et déploiement simulation
- **🛡️ Security Scanning** (`security.yml`) - Analyses de sécurité continues
- **🎉 Release Pipeline** (`release.yml`) - Automatisation des releases

## 🎯 Workflows détaillés

### 🚀 CI/CD Pipeline (`.github/workflows/ci-cd.yml`)

**Déclencheurs :**
- Push sur `main` et `develop`
- Pull requests vers `main`
- Releases publiées
- Déclenchement manuel avec options

**Jobs inclus :**

#### 1. 🔍 **Detect Changes**
- Optimise l'exécution en détectant les fichiers modifiés
- Évite les builds inutiles

#### 2. 🧪 **Tests & Quality**
- Matrice Node.js : 16.x, 18.x, 20.x
- Tests unitaires et d'intégration avec MongoDB
- Linting ESLint et vérification formatage
- Audit de sécurité npm
- Upload coverage vers Codecov

#### 3. 🐳 **Docker Build & Scan**
- Build multi-architecture (amd64/arm64)
- Cache intelligent avec GitHub Actions
- Scan sécurité avec Trivy
- Tests fonctionnels du container
- Publication vers GitHub Container Registry

#### 4. 🚀 **Ansible Deployment Simulation**
- Validation syntaxe des playbooks
- Simulation complète avec `--check --diff`
- Tests des rôles avec Molecule (si configuré)
- Génération de rapports de déploiement

#### 5. 📊 **Monitoring & Notifications**
- Agrégation de tous les résultats
- Notifications Slack/Discord
- Génération de rapports qualité
- Upload des artifacts

### 🛡️ Security Scanning (`.github/workflows/security.yml`)

**Déclencheurs :**
- Push et PR sur branches principales
- Programmé (hebdomadaire)
- Déclenchement manuel avec options

**Analyses incluses :**

#### 🔍 **CodeQL Analysis**
- Analyse statique du code JavaScript
- Détection de vulnérabilités et problèmes qualité

#### 📦 **Dependency Analysis**
- npm audit pour vulnérabilités des dépendances
- Dependency Review pour les PR
- Scan Snyk pour sécurité avancée

#### 🐳 **Docker Security Scan**
- Trivy pour containers, filesystem et config
- Hadolint pour validation Dockerfile
- Docker Bench Security

#### 🔐 **Secrets Detection**
- TruffleHog pour détection de secrets exposés
- GitLeaks pour scan historique

#### 🛡️ **Infrastructure Security**
- Checkov pour Infrastructure as Code
- Analyse spécifique des playbooks Ansible

### 🎉 Release Pipeline (`.github/workflows/release.yml`)

**Déclencheurs :**
- Push de tags `v*.*.*`
- Déclenchement manuel avec paramètres

**Processus de release :**

#### 1. 🏷️ **Prepare Release**
- Extraction des informations de version
- Génération automatique du changelog
- Validation du format semver

#### 2. 🧪 **Validation Tests**
- Tests complets avant release
- Validation sur multiple versions Node.js
- Tests de performance

#### 3. 🐳 **Build Release Artifacts**
- Build Docker multi-architecture
- Scan sécurité de l'image finale
- Création des artifacts de release

#### 4. 🚀 **Create GitHub Release**
- Création automatique de la release GitHub
- Notes de release détaillées
- Attachement des artifacts

#### 5. 📊 **Post-Release Tasks**
- Mise à jour du CHANGELOG.md
- Mise à jour des badges de version
- Commit automatique des changements

## 🔧 Configuration requise

### 🔐 Secrets GitHub

Configurez ces secrets dans votre repository GitHub (`Settings > Secrets and variables > Actions`) :

```bash
# Docker Hub (optionnel)
DOCKER_USERNAME=your-docker-username
DOCKER_PASSWORD=your-docker-password

# Notifications
SLACK_WEBHOOK=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
DISCORD_WEBHOOK=https://discord.com/api/webhooks/YOUR/DISCORD/WEBHOOK

# Code coverage
CODECOV_TOKEN=your-codecov-token

# Sécurité
SNYK_TOKEN=your-snyk-token
GITLEAKS_LICENSE=your-gitleaks-license

# Ansible (pour déploiement réel)
ANSIBLE_VAULT_PASSWORD=your-vault-password
```

### 📝 Variables d'environnement

Les workflows utilisent ces variables automatiquement :

```yaml
NODE_ENV: test
MONGODB_URI: mongodb://localhost:27017/todolist-test
DOCKER_REGISTRY: ghcr.io
IMAGE_NAME: ${{ github.repository }}/todolist-app
```

## 🎮 Utilisation des workflows

### ⚡ Déclenchement automatique

```bash
# Déclenche CI/CD complet
git push origin main

# Déclenche CI/CD + security sur PR
git checkout -b feature/new-feature
git push origin feature/new-feature
# Créer PR via GitHub UI

# Déclenche release
git tag v1.2.3
git push origin v1.2.3
```

### 🎯 Déclenchement manuel

#### CI/CD Pipeline
```yaml
# Via GitHub UI : Actions > CI/CD Pipeline > Run workflow
Environment: staging|production
Skip tests: false
Force rebuild: false
```

#### Security Scanning
```yaml
# Via GitHub UI : Actions > Security Scanning > Run workflow
Scan type: full|code-only|dependencies-only|docker-only
```

#### Release Pipeline
```yaml
# Via GitHub UI : Actions > Release Pipeline > Run workflow
Version: 1.2.3
Pre-release: false
Generate changelog: true
```

## 📊 Monitoring et rapports

### 🎯 Artifacts générés

| Workflow | Artifacts | Rétention |
|----------|-----------|-----------|
| CI/CD | Test results, coverage, simulation reports | 30 jours |
| Security | Security reports, scan results | 90 jours |
| Release | Release packages (.tar.gz, .zip) | 90 jours |

### 📈 Badges de statut

Ajoutez ces badges à votre README.md :

```markdown
![CI/CD Pipeline](https://github.com/YOUR-USERNAME/YOUR-REPO/workflows/🚀%20CI/CD%20Pipeline/badge.svg)
![Security Scanning](https://github.com/YOUR-USERNAME/YOUR-REPO/workflows/🛡️%20Security%20Scanning/badge.svg)
![Release Pipeline](https://github.com/YOUR-USERNAME/YOUR-REPO/workflows/🎉%20Release%20Pipeline/badge.svg)
```

### 🔍 Surveillance continue

- **Code Quality:** Liens vers CodeQL, Codecov
- **Security:** Dependabot alerts, security advisories
- **Performance:** Métriques de build et déploiement

## 🚀 Optimisations de performance

### 📦 Cache intelligent
- **npm:** Cache des dépendances Node.js
- **Docker:** Cache des layers entre builds
- **GitHub Actions:** Cache des outils et data

### ⚡ Parallélisation
- Jobs indépendants exécutés simultanément
- Matrice de tests pour multiple versions
- Conditional execution basée sur les changements

### 🎯 Conditional deployments
- Déploiement seulement depuis `main`
- Skip de jobs basé sur les fichiers modifiés
- Optimisation pour les PR et commits de docs

## 🛡️ Sécurité et bonnes pratiques

### 🔐 Sécurité des secrets
- Utilisation des GitHub Secrets
- Pas de secrets en dur dans le code
- Rotation régulière des tokens

### 🎯 Principle of least privilege
- Permissions minimales pour chaque job
- Isolation des environnements
- Validation des inputs utilisateur

### 📊 Quality gates
- Tests obligatoires avant merge
- Coverage minimum requis
- Scans sécurité automatiques

## 🔧 Maintenance et troubleshooting

### 🐛 Dépannage commun

**Tests qui échouent :**
```bash
# Vérifier les logs détaillés
# Relancer seulement les tests : Re-run failed jobs

# Tests MongoDB : vérifier la connexion
# Tests Linting : vérifier le format du code
```

**Build Docker qui échoue :**
```bash
# Vérifier le Dockerfile
# Vérifier les build args
# Nettoyer le cache : Force rebuild = true
```

**Échec simulation Ansible :**
```bash
# Vérifier la syntaxe des playbooks
# Vérifier les variables dans vars/deploy.yml
# Vérifier l'inventaire inventory.ini
```

### 🔄 Mise à jour des workflows

1. **Tester localement** avec `act` (optionnel)
2. **Tester sur branche** avant merge vers main
3. **Mettre à jour la documentation** si nécessaire
4. **Vérifier les breaking changes** des actions utilisées

## 📚 Ressources additionnelles

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Best Practices](https://docs.docker.com/develop/best-practices/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Security Best Practices](https://docs.github.com/en/actions/security-guides)

---

<div align="center">

**🚀 Ces workflows sont optimisés pour la performance, la sécurité et la maintenabilité !**

**📖 Guide complet de déploiement :** [`deployment/ansible/GUIDE-DEPLOIEMENT.md`](../tp/deployment/ansible/GUIDE-DEPLOIEMENT.md)

Made with ❤️ and ⚡ by [Sebastian ONISE](https://github.com/SO-Ctrix)

</div>
