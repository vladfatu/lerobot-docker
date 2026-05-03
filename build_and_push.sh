#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# build_and_push.sh
# Builds the LeRobot Docker image and pushes it to Docker Hub.
#
# Usage:
#   chmod +x build_and_push.sh
#   ./build_and_push.sh <your-dockerhub-username>
#
# Example:
#   ./build_and_push.sh johnsmith
# ─────────────────────────────────────────────────────────────

set -euo pipefail

DOCKERHUB_USER="${1:-}"
IMAGE_NAME="lerobot-runpod"
TAG="latest"

if [[ -z "$DOCKERHUB_USER" ]]; then
  echo "Error: Docker Hub username is required."
  echo "Usage: ./build_and_push.sh <your-dockerhub-username>"
  exit 1
fi

FULL_IMAGE="${DOCKERHUB_USER}/${IMAGE_NAME}:${TAG}"

echo "──────────────────────────────────────────"
echo "  Building image: ${FULL_IMAGE}"
echo "──────────────────────────────────────────"

docker build \
  --platform linux/amd64 \
  --tag "${FULL_IMAGE}" \
  --file Dockerfile \
  .

echo ""
echo "──────────────────────────────────────────"
echo "  Pushing to Docker Hub..."
echo "──────────────────────────────────────────"

docker push "${FULL_IMAGE}"

echo ""
echo "✓ Done! Use this image in RunPod:"
echo "  ${FULL_IMAGE}"
