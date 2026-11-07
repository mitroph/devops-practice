#!/bin/bash
set -uo pipefail

cd "$(dirname "$0")" || exit

# This script runs all scripts in this repository and checks each exit code. After all scripts have been run, it will print a summary of the results.

# Array of script names to run
scripts=("./challenge-app/run_and_test.sh" "./compose-practice/deploy.sh" "./db-app/test_db_persistence.sh" "./db-app/test_stack.sh" "./docker-builder/build_and_run.sh" "./dynamic-config/start_volume.sh" "./gateway-app/check_gateway.sh" "./file_checker.sh" "./system_monitor.sh")

declare -A scrits_exit_codes

# For each script, run it and check the exit code
for script in "${scripts[@]}"; do
    echo "----------------------------------------"
    echo -e "\e[1;94m Running \e[1;97m $script... \e[0;37m"
    echo "----------------------------------------"

    bash "$script"

    exit_code=$?

    echo "----------------------------------------"
    if [ "$exit_code" -ne 0 ]; then
        echo -e "\e[0;91m[ERROR] \e[0;97m$script failed with exit code $exit_code"
    else
        echo -e "\e[0;92m[SUCCESS] \e[0;97m$script completed successfully"
    fi
    scrits_exit_codes["$script"]=$exit_code
    echo "----------------------------------------"
done

# Printing summary of results
echo "----------------------------------------"
echo "Summary of results:"
for script in "${!scrits_exit_codes[@]}"; do
    exit_code=${scrits_exit_codes[$script]}
    if [ "$exit_code" -ne 0 ] || [[ "$script" = "./file_checker.sh" && "$exit_code" -ne 1 ]]; then
        echo -e "\e[0;91m[ERROR] \e[0;97m$script failed with exit code $exit_code"
    else
        echo -e "\e[0;92m[SUCCESS] \e[0;97m$script completed successfully with exit code $exit_code"
    fi
done
echo "----------------------------------------"
