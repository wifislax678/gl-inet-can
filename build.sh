#!/bin/env bash


BASE_DIR=$(pwd)

function main() {
    git clone https://github.com/gl-inet/gl-infra-builder.git  $BASE_DIR/gl-infra-builder
    cd gl-infra-builder
    python3 setup.py -c config-wlan-ap.yml
    cd wlan-ap/openwrt
    ./scripts/gen_config.py target_wlan_ap-gl-axt1800 luci
    make -j17
}

main
