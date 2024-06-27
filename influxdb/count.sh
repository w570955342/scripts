#!/bin/bash

# InfluxDB 配置
INFLUX_HOST="localhost"
INFLUX_PORT="8086"
INFLUX_DB="tsdb"
INFLUX_USER="admin"  # 实际的用户名
INFLUX_PASSWORD=""  # 初始化密码为空

# 提示用户输入密码
read -s -p "Enter password for InfluxDB user $INFLUX_USER: " INFLUX_PASSWORD
echo

# 输出文件
OUTPUT_FILE="measurement_record_counts.txt"

# 清空输出文件
> $OUTPUT_FILE

# 获取所有 measurement 列表
measurements=$(influx -host $INFLUX_HOST -port $INFLUX_PORT -username $INFLUX_USER -password "$INFLUX_PASSWORD" -database $INFLUX_DB -execute 'SHOW MEASUREMENTS' -format csv | tail -n +2)

# 循环处理每个 measurement
for measurement_with_prefix in $measurements; do
    # 提取 measurement 名称，去除前缀 measurements,
    measurement=$(echo $measurement_with_prefix | sed 's/^measurements,//')

    # 构建查询语句
# 不能count tag 只能是field
#    query="SELECT COUNT(*) FROM \"$measurement\""
    query="SELECT COUNT(online) FROM \"$measurement\""

    # 输出调试日志
    echo "执行查询: $query"

    # 执行查询并将结果追加到文件
    influx -host $INFLUX_HOST -port $INFLUX_PORT -username $INFLUX_USER -password "$INFLUX_PASSWORD" -database $INFLUX_DB -execute "$query" >> $OUTPUT_FILE
done

echo "查询完成，结果已保存到 $OUTPUT_FILE 文件中。"
