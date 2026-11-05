#!/bin/bash
set -euo pipefail

# Clear file and rewrote header with date and time
{
    echo "=== System Report ==="
    date '+%F %X'
    echo ""
    echo "--- Top 5 RAM consuming processes ---"
    ps aux | sort -nk 4 | tail -n 5
    echo ""
    echo "--- Disk Usage ---"
    df -h
} >> report.txt

