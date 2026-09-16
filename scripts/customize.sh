#!/usr/bin/env bash
set -euo pipefail

PASSWALL2_FEED="https://github.com/xiaorouji/openwrt-passwall2.git"
MOSDNS_FEED="https://github.com/sbwml/luci-app-mosdns.git"

grep -qF "src-git passwall2 ${PASSWALL2_FEED}" feeds.conf.default \
  || echo "src-git passwall2 ${PASSWALL2_FEED}" >> feeds.conf.default
grep -qF "src-git mosdns ${MOSDNS_FEED};v5" feeds.conf.default \
  || echo "src-git mosdns ${MOSDNS_FEED};v5" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a
