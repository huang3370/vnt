#vnt

TARGET_DIR="/root/vnt"; [ -d "$TARGET_DIR" ] && echo "$TARGET_DIR 已存在，正在删除..." && rm -rf "$TARGET_DIR"; git clone https://github.com/huang3370/vnt.git && echo "仓库克隆成功！" || { echo "仓库克隆失败，请检查网络连接或仓库地址。" && exit 1; }; chmod +x "$TARGET_DIR/install_vnt.sh" && "$TARGET_DIR/install_vnt.sh"
