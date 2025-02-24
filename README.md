                         一键代码。用不了说明你网络问题





[ -d vnt ] && { echo "Removing existing directory 'vnt'..."; rm -rf vnt; }
echo "Cloning repository..."
git clone https://github.com/huang3370/vnt.git && cd vnt && { 
    echo "Setting execute permissions for install_vnt.sh..."; 
    chmod +x install_vnt.sh; 
    echo "Running install_vnt.sh..."; 
    sudo ./install_vnt.sh; 
} || { 
    echo "Failed to clone the repository or run the installation script."; 
}
