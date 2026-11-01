#!/bin/bash
set -euo pipefail

echo "[INFO] Deploying infrastructure via Docker Compose..."

trap 'docker compose down' ERROR EXIT
docker compose up -d --wait

echo "[INFO] Waiting for web_server to become ready..."

curl -fsS http://localhost:8080/health || { echo "[FAIL] web_server is not ready"; exit 1; }

echo "[OK] Server is UP and responding to requests!"
echo "[INFO] Fetching live configuration from the network..."



LIVE_VERSION=$(curl -s http://localhost:8080/app_config.json | jq -r '.version')

echo "[SUCCESS] Deployment finished. Live application version is: ${LIVE_VERSION}"
