#!/bin/bash

# 下载并解压VNT客户端
wget https://github.com/vnt-dev/vnt/releases/download/1.2.16/vnt-x86_64-unknown-linux-musl-1.2.16.tar.gz
tar -zxvf vnt-x86_64-unknown-linux-musl-1.2.16.tar.gz
cd vnt-x86_64-unknown-linux-musl-1.2.16

# 创建一个服务文件
cat <<EOF > /etc/systemd/system/vnt-cli.service
[Unit]
Description=VNT CLI Service
After=network.target

[Service]
Type=simple
ExecStart=/root/vnt-cli -k 12345678 --cmd
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
