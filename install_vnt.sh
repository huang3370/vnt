
#!/bin/bash

# 下载并解压VNT客户端
wget https://github.com/vnt-dev/vnt/releases/download/1.2.16/vnt-x86_64-unknown-linux-musl-1.2.16.tar.gz
tar -zxvf vnt-x86_64-unknown-linux-musl-1.2.16.tar.gz
cd vnt-x86_64-unknown-linux-musl-1.2.16

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
