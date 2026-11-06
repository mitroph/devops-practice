#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

echo "[INFO] Deploying infrastructure via Docker Compose..."

trap 'docker compose down' ERR
docker compose up -d --wait

echo "[INFO] Waiting for web_server to become ready..."

curl -fsS http://127.0.0.1:8085/app_config.json || { echo "[FAIL] web_server is not ready"; exit 1; }

echo "[OK] Server is UP and responding to requests!"
echo "[INFO] Fetching live configuration from the network..."



LIVE_VERSION=$(curl -s http://127.0.0.1:8085/app_config.json | jq -r '.version')

echo "[SUCCESS] Deployment finished. Live application version is: ${LIVE_VERSION}"
