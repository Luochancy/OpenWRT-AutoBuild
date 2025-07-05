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

# BUILD_DATE=$(date +"%Y%m%d%H%M")
# sed -i "s/IMG_PREFIX:=openwrt/IMG_PREFIX:=LEDE/g" include/image.mk

# 更精确的替换，只替换文件名中的efi，而不是所有的efi
# sed -i "s/\(.*\)efi\(\.img\)/\1${BUILD_DATE}-efi\2/g" include/image.mk

# 修改固件版本信息 / Modify firmware version information
echo "🏷️ 修改固件版本信息 / Modifying firmware version information..."

# 方法1: 修改版本文件
if [ -f "package/base-files/files/etc/openwrt_release" ]; then
    sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION='OpenWRT-LEDE MINI 2025.v1 Compiled by Luochancy'/" package/base-files/files/etc/openwrt_release
fi

# 方法2: 通过修改 include/version.mk 来改变版本信息
if [ -f "include/version.mk" ]; then
    # 修改版本描述
    sed -i "s/RELEASE:=.*/RELEASE:=OpenWRT-LEDE MINI 2025.v1/" include/version.mk
    sed -i "s/VERSION_REPO:=.*/VERSION_REPO:=Compiled by Luochancy/" include/version.mk
fi

# 方法3: 直接在 package/base-files 中创建版本文件
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/openwrt_release << 'EOF'
DISTRIB_ID='OpenWrt'
DISTRIB_RELEASE='OpenWRT-LEDE MINI 2025.v1'
DISTRIB_REVISION='Compiled by Luochancy'
DISTRIB_TARGET='x86/64'
DISTRIB_ARCH='x86_64'
DISTRIB_DESCRIPTION='OpenWRT-LEDE MINI 2025.v1 Compiled by Luochancy'
DISTRIB_TAINTS=''
EOF

# 方法4: 修改 config/Config-build.in 中的默认版本
if [ -f "config/Config-build.in" ]; then
    sed -i 's/default ".*"/default "OpenWRT-LEDE MINI 2025.v1 Compiled by Luochancy"/' config/Config-build.in
fi

echo "✅ 固件版本信息修改完成 / Firmware version information modified"

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
