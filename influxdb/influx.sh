#!/usr/bin/env bash

influx_dir=/tmp/influx_backup/
date_dir=/opt/wbb/influxbak/date.txt

# 2015-12-24T08:12:23Z
#start_time=`date -d "24 hour ago" --rfc-3339=seconds`

function error_exit {
  echo "$1" 1>&2
  exit 1
}

# 数据库存的时间可以理解成时间戳，查询的时候不指定时区，默认返回的时间是0时区的，所以最新时间比东八区的当前时间慢8小时
# 备份的时候不能指定时区，只能传0时区的时间，所以当前时间需要减去8小时
# 如果没有date.txt文件，那么默认同步两天前到现在的数据，如果有，起始时间就用date.txt里的
# SELECT * FROM "60b5d063e74fd60a17426745_60b845acb839cbf5260676ac" order by time desc limit 10 tz('Asia/Shanghai')
if test -e "$date_dir"
then
   start_time=`cat $date_dir`
else
#   start_time="1991-10-14T18:12:35Z"
   start_time=`date -d "56 hour ago" +%FT%TZ`
fi
end_time=`date -d "8 hour ago" +%FT%TZ`
#ssh_host=root@iot.htkjbjf.com
ssh_host=root@airiot.tech

influx_container_local=influx2
influx_container_remote=influx2

#docker exec $influx_container_local influxd backup -portable  -db tsdb  -start 2021-03-13T00:24:52.085243953Z  -end 2021-03-13T23:59:52.085243953Z  $influx_today
docker exec $influx_container_local influxd backup -portable  -db tsdb  -start $start_time -end $end_time  $influx_dir || error_exit "$LINENO: failed"
docker cp $influx_container_local:$influx_dir $influx_dir || error_exit "$LINENO: failed"
docker exec $influx_container_local rm -rf $influx_dir || error_exit "$LINENO: failed"
scp -r $influx_dir $ssh_host:$influx_dir || error_exit "$LINENO: failed"
rm -rf $influx_dir || error_exit "$LINENO: failed"

ssh $ssh_host "docker cp $influx_dir $influx_container_remote:$influx_dir" || error_exit "$LINENO: failed"
ssh $ssh_host "rm -rf $influx_dir" || error_exit "$LINENO: failed"
ssh $ssh_host "docker exec $influx_container_remote influxd restore -portable  -db tsdb -newdb tmp $influx_dir" || error_exit "$LINENO: failed"
ssh $ssh_host "docker exec $influx_container_remote rm -rf $influx_dir" || error_exit "$LINENO: failed"
ssh $ssh_host "docker exec $influx_container_remote influx -database tmp -username admin -password dell123 -execute 'SELECT * INTO tsdb..:MEASUREMENT FROM /.*/ GROUP BY *'" || error_exit "$LINENO: failed"
ssh $ssh_host "docker exec $influx_container_remote influx -username admin -password dell123 -execute 'drop database tmp'" || error_exit "$LINENO: failed"

echo $end_time > $date_dir