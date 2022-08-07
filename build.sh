#!/bin/env bash

sudo mkdir /workspace && sudo chown $USER:$GROUPS /workspace
# WORK_PATH=$(pwd)
WORK_PATH="/workspace"
cd $WORK_PATH

function print_line() {
    echo '###############################################################################'
}

function main() {
    git clone https://github.com/gl-inet/gl-infra-builder.git  $WORK_PATH/gl-infra-builder
    cp -r $WORK_PATH/*.yml $WORK_PATH/gl-infra-builder/profiles
    
    cd $WORK_PATH/gl-infra-builder
    python3 setup.py -c configs/config-wlan-ap.yml
    
    cd wlan-ap/openwrt
    print_line
    echo $WORK_PATH
    print_line
    ls -lh
    print_line
    ls profiles/
    print_line
    ./scripts/gen_config.py axt1800  glinet_depends

    
    git clone https://github.com/gl-inet/glinet4.x.git -b main $WORK_PATH/glinet
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    make defconfig
    # make -j$(expr $(nproc) + 1) GL_PKGDIR=$WORK_PATH/glinet/ipq60xx/ V=s
    make -j1 GL_PKGDIR=$WORK_PATH/glinet/ipq60xx/ V=s
}

main
