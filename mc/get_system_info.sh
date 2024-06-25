#!/bin/bash

# 获取当前日期和时间，格式为 YYYY-MM-DD_HH-MM-SS
current_date=$(date +"%Y-%m-%d_%H-%M-%S")
filename="system_info_$current_date.txt"

# 将信息写入文件
{
    echo "BIOS Information Address:"
    sudo dmidecode -t bios | grep "Address"

    echo "System Information UUID:"
    sudo dmidecode -s system-uuid

    echo "Processor Information ID:"
    sudo dmidecode -t processor | grep "ID"
} > "$filename"

echo "Information saved to $filename"
