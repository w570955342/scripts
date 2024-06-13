
# 连接
docker exec -it influx sh
influx
auth
admin
dell123
use tsdb
show databases
show measurements
drop database tsdb

# 假设数据库有tsdb和tmp两个数据库
# 备份可以指定数据库，或者全部
# 全部
influxd backup -portable  /backup/all
# 指定tsdb数据库
influxd backup -portable -db tsdb /backup/tsdb

# 还原默认还原全部，可以指定数据库，可以重命名(指定的数据库，原始文件里必须有，没有的话报错)
# 全部(如果存在某一个数据库，当前的influx包含备份文件里的任意一个数据库，比如tsdb和tmp任意一个，则报错)
influxd restore -portable  /backup/all

# 指定tsdb(如果当前的influx存在tsdb库，则报错)
influxd restore -portable -db tsdb /backup/all

# 指定tsdb并且重命名为abc
influxd restore -portable -db tsdb -newdb abc /backup/all

# 错误基本上都是
# error updating meta: DB metadata not changed. database may already exist
# restore: DB metadata not changed. database may already exist