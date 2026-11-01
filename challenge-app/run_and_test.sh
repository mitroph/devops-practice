#!/bin/bash
set -euo pipefail

trap 'docker compose down' EXIT
# Running our 2 services be docker-compose
docker compose up -d --build --wait

echo "[INFO] Started up of services"


# Request to the backend service
auth=$(curl -s -f -H "Accept: application/json" http://localhost:8082/api.json | jq -r '.module')


if [ "${auth}" == "auth" ]; then

    # In case of we've got response "auth" from backend service
    echo "[SUCCESS] Microservices are up!"

else
    # In case of we haven't got right response
    echo "[FAIL] Wrong API response"

    docker compose down
    exit 1
fi

