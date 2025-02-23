# vnt

# 定义目标目录 复制下面全部代码
TARGET_DIR="/root/vnt"
if [ -d "$TARGET_DIR" ]; then
    echo "$TARGET_DIR 已存在，正在删除..."
    rm -rf "$TARGET_DIR"
fi

if git clone https://github.com/huang3370/vnt.git; then
    echo "仓库克隆成功！"
else
    echo "仓库克隆失败，请检查网络连接或仓库地址。"
    exit 1
fi

chmod +x "$TARGET_DIR/install_vnt.sh" && "$TARGET_DIR/install_vnt.sh"
