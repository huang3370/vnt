#!/bin/bash

# 检查系统架构
arch=$(uname -m)
if [[ "$arch" != "x86_64" ]]; then
    echo "当前系统架构为 $arch，脚本仅支持 x86_64 架构的系统。"
    exit 1
fi

echo "系统架构检测通过，当前架构为 $arch。"

# 自定义参数
read -p "请输入组网号其实就是自己的密码尽量长一些(不能为空): " id
while [[ -z "$id" ]]; do
    echo "组网号不能为空，请重新输入。"
    read -p "请输入组网号其实就是自己的密码尽量长一些(不能为空): " id
done

read -p "请输入服务器地址使用官方服务器直接回车下一步(例如 -s空格8.8.8.8): " fwq

# 获取机器名称，确保以-n 开头且不为空
while true; do
    read -p "请输入机器名称 (例如-n pc，使用默认直接回车): " mz
    mz=${mz:-"-n default_machine"}  # 使用默认值
    if [[ -z "$mz" || "$mz" =~ ^[[:space:]]+$ || ! "$mz" =~ ^-n ]]; then
        echo "机器名称必须以 '-n' 开头且不能为空，请重新输入。"
    else
        break
    fi
done

# 设置下载链接和文件名称
url="https://github.com/vnt-dev/vnt/releases/download/v1.2.16/vnt-x86_64-unknown-linux-musl-v1.2.16.tar.gz"
file="vnt-x86_64-unknown-linux-musl-v1.2.16.tar.gz"
install_dir="/root/vnt"

# 检查并处理 VNT 文件夹
if [[ -d "$install_dir" ]]; then
    local size=$(du -k "$install_dir" | cut -f1)
    if (( size < 100 )); then
        echo "VNT 文件夹小于 100K，删除并重新下载..."
        rm -rf "$install_dir"
    else
        echo "VNT 文件夹大小合格，跳过下载。"
    fi
fi

# 创建安装目录
mkdir -p "$install_dir"

# 下载文件的函数
download_file() {
    while true; do
        if wget "$url" -O "$install_dir/$file"; then
            echo "下载成功。"
            return 0
        else
            echo "下载失败，请设置代理..."
            read -p "请输入代理地址 (例如 http://proxy:port): " proxy
            
            while true; do
                if wget -e use_proxy=yes -e http_proxy="$proxy" "$url" -O "$install_dir/$file"; then
                    echo "代理下载成功。"
                    return 0
                else
                    echo "代理下载失败，请重新输入代理地址..."
                    read -p "请输入代理地址 (例如 http://proxy:port): " proxy
                fi
            done
        fi
    done
}

# 检查文件是否已存在
if [ ! -f "$install_dir/$file" ]; then
    download_file
else
    echo "文件已存在，跳过下载。"
fi

# 解压文件
tar -xzvf "$install_dir/$file" -C "$install_dir"

# 创建 systemd 服务文件
service_file="/etc/systemd/system/vnt.service"
cat <<EOL > "$service_file"
[Unit]
Description=VNT Service
After=network.target

[Service]
ExecStart=/root/vnt/vnt-cli -k $id $mz $fwq
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL

# 重新加载 systemd 管理器配置
systemctl daemon-reload

# 启动服务并设置开机启动
systemctl start vnt.service
systemctl enable vnt.service

echo "安装完成，VNT 服务已设置为开机启动并正在运行。"
