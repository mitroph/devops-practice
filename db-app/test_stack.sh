#!/bin/bash

docker-compose up -d

if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
fi

