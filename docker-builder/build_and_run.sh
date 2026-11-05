#!/bin/bash
set -euo pipefail

echo "[INFO] Generating index.html..."

sed "s/{{STATUS}}/ACTIVE/g; s|{{BUILD_DATE}}|$(date +"%D")|g" index.template.html > index.html

echo "[INFO] Building Docker image..."

docker build -t my-smart-nginx:latest .

echo "[INFO] Running container on port 8080..."

docker rm -f web 2>/dev/null || true

docker run -d --name web -p 8080:80 my-smart-nginx:latest
