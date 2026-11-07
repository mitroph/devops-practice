#!/bin/bash
set -uo pipefail

cd "$(dirname "$0")" || exit

# This script runs all scripts in this repository and checks each exit code. After all scripts have been run, it will print a summary of the results.

# Array of script names to run
scripts=("./challenge-app/run_and_test.sh" "./compose-practice/deploy.sh" "./db-app/test_db_persistence.sh" "./db-app/test_stack.sh" "./docker-builder/build_and_run.sh" "./dynamic-config/start_volume.sh" "./gateway-app/check_gateway.sh" "./file_checker.sh" "./system_monitor.sh")

declare -A scripts_exit_codes
declare -A expected=( ["./file_checker.sh"]=1 )

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
    scripts_exit_codes["$script"]=$exit_code
    echo "----------------------------------------"
done

# Printing summary of results
echo "----------------------------------------"
echo "Summary of results:"
for script in "${scripts[@]}"; do
    actual="${scripts_exit_codes[$script]}"
    want="${expected[$script]:-0}"  # Default expected exit code is 0 if not specified
    if [ "$actual" -ne "$want" ]; then
        echo -e "\e[0;91m[ERROR] \e[0;97m$script failed with exit code $actual (expected $want)"
    else
        echo -e "\e[0;92m[SUCCESS] \e[0;97m$script completed successfully with expected exit code $actual"
    fi
done
echo "----------------------------------------"

for script in "${scripts[@]}"; do
    actual="${scripts_exit_codes[$script]}"
    want="${expected[$script]:-0}"
    if [ "$actual" -ne "$want" ]; then
        echo -e "\e[0;91m[PROGRAM EXIT 1]\e[0;97m because one or more scripts failed. Please check the logs above for details."
        exit 1
    fi
done
