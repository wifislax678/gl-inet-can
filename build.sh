#!/bin/env bash


# BASE_DIR=$(pwd)
BASE_DIR="~"

function main() {
    git clone https://github.com/gl-inet/gl-infra-builder.git  $BASE_DIR/gl-infra-builder
    cp -r $BASE_DIR/*.yml $BASE_DIR/gl-infra-builder/profiles
    
    cd $BASE_DIR/gl-infra-builder
    python3 setup.py -c config-wlan-ap.yml
    
    cd wlan-ap/openwrt
    echo '#############################################################'
    ls -lh
    echo '#############################################################'
    ls profiles/
    echo '#############################################################'
    ./scripts/gen_config.py glinet_axt1800 glinet_depends

    
    git clone https://github.com/gl-inet/glinet4.x.git -b main $BASE_DIR/glinet
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    make defconfig
    # make -j$(expr $(nproc) + 1) GL_PKGDIR=$BASE_DIR/glinet/ipq60xx/ V=s
    make -j1 GL_PKGDIR=$BASE_DIR/glinet/ipq60xx/ V=s
}

main
