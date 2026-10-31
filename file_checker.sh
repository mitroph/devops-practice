#!/bin/bash

files=("config.xml" "data.json" "secret.key")

exist_counter=1
missing_counter=1

for file in "${files[@]}"; do

    if [ -f "$file" ]; then
	echo "[OK] $file is file number $exist_counter that exists"
        ((exist_counter++))
    else
	echo -e "[FAILED] $file is file number $missing_counter is \033[0;31m MISSING\033[0m"
        ((missing_counter++))
    fi
done
