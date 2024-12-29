#!/bin/bash

XML_FILE="/data/data/com.dragon.read/shared_prefs/applog_stats.xml"
TOML_FILE="/data/data/com.termux/files/home/fqnovel-api/wrangler.toml"

# 检查 XML 文件是否存在
if [ ! -f "$XML_FILE" ]; then
  echo "文件不存在: $XML_FILE"
  exit 1
fi

# 从 XML 文件中提取设备和安装 ID
device_id=$(grep '<string name="device_id">' "$XML_FILE" | sed 's/.*<string name="device_id">//;s/<\/string>//')
install_id=$(grep '<string name="install_id">' "$XML_FILE" | sed 's/.*<string name="install_id">//;s/<\/string>//')

# 输出获取的 ID
echo "Device ID: $device_id"
echo "Install ID: $install_id"

# 检查 TOML 文件并替换对应的值
if [ -f "$TOML_FILE" ]; then
  # 使用 sed 命令更新 TOML 文件中的 device_id 和 install_id
  sed -i "s/install_id = \".*\"/install_id = \"$install_id\"/" $TOML_FILE
  sed -i "s/server_device_id = \".*\"/server_device_id = \"$device_id\"/" $TOML_FILE
else
  echo "TOML 文件不存在: $TOML_FILE"
fi
