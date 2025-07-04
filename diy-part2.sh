#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

BUILD_DATE=$(date +"%Y%m%d%H%M")
sed -i "s/IMG_PREFIX:=openwrt/IMG_PREFIX:=LEDE/g" include/image.mk

# 更精确的替换，只替换文件名中的efi，而不是所有的efi
sed -i "s/\(.*\)efi\(\.img\)/\1${BUILD_DATE}-efi\2/g" include/image.mk

sed -i 's/192.168.1.1/10.0.100.1/g' package/base-files/files/bin/config_generate

cat > package/base-files/files/etc/banner << "EOF"
 _                      _                            
| |                    | |                           
| |    _   _  ___   ___| |__   __ _ _ __   ___ _   _ 
| |   | | | |/ _ \ / __| '_ \ / _` | '_ \ / __| | | |
| |___| |_| | (_) | (__| | | | (_| | | | | (__| |_| |
\_____/\__,_|\___/ \___|_| |_|\__,_|_| |_|\___|\__, |
                                                __/ |
                                               |___/ 
EOF

sed -i 's/^root:[^:]*:/root::/' package/base-files/files/etc/shadow

# 确保 sysupgrade 脚本存在
echo "配置 sysupgrade 支持..."

# 创建必要的目录
mkdir -p package/base-files/files/lib/upgrade

# 添加 sysupgrade 验证脚本
cat > package/base-files/files/lib/upgrade/platform.sh << 'EOF'
#!/bin/sh

platform_check_image() {
    return 0
}

platform_do_upgrade() {
    default_do_upgrade "$1"
}

platform_copy_config() {
    return 0
}
EOF

chmod +x package/base-files/files/lib/upgrade/platform.sh

echo "sysupgrade 配置完成"
