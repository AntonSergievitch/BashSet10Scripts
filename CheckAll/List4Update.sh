grep -iL "Current server version is 10.2.27.1 with" logs/*.log|sed "s/.*\/\(.*\)\.log/\1/g"
