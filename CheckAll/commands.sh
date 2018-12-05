chmod -x /root/set10install.sh
sed -i '/set10install/ d' /var/spool/cron/*
mkdir -p /var/lib/jboss/acm/list;touch /var/lib/jboss/acm/list/download.lst /var/lib/jboss/acm/list/active.lst
[ $(ls /etc/yum.repos.d|grep -c "") -gt 4 ] && rm -rf /etc/yum.repos.d/* && echo -e "[os]\nname=master - Base\nbaseurl=http://10.181.0.12/CentOS/7/\ngpgcheck=0" > /etc/yum.repos.d/local.repo && yum update
/usr/bin/which 7za &>/dev/null || yum install -y p7zip
[ $(grep rvhisp /var/spool/cron/root|wc -l) -gt 1 ] && sed -i '/rvhisp/d' /var/spool/cron/root
[ $(grep delete_old_files /var/spool/cron/root|wc -l) -gt 1 ] && sed -i '/delete_old_files/d' /var/spool/cron/root
[ $(grep download_updates /var/spool/cron/jboss|wc -l) -gt 1 ] && sed -i '/download_updates/d' /var/spool/cron/jboss
[ ! -f /var/lib/jboss/acm/bin/download_updates.sh ] && ( echo No script 4 download updates\! Downloading... && wget -q http://10.181.0.12/download_updates.sh -O /var/lib/jboss/acm/bin/download_updates.sh && chmod +x /var/lib/jboss/acm/bin/download_updates.sh )
[ ! -f /var/lib/jboss/acm/bin/rvhisp.sh ] && ( echo No script 4 Reboot ESXi\! Downloading... && wget -q http://10.181.0.12/rvhisp.sh -O /var/lib/jboss/acm/bin/rvhisp.sh && chmod +x /var/lib/jboss/acm/bin/rvhisp.sh )
[ ! -f /var/lib/jboss/acm/bin/update_cash.sh ] && ( echo No script 4 update cashes\! Downloading... && wget -q http://10.181.0.12/update_cash.sh -O /var/lib/jboss/acm/bin/update_cash.sh && chmod +x /var/lib/jboss/acm/bin/update_cash.sh )
[ ! -f /var/lib/jboss/acm/bin/update_lst.sh ] && ( echo No script 4 update server\! Downloading... && wget -q http://10.181.0.12/update_lst.sh -O /var/lib/jboss/acm/bin/update_lst.sh && chmod +x /var/lib/jboss/acm/bin/update_lst.sh )
grep -q "#Ver.20161114" /var/lib/jboss/acm/bin/update_lst.sh || ( echo Old version of script 4 update server\! Updating... && wget -q http://10.181.0.12/update_lst.sh -O /var/lib/jboss/acm/bin/update_lst.sh )
grep -q "#Ver.20170425" /var/lib/jboss/acm/bin/update_srv.sh || ( echo Old version of script 4 update server\! Updating... && wget -q http://10.181.0.12/update_srv.sh -O /var/lib/jboss/acm/bin/update_srv.sh )
grep -q "#Ver.20170514" /var/lib/jboss/acm/bin/download_updates.sh || ( echo Old version of script 4 download updates\! Updating... && wget -q http://10.181.0.12/download_updates.sh -O /var/lib/jboss/acm/bin/download_updates.sh )
[ ! -f /var/lib/jboss/delete_old_files.sh ] && ( echo No script 4 remove old files\! Downloading... && wget -q http://10.181.0.12/delete_old_files.sh -O /var/lib/jboss/delete_old_files.sh && chmod +x /var/lib/jboss/delete_old_files.sh )
grep -q \/var\/lib\/jboss\/delete_old_files.sh /var/spool/cron/root || ( echo No schedule 4 remove old files\! Adding it! && echo 0 4 \* \* \* /var/lib/jboss/delete_old_files.sh >> /var/spool/cron/root )
grep -q \/var\/lib\/jboss\/acm\/bin\/rvhisp.sh /var/spool/cron/root || ( echo No schedule 4 reboot ESXi\! && echo 0 4 \* \* \* /var/lib/jboss/acm/bin/rvhisp.sh >> /var/spool/cron/root )
grep -q "\/var\/lib\/jboss\/acm\/bin\/download_updates.sh start" /var/spool/cron/jboss || ( echo No schedule 4 download updates\! && echo 0 23 \* \* \* /var/lib/jboss/acm/bin/download_updates.sh start >> /var/spool/cron/jboss )
truncate -s 0 /var/lib/jboss/acm/list/download.lst
md5sum /var/lib/jboss/acm/mook.jar|grep -q 274a7bd0fe8012ce1d249f9b67c5f831 && echo New Mook\! || echo Old Mook\!
[ ! -f /etc/cups/cupsd.conf ] && echo Cups not installed\! || grep DeviceURI /etc/cups/printers.conf|grep -q dev\/nul && echo Does not detect printer URI\! || echo Printer detected\!
grep DeviceURI /etc/cups/printers.conf

stat /var/lib/jboss/cards | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}'| grep -q '0777' || chmod 777 /var/lib/jboss/cards
stat /var/lib/jboss/cashiers | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}'| grep -q '0777' || chmod 777 /var/lib/jboss/cashiers
stat /var/lib/jboss/products | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}'| grep -q '0777' || chmod 777 /var/lib/jboss/products
stat /var/lib/jboss/reports | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}'| grep -q '0777' || chmod 777 /var/lib/jboss/reports
stat /var/lib/jboss/discounts | sed -n '/^Access: (/{s/Access: (\([0-9]\+\).*$/\1/;p}'| grep -q '0777' || chmod 777 /var/lib/jboss/discounts

[ -f /etc/cups/printers.conf ] && ipprefix=$(ifconfig eth0|grep "inet "|sed -e 's/.*inet \([^.]*\)\.\([^.]*\)\.\([^.]*\)\..*/\1.\2.\3./')
[ -f /etc/cups/printers.conf ] && grep DeviceURI /etc/cups/printers.conf|grep -q dev\/nul && for i in $(echo 5 ) ; do wget $ipprefix$i -O - -q|grep "<title>"|sed 's/&nbsp;/ /g'|sed 's/.*>\(.*\)<.*/May be this printer: \1/'; done
#for i in $(echo 5 6 160 161 162)
/var/lib/jboss/acm/bin/update_lst.sh 10.99.99.99
/var/lib/jboss/acm/bin/update_cash.sh 10.99.99.99
echo Download list contain: $(cat /var/lib/jboss/acm/list/download.lst /var/lib/jboss/acm/list/active.lst /var/lib/jboss/acm/list/error.lst |wc -l) file\(s\). Last file start downloading at $(grep http:// /var/lib/jboss/acm/logs/wget_thread1.log |tail -n 1| sed 's/--\(.*\)--.*/\1/g').
psql -h localhost -U postgres -t -d set -c "select 'Shop '|| a.number || ' name '||b.name ||', URL=' ||b.value from topology_shop a join service_provider_settings b on (TRUE=TRUE) join service_provider c on c.id=b.provider join service_type d on d.id=c.service_type where d.name='egais'"
psql -h localhost -U postgres -t -d set -c "select distinct 'FiscalPrinter=',hardwarename,fwversion from cash_cash where status='ACTIVE';"
echo -e "Free space $(df -BM /|tail -n 1| awk '{ print $4 }'|sed 's/M//') Mb, it's $(df -BM /|tail -n 1| awk '{ print $5 }'|sed 's/%//') percent."
[ $(df -BM /|tail -n 1| awk '{ print $4 }'|sed 's/M//') -gt 4000 ] || echo Recomended clear old files \& backups\!
page_size=`getconf PAGE_SIZE`
phys_pages=`getconf _PHYS_PAGES`
shmall=`expr $phys_pages / 2`
shmmax=`expr $shmall \* $page_size`
[ $(echo $(sysctl -b kernel.shmmax) - $shmmax|bc) -eq 0 ] || echo recomended kernel.shmmax = $shmmax, configured $(sysctl -b kernel.shmmax), to configure "use sysctl -w kernel.shmmax=$shmmax"
[ $(echo $(sysctl -b kernel.shmall) - $shmall|bc) -eq 0 ] || echo recomended kernel.shmall = $shmall, configured $(sysctl -b kernel.shmall), to configure "use sysctl -w kernel.shmmax=$shmall"
[ $(echo $(sysctl -b kernel.shmmax)/$(getconf PAGE_SIZE)-$(sysctl -b kernel.shmall)|bc) != 0 ] && echo Changing kernel.shmmax \& kernel.shmall settings\!
[ $(echo $(sysctl -b kernel.shmmax) - $shmmax|bc) -eq 0 ] || sysctl -w kernel.shmmax=$shmmax
[ $(echo $(sysctl -b kernel.shmall) - $shmall|bc) -eq 0 ] || sysctl -w kernel.shmall=$shmall
grep jboss /etc/security/limits.conf
cat /etc/security/limits.d/90-jboss.conf
grep file-max /etc/sysctl.conf
sysctl fs.file-max
grep -hE "IPADDR0|GATEWAY0" /etc/sysconfig/network-scripts/ifcfg-*
chown -R jboss:users /var/lib/jboss
