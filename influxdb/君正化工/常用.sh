
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

# docker复制文件
# 从容器复制文件到宿主机
docker cp my_container:/path/to/file /host/path

# 从宿主机复制文件到容器
docker cp /host/path/file my_container:/path/to

# 从容器复制目录到宿主机
docker cp my_container:/path/to/directory /host/path

# 从宿主机复制目录到容器
docker cp /host/path/directory my_container:/path/to

# scp传输文件

# 从本地复制到远程
# 将本地主机上的文件复制到远程主机：
scp local_file.txt user@remote_host:/remote/directory
scp tsdb_export.zip root@192.168.6.220:/opt/app/airiot/db/influxdb/import
scp tsdb_export.zip root@10.0.0.220:/opt/app/airiot/db/influxdb/import


rsync -avzP influx_inspect root@192.168.6.220:/opt/app/airiot/db/influxdb/import
rsync -avzP tsdb_export.zip root@192.168.6.220:/opt/app/airiot/db/influxdb/import
rsync -avzP tsdb_export.zip root@10.0.0.220:/opt/app/airiot/db/influxdb/import

# 将本地主机上的目录递归复制到远程主机：
scp -r /local/directory user@remote_host:/remote/directory

# 从远程复制到本地
# 将远程主机上的文件复制到本地主机：
scp user@remote_host:/remote/file.txt /local/directory

# 将远程主机上的目录递归复制到本地主机：
scp -r user@remote_host:/remote/directory /local/directory

# 在两台远程主机之间复制
scp user1@remote_host1:/remote/file.txt user2@remote_host2:/remote/directory

# 注意事项
# 在使用 scp 命令传输文件时，如果没有使用密钥对进行身份验证，
# 你将需要使用密码进行身份验证。通常情况下，
# scp 命令会提示你输入密码，并且密码输入时不会回显。


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

influxd restore -portable -db example_db /example_db

# 错误基本上都是
# error updating meta: DB metadata not changed. database may already exist
# restore: DB metadata not changed. database may already exist


# 在另外一台服务器导出
# influxd backup -host 192.168.1.100:8088 -username admin -password secretpassword /path/to/backup
# 上述命令不对，没有-username和-password选项
# 在airiot.tech的inlfux1容器，airiot.tech的influx容器暴露的端口是18088:8088，没有认证也备份成功了，并且还原到了influx1
influxd backup -host airiot.tech:18088 -portable -db example_db /example_db
./influxd.exe backup -portable -db example_db -host airiot.tech:18088  ./example_db

influxd restore -portable -db example_db /example_db

setx INFLUX_USERNAME "admin"
setx INFLUX_PASSWORD "dell123"

export INFLUX_USERNAME=backup_user
export INFLUX_PASSWORD=secretpassword



# 测试指令
influx_inspect export -database tsdb -out /var/lib/influxdb/export/tsdb_export.txt -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal
influx_inspect export -compress -database 625f6dbf5433487131f09ff7 -out /var/lib/influxdb/export/625f6dbf5433487131f09ff7_export.tar.gz -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal

influx -import -path=/var/lib/influxdb/export/625f6dbf5433487131f09ff7_export.txt -database=tsdb -username=admin -password=dell123
influx -import -path=/var/lib/influxdb/export/625f6dbf5433487131f09ff7_xiuzheng_export.txt  -database=tsdb -username=admin -password=dell123

# 正式指令
# 注意事项
# 导出的数据就是一个文件，需要vi删除文件头部的注释和创建数据库信息，因为执行文件会解析这些
# influx要使用超哥手动编译的执行文件，可以指定数据库（原来的数据库信息从文件的注释信息里取的），必须加上-dataonly参数，也是单独加的参数
# 执行文件就是目录下的文件

# 不压缩
influx_inspect export -database tsdb -out /var/lib/influxdb/export/tsdb_export.txt -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal

# 压缩
influx_inspect export -compress -database tsdb -out /var/lib/influxdb/export/tsdb_export.txt.zip -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal

# 客户平台data目录164G，压缩格式导出，用了15个小时，文件153G。


# 还原
influx -dataonly -import -path=/var/lib/influxdb/export/tsdb_export.txt -database=tsdb -username=admin -password=dell123



tar -czvf tsdb_export.tar.gz tsdb_export.txt


# 用自己编译的influx_inspect
#  -ignores string
#    	忽略的表名列表. 多个表名之间使用 ',' 分隔
#  -lponly
#    	Only export line protocol
#  -mapping string
#    	表名映射文件. 每行对应一个映射关系, 格式为: 原始表名=映射后表名

# 测试
# 库名 625f6dbf5433487131f09ff7
# 表名
  #测试名称
  #测试普通表
  #测试设备地址空
  #绑定系统变量
  #网络检查
  #网络检查新
  #网络检查继承

./influx_inspect export -compress  -lponly -ignores 测试名称,测试普通表 -mapping map.txt -database 625f6dbf5433487131f09ff7 -out /var/lib/influxdb/export/625f6dbf5433487131f09ff7_export.zip -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal

nohup ./influx_inspect export -compress  -lponly -ignores 测试名称,测试普通表 -mapping map.txt -database 625f6dbf5433487131f09ff7 -out /var/lib/influxdb/export/625f6dbf5433487131f09ff7_export.zip -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal >> export.log 2>&1 &

# 还原
nohup ./influx -dataonly -compressed -import -path=/var/lib/influxdb/export/625f6dbf5433487131f09ff7_export.zip -database=tsdb -username=admin -password=dell123 >> import.log 2>&1 &


# 正式环境
nohup ./influx_inspect export -compress  -lponly  -mapping map.txt -database tsdb -out /var/lib/influxdb/export/tsdb_export.zip -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal >> export.log 2>&1 &

# 还原
nohup ./influx -dataonly -compressed -import -path=/var/lib/influxdb/import/tsdb_export.zip -database=default -username=admin -password=dell123 >> import.log 2>&1 &


#使用 yumdownloader --resolve 在联网机器上下载 rsync 及其依赖项。
#将 RPM 包传输到离线机器上。
#使用 yum localinstall 在离线机器上安装 rsync 包。
#
#sudo yum install yum-utils
#sudo yumdownloader --resolve rsync
#
#sudo yum localinstall *.rpm


# 444G
# 导出41小时
# 还原97小时
# 开始时间：Oct 16 18:41 import.log
# 结束时间：Oct 20 20:09 import.log
