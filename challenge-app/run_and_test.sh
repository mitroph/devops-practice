#!/bin/bash

# Running our 2 services be docker-compose
docker-compose up -d

echo "[INFO] Started up of services"

sleep 3

# Request to the backend service
auth=$(curl -s -H "Accept: application/json" http://localhost:8082/api.json | jq -r '.module')


if [ "${auth}" == "auth" ]; then
    
    # In case of we've got response "auth" from backend service
    echo "[SUCCESS] Microservices are up!"

else
    # In case of we haven't got right response
    echo "[FAIL] Wrong API response"
    
    docker-compose down
fi

