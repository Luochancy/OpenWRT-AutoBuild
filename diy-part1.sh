#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 固定 kernel 版本到 6.6.86~af351158cfb5febf5155a3aa53785982-r1
echo "正在固定 kernel 版本到 6.6.86..."

# 方法1: 通过修改 target/linux/generic/Makefile 固定版本
if [ -f "target/linux/generic/Makefile" ]; then
    echo "修改 target/linux/generic/Makefile 中的 kernel 版本..."
    # 备份原文件
    cp target/linux/generic/Makefile target/linux/generic/Makefile.bak
    
    # 替换 kernel 版本相关配置
    sed -i 's/LINUX_KERNEL_HASH-6.6.*/LINUX_KERNEL_HASH-6.6.86 = af351158cfb5febf5155a3aa53785982/' target/linux/generic/Makefile
    sed -i 's/LINUX_VERSION-6.6 = 6.6.*/LINUX_VERSION-6.6 = 6.6.86/' target/linux/generic/Makefile
fi

# 方法2: 直接修改 include/kernel-version.mk 文件
if [ -f "include/kernel-version.mk" ]; then
    echo "修改 include/kernel-version.mk 中的 kernel 版本..."
    cp include/kernel-version.mk include/kernel-version.mk.bak
    sed -i 's/LINUX_KERNEL_HASH-6.6.*/LINUX_KERNEL_HASH-6.6.86 = af351158cfb5febf5155a3aa53785982/' include/kernel-version.mk
    sed -i 's/LINUX_VERSION-6.6 = 6.6.*/LINUX_VERSION-6.6 = 6.6.86/' include/kernel-version.mk
fi

# 方法3: 检查并修改具体的 target 目录下的 Makefile
for target_makefile in target/linux/*/Makefile; do
    if [ -f "$target_makefile" ] && grep -q "KERNEL_PATCHVER.*6.6" "$target_makefile"; then
        echo "修改 $target_makefile 中的 kernel 版本..."
        sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.6.86/' "$target_makefile"
    fi
done

echo "Kernel 版本固定完成"
