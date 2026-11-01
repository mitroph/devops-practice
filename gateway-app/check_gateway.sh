#!/bin/bash
set -euo pipefail

trap 'docker compose down' EXIT
## Starting 3 services
echo "[INFO] Starting of 3 services..."
docker compose up -d --build --wait


frontend_response=$(curl -s http://localhost:8080/ | grep -i 'DOCTYPE')

backend_response=$(curl -fsS http://localhost:8080/api/data.json | jq -r '.proxy') || { echo "[FAIL] /health unreachable or not 200"; exit 1; }


if [ "${frontend_response}" == "<!DOCTYPE html>" ] && [ "${backend_response}" == "active" ]; then
    echo "[GATEWAY SECURED]"
else
    echo "[GATEWAY FAILED]"
    echo "[FRONTEND variable] ${frontend_response}"
    echo "[BACKEND variable] ${backend_response}"
    docker compose down -v
    exit 1
fi
