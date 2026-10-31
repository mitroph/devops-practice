#!/bin/bash
set -euo pipefail

docker compose up -d --build --wait
trap 'docker compose down' EXIT


health_endpoint=$(curl -fsS http://localhost:8080/health) || { echo "[FAIL] /health unreachable or not 200"; exit 1; }
if [ -z "$health_endpoint" ]; then
    echo "Error: Health endpoint is empty. The API service may not be running."
    exit 1
fi
status=$(echo "${health_endpoint}" | jq -r '.status')
users_endpoint=$(curl -fsS http://localhost:8080/users) || { echo "[FAIL] /users unreachable"; exit 1; }
if [ -z "$users_endpoint" ]; then
    echo "Error: Users endpoint is empty. The API service may not be running."
    exit 1
fi
user_count=$(echo "${users_endpoint}" | jq -r '. | length')


if [ "$status" != "healthy" ]; then
    echo "Error: API service is not healthy."
    exit 1
fi
echo "API service is healthy."

if [ "$user_count" -lt 3 ]; then
    echo "Error: Less than 3 users found in the database."
    exit 1
fi
echo "Found $user_count users in the database."

echo "[PASS] DEVOPS-1 stack test"
