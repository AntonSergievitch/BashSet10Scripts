export PGPASSWORD=postgres

runner(){
mkdir -pv "diff/$1"
for nm in cards cash catalog discount user;do 
pg_dump -h $1 -U postgres -s -f diff/"$1"/"$nm"_10.2.45.1.sql $nm
sleep 1
sed -i "s/;$/;\n\n\n\n\n\n/g;/IS '/{:a;N;N;N;N;N;N;/';/s/\n//g;s/'\([^;]*\);\([^;]*\)'/'\1<SeMiCoLoN>\2'/g;};s/COMMENT ON COLUMN /--COMMENT ON COLUMN/g;/^--/d;" diff/"$1"/"$nm"_10.2.45.1.sql
sed -i "/^$/d" diff/"$1"/"$nm"_10.2.45.1.sql
sleep 1
java -jar apgdiff-2.5.0.20160618.jar  --ignore-start-with diff/"$1"/"$nm"_10.2.45.1.sql "$nm"_10.2.45.1.sql > diff/"$1"/"$nm"_10.2.45.1.diff.sql 2>diff/"$1"/"$nm"_10.2.45.1.diff.err
sed -i "/^$/d" diff/"$1"/"$nm"_10.2.45.1.diff.sql 
psql -h $1 -U postgres -d $nm -f  diff/"$1"/"$nm"_10.2.45.1.diff.sql > diff/"$1"/"$nm"_10.2.45.1.diff.sql.log 2>diff/"$1"/"$nm"_10.2.45.1.diff.sql.err
done
}

for ip in $(cat cash_ip.lst);do
runner $ip &
done