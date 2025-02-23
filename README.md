# vnt

# 定义目标目录 复制下面全部代码
TARGET_DIR="/root/vnt"

# 检查目录是否存在
if [ -d "$TARGET_DIR" ]; then
    echo "$TARGET_DIR 已存在，正在删除..."
    rm -rf "$TARGET_DIR"
fi

# 克隆仓库
if git clone https://github.com/huang3370/vnt.git; then
    echo "仓库克隆成功！"
else
    echo "仓库克隆失败，请检查网络连接或仓库地址。"
    exit 1
fi

# 修改脚本权限并执行安装脚本
chmod +x "$TARGET_DIR/install_vnt.sh" && "$TARGET_DIR/install_vnt.sh"
