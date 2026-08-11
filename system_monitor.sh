echo "$(date '+%A %W %Y %X') $(ps aux | sort -nk +4 | tail -n 5) $(df -h)" > report.txt
