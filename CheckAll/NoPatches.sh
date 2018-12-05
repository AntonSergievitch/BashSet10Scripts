#grep -iL "patches after version 10.2.30.2 for" logs/*.log|sed "s/.*\/\(.*\)\.log/\1/g"
echo Servers patches:
grep -iL "version 10.2.30.2 for retail" logs/*.log|sed "s/.*\/\(.*\)\.log/\1/g"
echo Cash patches:
grep -iL "version 10.2.30.2 for cash" logs/*.log|sed "s/.*\/\(.*\)\.log/\1/g"
echo Count servers without server patches: $(grep -iL "version 10.2.30.2 for retail" logs/*.log|grep -c ""), count server without cash patches: $(grep -iL "version 10.2.30.2 for cash" logs/*.log|grep -c "")