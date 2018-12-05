psql -h 10.181.0.7 -U postgres -d set -t -c 'select shop_ip from topology_shop'|sed '/^$/d'|awk '{print $1}'|sort|uniq
