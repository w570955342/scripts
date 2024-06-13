
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

# 错误基本上都是
# error updating meta: DB metadata not changed. database may already exist
# restore: DB metadata not changed. database may already exist