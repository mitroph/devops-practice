#!/bin/bash

## Starting 3 services

docker-compose up -d

echo "[INFO] Starting of 3 services..."


sleep 5


frontend_response=$(curl -s http://localhost:8080/ | grep -i 'DOCTYPE')

backend_response=$(curl -s http://localhost:8080/api/data.json | jq -r '.proxy')


if [ "${frontend_response}" == "<!DOCTYPE html>" ] && [ "${backend_response}" == "active" ]; then
    echo "[GATEWAY SECURED]"
else
    echo "[GATEWAY FAILED]"
    echo "[FRONTEND variable] ${frontend_response}"
    echo "[BACKEND variable] ${backend_response}"
    docker-compose down
fi
