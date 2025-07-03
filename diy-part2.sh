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
# 替换生成文件名中的 efi
sed -i "s/efi/$(date +"%Y%m%d%H%M")-efi/g" include/image.mk

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
