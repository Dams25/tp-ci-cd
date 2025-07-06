# ⚡ Quick Start - CI/CD GitHub Actions

> **🚀 Votre pipeline CI/CD prêt en 5 minutes !**

## 🎯 Étapes Rapides

### 1. 📂 Préparer le Repository
```bash
# Cloner le projet
git clone https://github.com/YOUR-USERNAME/tp-ci-cd.git
cd tp-ci-cd

# Ou fork le repository sur GitHub
```

### 2. 🔐 Configurer les Secrets (OBLIGATOIRE)

Allez dans **Settings > Secrets and variables > Actions** :

#### ✅ Secrets Minimum Requis
```
GITHUB_TOKEN          # ✅ Automatique
SLACK_WEBHOOK         # 📱 https://hooks.slack.com/services/...
DISCORD_WEBHOOK       # 🎮 https://discord.com/api/webhooks/...
```

#### 🛡️ Secrets Sécurité (Recommandés)
```
CODECOV_TOKEN         # 📊 Couverture code
SNYK_TOKEN           # 🛡️ Scans sécurité
ANSIBLE_VAULT_PASSWORD # 🔒 Déploiement
```

### 3. 🏷️ Personnaliser les Fichiers

#### Remplacer dans tous les fichiers `.github/` :
```bash
# Rechercher et remplacer
YOUR-USERNAME → votre-nom-utilisateur-github
YOUR-PROJECT → nom-de-votre-projet
```

#### Fichiers à modifier :
- `.github/workflows/ci-cd.yml`
- `.github/workflows/security.yml`
- `.github/workflows/release.yml`
- `.github/templates/badges.md`

### 4. 🚀 Premier Test

```bash
# Créer une branche de test
git checkout -b test-ci-cd

# Faire un petit changement
echo "# Test CI/CD" > test.md
git add test.md
git commit -m "feat: test CI/CD pipeline"

# Pousser et créer une PR
git push origin test-ci-cd
```

### 5. ✅ Vérifier l'Exécution

1. **Aller dans l'onglet Actions** de votre repository
2. **Voir les workflows** s'exécuter automatiquement :
   - 🚀 CI/CD Pipeline
   - 🛡️ Security Scanning
3. **Vérifier les notifications** dans Slack/Discord

## 🎮 Commandes Utiles

### Déclencher manuellement un workflow
1. Aller dans **Actions**
2. Sélectionner le workflow
3. Cliquer **"Run workflow"**
4. Choisir les options

### Voir les logs détaillés
1. Cliquer sur une exécution
2. Développer chaque job
3. Voir les étapes détaillées

### Télécharger les artifacts
1. Dans une exécution terminée
2. Scroll en bas
3. Section **"Artifacts"**

## 🔧 Configuration Express

### Variables d'environnement communes
```yaml
env:
  NODE_ENV: test
  MONGODB_URI: mongodb://localhost:27017/todolist-test
  DOCKER_REGISTRY: ghcr.io
```

### Triggers automatiques activés
- ✅ Push sur `main` et `develop`
- ✅ Pull Requests vers `main`
- ✅ Releases créées
- ✅ Déclenchement manuel

## 📊 Résultats Attendus

### ✅ Pipeline CI/CD Réussi
- 🧪 **Tests** sur Node.js 16, 18, 20
- 🐳 **Build Docker** multi-architecture
- 🚀 **Simulation Ansible** déploiement
- 📊 **Rapports** de qualité

### 🛡️ Sécurité Validée
- 🔍 **CodeQL** analyse statique
- 📦 **Audit npm** dépendances
- 🐳 **Trivy scan** images Docker
- 🔐 **Détection secrets**

### 📱 Notifications Actives
- 📨 **Slack** : statut détaillé
- 🎮 **Discord** : embed riche
- 📈 **GitHub** : badges mis à jour

## 🚨 Problèmes Courants

### ❌ "Secret not found"
```bash
# Solution : Ajouter le secret manquant
Settings > Secrets and variables > Actions > New repository secret
```

### ❌ "Permission denied"
```bash
# Solution : Vérifier les permissions du token
Settings > Actions > General > Workflow permissions
```

### ❌ "Build failed"
```bash
# Solution : Vérifier les logs détaillés
Actions > Workflow failed > Job > Étape échouée
```

## 🎯 Prochaines Étapes

### 1. **Ajouter des badges** au README
```markdown
![CI/CD](https://github.com/YOUR-USERNAME/tp-ci-cd/workflows/🚀%20CI/CD%20Pipeline/badge.svg)
```

### 2. **Configurer les branches protégées**
Settings > Branches > Add rule : `main`

### 3. **Activer Dependabot**
Déjà configuré dans `.github/dependabot.yml`

### 4. **Personnaliser les workflows**
Voir le [guide complet](GITHUB-ACTIONS-SETUP.md)

---

<div align="center">

## 🎉 Félicitations !

**Votre pipeline CI/CD GitHub Actions est opérationnel !**

**🔗 [Guide Complet](GITHUB-ACTIONS-SETUP.md) | 📚 [Documentation](.github/README.md) | 🛡️ [Sécurité](../SECURITY.md)**

</div>

---

## 📞 Support Rapide

| Problème | Solution Rapide |
|----------|----------------|
| 🔐 Secrets | Settings > Secrets and variables > Actions |
| 📱 Notifications | Vérifier webhooks Slack/Discord |
| 🧪 Tests | Voir logs dans Actions > Workflow > Job |
| 🐳 Docker | Vérifier Dockerfile et registry |
| 🚀 Déploiement | Validation Ansible dans logs |

**💡 Astuce :** Utilisez l'onglet Actions pour voir tous les workflows en cours et leurs résultats !
