#!/bin/bash
set -euo pipefail

trap 'docker compose down' EXIT
docker compose up up -d --wait db

docker exec db_app psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE TABLE IF NOT EXISTS test_table (id INT);"

docker compose down

docker compose up -d --wait db


check=$(docker exec db_app psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "\dt")

if echo "${check}" | grep -q "test_table"; then
    echo -e "\033[32m[PERSISTENCE SECURED]\033[0m"
else
    echo -e "\033[31m[PERSISTENCE FAILED]\033[0m"
    exit 1
fi

docker compose down

