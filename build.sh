#!/bin/env bash


BASE_DIR=$(pwd)

function main() {
    git clone https://github.com/gl-inet/gl-infra-builder.git  $BASE_DIR/gl-infra-builder
    cp -r $BASE_DIR/*.yml $BASE_DIR/gl-infra-builder/profiles
    
    cd $BASE_DIR/gl-infra-builder
    python3 setup.py -c config-wlan-ap.yml
    
    cd wlan-ap/openwrt
    ./scripts/gen_config.py $BASE_DIR/gl-infra-builder/profiles/glinet_axt1800 glinet_depends

    
    git clone https://github.com/gl-inet/glinet4.x.git
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    make defconfig
    make -j$(expr $(nproc) + 1) GL_PKGDIR=$BASE_DIR/glinet/work/glinet4.x/ipq60xx/
}

main
