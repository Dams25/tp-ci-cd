# ==============================================================================
# DOCKERFILE MULTI-STAGE POUR PRODUCTION - TO-DO LIST NODE.JS
# ==============================================================================

# Stage 1: Build & Test
FROM node:20-alpine AS builder

# Métadonnées
LABEL maintainer="DevOps Team" \
      description="TO-DO List Node.js Application - Production Build" \
      version="1.0.0"

# Optimisation des layers - installation des outils système en une fois
RUN apk add --no-cache \
    dumb-init \
    && addgroup -g 1001 -S nodejs \
    && adduser -S nextjs -u 1001

# Définition du répertoire de travail
WORKDIR /app

# Copie des fichiers de configuration npm (optimisation du cache Docker)
COPY src/package*.json ./

# Installation des dépendances avec optimisations production
RUN npm ci --only=production --silent --no-audit --no-fund \
    && npm cache clean --force

# Copie du code source
COPY src/ .

# Nettoyage des fichiers de développement
RUN rm -rf tests/ docker/ infrastructure/ \
    && rm -f *.md jest.config.js

# Stage 2: Tests (optionnel, peut être désactivé en production)
FROM node:20-alpine AS tester

WORKDIR /app

# Copie des dépendances de build
COPY package*.json ./
RUN npm ci --silent --no-audit --no-fund

# Copie du code pour les tests
COPY . .

# Exécution des tests
RUN npm test

# Stage 3: Runtime Production
FROM node:20-alpine AS production

# Installation d'outils essentiels pour la production
RUN apk add --no-cache \
    dumb-init \
    curl \
    && addgroup -g 1001 -S nodejs \
    && adduser -S nodejs -u 1001 -G nodejs

# Répertoire de travail
WORKDIR /app

# Copie des node_modules optimisés depuis le stage builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copie du code application
COPY --from=builder --chown=nodejs:nodejs /app .

# Variables d'environnement par défaut
ENV NODE_ENV=production \
    PORT=3000 \
    START_MESSAGE="Production Server Started" \
    NPM_CONFIG_LOGLEVEL=warn

# Healthcheck intégré
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:${PORT}/ || exit 1

# Exposition du port
EXPOSE $PORT

# Changement d'utilisateur pour la sécurité (non-root)
USER nodejs

# Point d'entrée avec dumb-init pour la gestion des signaux
ENTRYPOINT ["dumb-init", "--"]

# Commande par défaut
CMD ["node", "index.js"]
