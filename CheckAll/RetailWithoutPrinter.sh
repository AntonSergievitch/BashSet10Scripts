grep -L "No route to host" logs/*.log | xargs grep -l "Does not detect printer " | xargs grep -L "May be" | sed 's/logs\/\(.*\)\.log/\1/'|sort -g