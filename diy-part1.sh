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

# ImmortalWrt v24.10.5 provides most requested packages in its official feeds.
# Extra feeds cover iStore, NAS/iStore apps, and Nikki.
echo >>feeds.conf.default
echo 'src-git istore https://github.com/linkease/istore;main' >>feeds.conf.default
echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >>feeds.conf.default
echo 'src-git nas_packages https://github.com/linkease/nas-packages.git;main' >>feeds.conf.default
echo 'src-git app_meta https://github.com/linkease/openwrt-app-meta.git;main' >>feeds.conf.default
echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main' >>feeds.conf.default

echo "Using ImmortalWrt v24.10.5 with iStore, NAS app, OpenFog app-meta, and Nikki feeds."
