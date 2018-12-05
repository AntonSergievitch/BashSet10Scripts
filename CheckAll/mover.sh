user=root
password=324012

rm -rf logs/*.log
runner(){
counter=0;
while ( ping -c 1 -W 1 $1 | grep -q "0 received" ) do sleep 5;let counter=counter+1; [ $counter -gt 85 ] && break ;echo $1 Connection timed out >logs/$1.log; done
nohup sshpass -p $password ssh -o StrictHostKeyChecking=no $user@$1 'bash -s'  >logs/$1.log <commands.sh
}

for host in $( cat hosts.lst ) ; do
#echo $host
runner "$host" &
done
