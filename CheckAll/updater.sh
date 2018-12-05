####
for posv in $(ls /var/lib/jboss/acm/updates/pos*|grep "10.2.[2|3][8|9|0|1]");do rm -rf $posv;done
nohup /var/lib/jboss/acm/bin/download_updates.sh start &
####

