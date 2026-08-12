#!/bin/bash

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
# Flag -v mounts $(pwd) (current directory) inside the container
docker run -d -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx:alpine
