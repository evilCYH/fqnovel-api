#!/bin/bash

XML_FILE="/data/data/com.dragon.read/shared_prefs/applog_stats.xml"
TOML_FILE="/data/data/com.termux/files/home/fqnovel-api/wrangler.toml"
REPO_DIR="/data/data/com.termux/files/home/fqnovel-api/"
export PATH=/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets:$PATH

# 切换到仓库目录
cd $REPO_DIR
git pull

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

  # 检查 Git 是否有文件更改
  git diff --exit-code $TOML_FILE
  if [ $? -ne 0 ]; then
    # 如果有更改，提交并推送
    git add $TOML_FILE
    git commit -m "Update IDs in wrangler.toml"
    git push origin master
  else
    echo "没有检测到 ID 的更改，不进行 Git 操作。"
  fi
else
  echo "TOML 文件不存在: $TOML_FILE"
fi

LOG_FILE="/data/data/com.termux/files/home/fq.log"
MAX_SIZE=10485760  # 10MB

# 获取当前日志大小
FILE_SIZE=$(stat -c%s "$LOG_FILE" 2>/dev/null)

if [ -n "$FILE_SIZE" ] && [ $FILE_SIZE -ge $MAX_SIZE ]; then
  #压缩也可以旧日志
  tar zcf "$LOG_FILE.$(date +%Y%m%d%H%M%S).tar.gz" "$LOG_FILE" && rm "$LOG_FILE"
  # 创建新日志文件
  touch "$LOG_FILE"
fi