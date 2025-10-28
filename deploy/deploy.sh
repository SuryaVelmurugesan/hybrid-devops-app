#!/usr/bin/env bash
set -e

IMAGE="$1"
TAG="$2"
APP_NAME="devops-capstone-app"
CONTAINER_NAME="${APP_NAME}-container"

# ensure docker installed (simple check)
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not found; install docker first"
  exit 1
fi

docker pull "${IMAGE}:${TAG}"

# stop & remove old container if exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
  docker rm -f "${CONTAINER_NAME}" || true
fi

# run container
docker run -d --restart always --name "${CONTAINER_NAME}" -p 3000:3000 "${IMAGE}:${TAG}"

echo "Deployed ${IMAGE}:${TAG}"
