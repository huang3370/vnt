#!/bin/bash

# 定义文件名
FILE_NAME="vnt-x86_64-unknown-linux-musl-1.2.16.tar.gz"
DIRECTORY_NAME="vnt-x86_64-unknown-linux-musl-1.2.16"

# 检查文件是否已存在
if [ -f "$FILE_NAME" ]; then
    echo "$FILE_NAME 已存在，跳过下载步骤。"
else
    # 下载并解压VNT客户端
    wget https://github.com/vnt-dev/vnt/releases/download/1.2.16/$FILE_NAME
fi

# 检查解压后的目录是否存在
if [ ! -d "$DIRECTORY_NAME" ]; then
    tar -zxvf $FILE_NAME
fi

cd $DIRECTORY_NAME

# 提示用户输入自定义参数
echo "直接输入组网号："
read id
echo "输入-s空格IP:端口使用官方服务器直接回车下一步："
read fwq

# 创建一个服务文件
cat <<EOF > /etc/systemd/system/vnt-cli.service
[Unit]
Description=VNT CLI Service
After=network.target

[Service]
Type=simple
ExecStart=/root/vnt-cli -k $id $fwq --cmd

Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

# 重新加载systemd配置
systemctl daemon-reload

# 启用并启动服务
systemctl enable vnt-cli.service
systemctl start vnt-cli.service

echo "VNT客户端安装并设置开机自启动完成！"
