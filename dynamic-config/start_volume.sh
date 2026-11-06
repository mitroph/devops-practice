#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

echo "[INFO] Validating JSON configuration..."
# jq reads value by .environment key
ENV_TYPE=$(jq -r '.environment' app_config.json)

if [ "$ENV_TYPE" == "production" ]; then
    echo "[OK] Production config detected. Proceeding..."
else
    echo "[ERROR] Invalid environment: $ENV_TYPE"
    exit 1
fi

echo "[INFO] Starting Nginx with hot-mounted volume..."

docker rm -f my-nginx 2>/dev/null || true
# Flag -v mounts $(pwd) (current directory) inside the container
docker run -d -p 8080:80 -v "$(pwd)":/usr/share/nginx/html --name my-nginx nginx:alpine
