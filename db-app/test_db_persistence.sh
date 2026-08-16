#!/bin/bash

docker-compose up -d

if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
fi


sleep 10


docker exec db_app psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE TABLE IF NOT EXISTS test_table (id INT);"

docker-compose down

docker-compose up -d

sleep 5

check=$(docker exec db_app psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dt")

if echo "${check}" | grep -q "test_table"; then
    echo -e "\033[32m[PERSISTENCE SECURED]\033[0m"
else
    echo -e "\033[31m[PERSISTENCE FAILED]\033[0m"
fi

docker-compose down
 
