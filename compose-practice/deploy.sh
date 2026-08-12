#!/bin/bash

echo "[INFO] Deploying infrastructure via Docker Compose..."

docker-compose up -d

echo "[INFO] Waiting for web_server to become ready..."

while [ "$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/app_config.json)" != "200" ]; do
    echo "[WAIT] Server is not ready yet. Sleeping for 2 seconds..."
    sleep 2
done


echo "[OK] Server is UP and responding to requests!"
echo "[INFO] Fetching live configuration from the network..."



LIVE_VERSION=$(curl -s http://localhost:8080/app_config.json | jq -r '.version')

echo "[SUCCESS] Deployment finished. Live application version is: ${LIVE_VERSION}"
