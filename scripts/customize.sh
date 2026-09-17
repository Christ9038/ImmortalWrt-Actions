#!/usr/bin/env bash
set -euo pipefail

PASSWALL2_FEED="https://github.com/Openwrt-Passwall/openwrt-passwall2.git"
PASSWALL_PACKAGES_FEED="https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git"
MOSDNS_REPO="https://github.com/sbwml/luci-app-mosdns.git"
V2RAY_GEODATA_REPO="https://github.com/sbwml/v2ray-geodata.git"

grep -qF "src-git passwall2 ${PASSWALL2_FEED}" feeds.conf.default \
  || echo "src-git passwall2 ${PASSWALL2_FEED}" >> feeds.conf.default
grep -qF "src-git passwall_packages ${PASSWALL_PACKAGES_FEED}" feeds.conf.default \
  || echo "src-git passwall_packages ${PASSWALL_PACKAGES_FEED}" >> feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a

# Follow sbwml's documented non-OpenWrt integration: remove the source's
# MosDNS/geodata package definitions, then add the v5 sources as packages.
find feeds package -type f -name Makefile \
  \( -path '*/mosdns/*' -o -path '*/v2ray-geodata/*' \) -delete

rm -rf package/mosdns package/v2ray-geodata
git clone --depth 1 --branch v5 "${MOSDNS_REPO}" package/mosdns
git clone --depth 1 "${V2RAY_GEODATA_REPO}" package/v2ray-geodata
