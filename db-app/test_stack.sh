#!/bin/bash
set -euo pipefail

docker compose up -d --build --wait
trap 'docker compose down' EXIT


health_endpoint=$(curl -s http://localhost:8080/health)
if [ -z "$health_endpoint" ]; then
    echo "Error: Health endpoint is empty. The API service may not be running."
    exit 1
fi
status=$(echo "${health_endpoint}" | jq -r '.status')
users_endpoint=$(curl -s http://localhost:8080/users)
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

if [ "$user_count" -eq 0 ]; then
    echo "Error: No users found in the database."
    exit 1
fi
echo "Found $user_count users in the database."