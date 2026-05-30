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
# sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
# sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

echo "Modifying firmware version information..."

if [ -f "package/base-files/files/etc/openwrt_release" ]; then
    sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION='ImmortalWrt 24.10.5 MINI 2025.v1 Compiled by Luochancy'/" package/base-files/files/etc/openwrt_release
fi

if [ -f "include/version.mk" ]; then
    sed -i "s/RELEASE:=.*/RELEASE:=ImmortalWrt 24.10.5 MINI 2025.v1/" include/version.mk
    sed -i "s/VERSION_REPO:=.*/VERSION_REPO:=Compiled by Luochancy/" include/version.mk
fi

mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/openwrt_release << 'EOF'
DISTRIB_ID='ImmortalWrt'
DISTRIB_RELEASE='ImmortalWrt 24.10.5 MINI 2025.v1'
DISTRIB_REVISION='Compiled by Luochancy'
DISTRIB_TARGET='x86/64'
DISTRIB_ARCH='x86_64'
DISTRIB_DESCRIPTION='ImmortalWrt 24.10.5 MINI 2025.v1 Compiled by Luochancy'
DISTRIB_TAINTS=''
EOF

if [ -f "config/Config-build.in" ]; then
    sed -i 's/default ".*"/default "ImmortalWrt 24.10.5 MINI 2025.v1 Compiled by Luochancy"/' config/Config-build.in
fi

echo "Firmware version information modified."

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

# Leave root password empty for first-boot lab images.
# Set a password immediately after flashing if this image touches an untrusted network.
sed -i 's/^root:[^:]*:/root::/' package/base-files/files/etc/shadow

echo "Using official ImmortalWrt x86 sysupgrade support."

# Fix Rust LLVM download 404 - build from source instead
sed -i 's/--set=llvm.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' feeds/packages/lang/rust/Makefile
