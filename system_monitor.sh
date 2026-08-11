#!/bin/bash

# Clear file and rewrote header with date and time
echo "=== System Report ===" > report.txt
date '+%A %W %Y %X' >> report.txt
echo "" >> report.txt

## Adding top 5 processes by RAM consumption
echo "--- Top 5 RAM consuming processes ---" >> report.txt
ps aux | sort -nk 4 | tail -n 5 >> report.txt
echo "" >> report.txt

# Adding disk usage status
echo "--- Disk Usage ---" >> report.txt 
df -h >> report.txt
