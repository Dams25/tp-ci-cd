#!/bin/bash

# ==============================================================================
# SCRIPT DE BUILD DOCKER PRODUCTION - TO-DO LIST
# ==============================================================================

set -e

echo "🚀 Building TO-DO List Docker Image for Production..."

# Variables
IMAGE_NAME="todo-app"
TAG=${1:-latest}
FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"

# Build avec cache et optimisations
echo "📦 Building image: ${FULL_IMAGE_NAME}"
docker build \
  --target production \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --cache-from ${IMAGE_NAME}:cache \
  --tag ${FULL_IMAGE_NAME} \
  --tag ${IMAGE_NAME}:cache \
  .

# Affichage de la taille de l'image
echo "📊 Image size:"
docker images ${FULL_IMAGE_NAME} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Test rapide de sécurité (si trivy est installé)
if command -v trivy &> /dev/null; then
    echo "🔒 Running security scan..."
    trivy image --severity HIGH,CRITICAL ${FULL_IMAGE_NAME}
fi

# Test du healthcheck
echo "🏥 Testing container health..."
CONTAINER_ID=$(docker run -d -p 3001:3000 ${FULL_IMAGE_NAME})
sleep 10

if docker exec ${CONTAINER_ID} curl -f http://localhost:3000/ > /dev/null 2>&1; then
    echo "✅ Health check passed!"
else
    echo "❌ Health check failed!"
    docker logs ${CONTAINER_ID}
fi

docker stop ${CONTAINER_ID}
docker rm ${CONTAINER_ID}

echo "🎉 Build completed successfully!"
echo "💡 Run with: docker run -p 3000:3000 ${FULL_IMAGE_NAME}"
