#!/usr/bin/env bash

today=`date +%Y%m%d`
yesterday=`date -d "yesterday" +%Y%m%d`
mongo_today=$(pwd)/mongodb-$today.tar.gz
mongo_yesterday=$(pwd)/mongodb-$yesterday.tar.gz
mongo_container=mongo1
mongo_dir=/tmp/mongo_data
mongo_today=/tmp/mongodb-$today.tar.gz
host_remote=192.168.124.65:27017

docker exec $mongo_container rm -rf $mongo_dir
docker exec $mongo_container rm -rf $mongo_today
docker exec $mongo_container mongodump -u=root -p=dell123 -o $mongo_dir
docker exec $mongo_container mongorestore -h $host_remote  --drop $mongo_dir  -u=root -p=dell123 --authenticationDatabase=admin
docker exec $mongo_container tar czf $mongo_today $mongo_dir

docker cp $mongo_container:$mongo_today .

docker exec $mongo_container rm -rf $mongo_dir
docker exec $mongo_container rm -rf $mongo_today


if test -e "$mongo_yesterday";then
   rm $mongo_yesterday
fi
