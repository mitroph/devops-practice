#!/bin/bash
set -x  # Enable strict Bash debug mode

docker build . -t api-service:1.0

# Run container in background and allow time for startup
docker run -d -p 8080:5000 --name test-api api-service:1.0
sleep 3

# Check container logs to ensure Flask started successfully
docker logs test-api

# Execute health check and print raw response
request=$(curl -s http://localhost:8080/health)
echo "RAW CURL RESPONSE: ${request}"

# Parse JSON fields using jq
status=$(echo "${request}" | jq -r '.status')
user=$(echo "${request}" | jq -r '.user')

set +x  # Disable debug mode for clean final output

if [ "${status}" == "healthy" ] && [ "${user}" != "root" ]; then
    echo -e "\033[32m[BUILD APPROVED]\033[0m"
else
    echo -e "\033[31m[BUILD REJECTED]\033[0m"
fi

docker rm -f test-api
