#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

docker compose down -v

trap 'docker compose down' EXIT
docker compose up -d --wait db

docker compose exec db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE TABLE IF NOT EXISTS test_table (id INT);"'

docker compose down -v

docker compose up -d --wait db


check=$(docker exec db_app sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "\dt"')

if echo "${check}" | grep -q "test_table"; then
    echo -e "\033[32m[PERSISTENCE SECURED]\033[0m"
else
    echo -e "\033[31m[PERSISTENCE FAILED]\033[0m"
    exit 1
fi

docker compose down -v

