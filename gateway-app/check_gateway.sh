#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

trap 'docker compose down' EXIT
## Starting 3 services
echo "[INFO] Starting of 3 services..."
docker compose up -d --build --wait


frontend_response=$(curl -s http://127.0.0.1:8070/ | grep -i 'DOCTYPE') || { echo "[GATEWAY FAILED] / unreachable or not 200"; exit 1; }

backend_response=$(curl -fsS http://127.0.0.1:8070/api/data.json | jq -r '.proxy') || { echo "[BACKEND FAIL] /api/data.json unreachable or not 200"; exit 1; }


if [ "${frontend_response}" == "<!DOCTYPE html>" ] && [ "${backend_response}" == "active" ]; then
    echo "[GATEWAY SECURED]"
else
    echo -e "\e[0;91m[GATEWAY FAILED] \e[0;97m\n"
    echo -e "\e[0;93m[FRONTEND variable] \e[0;97m${frontend_response} \n"
    echo -e "\e[0;93m[BACKEND variable] \e[0;97m${backend_response} \n"
    docker compose down -v
    exit 1
fi
