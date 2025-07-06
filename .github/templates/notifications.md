# 📱 Templates de Notifications CI/CD

## 🔔 Template Slack

### Configuration Webhook Slack

1. **Créer une Slack App :**
   - Aller sur https://api.slack.com/apps
   - Cliquer "Create New App" > "From scratch"
   - Nommer l'app "TodoList CI/CD"

2. **Configurer Incoming Webhooks :**
   - Dans votre app, aller à "Incoming Webhooks"
   - Activer "Activate Incoming Webhooks"
   - Cliquer "Add New Webhook to Workspace"
   - Choisir le canal (ex: #deployments)

3. **Ajouter le secret GitHub :**
   ```
   SLACK_WEBHOOK=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
   ```

### Template Slack (utilisé dans les workflows)

```json
{
  "channel": "#deployments",
  "username": "GitHub Actions",
  "icon_emoji": ":rocket:",
  "attachments": [
    {
      "color": "good",
      "title": "✅ TodoList CI/CD Pipeline - Success",
      "title_link": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}",
      "fields": [
        {
          "title": "Repository",
          "value": "${{ github.repository }}",
          "short": true
        },
        {
          "title": "Branch", 
          "value": "${{ github.ref_name }}",
          "short": true
        },
        {
          "title": "Commit",
          "value": "`${{ github.sha }}`",
          "short": true
        },
        {
          "title": "Author",
          "value": "${{ github.actor }}",
          "short": true
        },
        {
          "title": "Event",
          "value": "${{ github.event_name }}",
          "short": true
        },
        {
          "title": "Workflow",
          "value": "${{ github.workflow }}",
          "short": true
        }
      ],
      "footer": "GitHub Actions",
      "footer_icon": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
      "ts": ${{ github.event.head_commit.timestamp }}
    }
  ]
}
```

### Template Slack pour échecs

```json
{
  "channel": "#deployments",
  "username": "GitHub Actions",
  "icon_emoji": ":warning:",
  "attachments": [
    {
      "color": "danger",
      "title": "❌ TodoList CI/CD Pipeline - Failed",
      "title_link": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}",
      "text": "⚠️ Pipeline failed! Please check the logs for details.",
      "fields": [
        {
          "title": "Failed Job",
          "value": "${{ needs.*.result }}",
          "short": false
        },
        {
          "title": "Repository",
          "value": "${{ github.repository }}",
          "short": true
        },
        {
          "title": "Branch",
          "value": "${{ github.ref_name }}",
          "short": true
        }
      ],
      "actions": [
        {
          "type": "button",
          "text": "View Logs",
          "url": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
        },
        {
          "type": "button", 
          "text": "Re-run Jobs",
          "url": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
        }
      ]
    }
  ]
}
```

## 🎮 Template Discord

### Configuration Webhook Discord

1. **Créer un Webhook Discord :**
   - Dans votre serveur Discord, aller dans les paramètres du canal
   - Onglet "Intégrations" > "Webhooks"
   - Cliquer "Créer un Webhook"
   - Nommer le webhook "TodoList CI/CD"
   - Copier l'URL du webhook

2. **Ajouter le secret GitHub :**
   ```
   DISCORD_WEBHOOK=https://discord.com/api/webhooks/YOUR/DISCORD/WEBHOOK
   ```

### Template Discord pour succès

```json
{
  "username": "GitHub Actions",
  "avatar_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
  "embeds": [
    {
      "title": "✅ TodoList CI/CD Pipeline - Success",
      "description": "All checks passed successfully!",
      "color": 65280,
      "url": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}",
      "thumbnail": {
        "url": "https://raw.githubusercontent.com/github/explore/main/topics/github-actions/github-actions.png"
      },
      "fields": [
        {
          "name": "🏢 Repository",
          "value": "`${{ github.repository }}`",
          "inline": true
        },
        {
          "name": "🌿 Branch",
          "value": "`${{ github.ref_name }}`",
          "inline": true
        },
        {
          "name": "👤 Author",
          "value": "${{ github.actor }}",
          "inline": true
        },
        {
          "name": "🔀 Commit",
          "value": "`${{ github.sha }}`",
          "inline": false
        },
        {
          "name": "🧪 Tests",
          "value": "✅ Passed",
          "inline": true
        },
        {
          "name": "🐳 Docker Build",
          "value": "✅ Success",
          "inline": true
        },
        {
          "name": "🚀 Deployment",
          "value": "✅ Simulated",
          "inline": true
        }
      ],
      "footer": {
        "text": "GitHub Actions • TodoList Production",
        "icon_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
      },
      "timestamp": "${{ github.event.head_commit.timestamp }}"
    }
  ]
}
```

### Template Discord pour échecs

```json
{
  "username": "GitHub Actions",
  "avatar_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
  "embeds": [
    {
      "title": "❌ TodoList CI/CD Pipeline - Failed",
      "description": "Some checks failed. Please review the logs.",
      "color": 16711680,
      "url": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}",
      "thumbnail": {
        "url": "https://raw.githubusercontent.com/github/explore/main/topics/github-actions/github-actions.png"
      },
      "fields": [
        {
          "name": "🏢 Repository",
          "value": "`${{ github.repository }}`",
          "inline": true
        },
        {
          "name": "🌿 Branch",
          "value": "`${{ github.ref_name }}`",
          "inline": true
        },
        {
          "name": "👤 Author",
          "value": "${{ github.actor }}",
          "inline": true
        },
        {
          "name": "❌ Failed Jobs",
          "value": "Check the workflow logs for details",
          "inline": false
        },
        {
          "name": "🔗 Actions",
          "value": "[View Logs](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}) • [Re-run Jobs](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})",
          "inline": false
        }
      ],
      "footer": {
        "text": "GitHub Actions • TodoList Production",
        "icon_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
      },
      "timestamp": "${{ github.event.head_commit.timestamp }}"
    }
  ]
}
```

## 📊 Template pour Releases

### Discord Release Notification

```json
{
  "username": "Release Bot",
  "avatar_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
  "embeds": [
    {
      "title": "🎉 New Release: TodoList v${{ github.event.release.tag_name }}",
      "description": "${{ github.event.release.body }}",
      "color": 3447003,
      "url": "${{ github.event.release.html_url }}",
      "thumbnail": {
        "url": "https://raw.githubusercontent.com/github/explore/main/topics/docker/docker.png"
      },
      "fields": [
        {
          "name": "🏷️ Version",
          "value": "`${{ github.event.release.tag_name }}`",
          "inline": true
        },
        {
          "name": "📦 Type",
          "value": "${{ github.event.release.prerelease && 'Pre-release' || 'Stable' }}",
          "inline": true
        },
        {
          "name": "👤 Author",
          "value": "${{ github.event.release.author.login }}",
          "inline": true
        },
        {
          "name": "🐳 Docker Image",
          "value": "`ghcr.io/${{ github.repository }}/todolist-app:${{ github.event.release.tag_name }}`",
          "inline": false
        },
        {
          "name": "📥 Download",
          "value": "[Release Assets](${{ github.event.release.html_url }})",
          "inline": true
        },
        {
          "name": "📖 Documentation",
          "value": "[Deployment Guide](https://github.com/${{ github.repository }}/blob/main/deployment/ansible/GUIDE-DEPLOIEMENT.md)",
          "inline": true
        }
      ],
      "footer": {
        "text": "GitHub Releases • TodoList Production",
        "icon_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
      },
      "timestamp": "${{ github.event.release.published_at }}"
    }
  ]
}
```

## 🛡️ Template Sécurité

### Discord Security Alert

```json
{
  "username": "Security Bot",
  "avatar_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
  "embeds": [
    {
      "title": "🚨 Security Alert - TodoList",
      "description": "Security vulnerabilities detected in the codebase",
      "color": 16711680,
      "url": "${{ github.server_url }}/${{ github.repository }}/security",
      "thumbnail": {
        "url": "https://raw.githubusercontent.com/github/explore/main/topics/security/security.png"
      },
      "fields": [
        {
          "name": "🔍 Scan Type",
          "value": "Comprehensive Security Scan",
          "inline": true
        },
        {
          "name": "⚠️ Severity",
          "value": "HIGH",
          "inline": true
        },
        {
          "name": "🎯 Action Required",
          "value": "Review and fix vulnerabilities immediately",
          "inline": false
        },
        {
          "name": "🔗 Links",
          "value": "[Security Tab](${{ github.server_url }}/${{ github.repository }}/security) • [Code Scanning](${{ github.server_url }}/${{ github.repository }}/security/code-scanning)",
          "inline": false
        }
      ],
      "footer": {
        "text": "GitHub Security • Automated Scan",
        "icon_url": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
      },
      "timestamp": "${{ github.event.head_commit.timestamp }}"
    }
  ]
}
```

## 🎯 Utilisation dans les workflows

### Exemple d'intégration Slack

```yaml
- name: 📱 Send Slack notification
  if: always()
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    channel: '#deployments'
    username: 'GitHub Actions'
    icon_emoji: ':rocket:'
    title: '${{ job.status == 'success' && '✅' || '❌' }} TodoList CI/CD Pipeline'
    text: |
      *Repository:* ${{ github.repository }}
      *Branch:* ${{ github.ref_name }}
      *Commit:* `${{ github.sha }}`
      *Author:* ${{ github.actor }}
      *Status:* ${{ job.status }}
```

### Exemple d'intégration Discord

```yaml
- name: 🎮 Send Discord notification
  if: always()
  run: |
    curl -H "Content-Type: application/json" \
         -d @.github/templates/discord-success.json \
         "${{ secrets.DISCORD_WEBHOOK }}"
```

## 📋 Checklist de configuration

- [ ] Configurer les webhooks Slack/Discord
- [ ] Ajouter les secrets GitHub appropriés
- [ ] Tester les notifications avec un workflow simple
- [ ] Personnaliser les messages selon vos besoins
- [ ] Configurer les canaux de notification appropriés
- [ ] Vérifier les permissions des webhooks

---

<div align="center">

**🔔 Notifications configurées pour un feedback instantané sur vos déploiements !**

</div>
