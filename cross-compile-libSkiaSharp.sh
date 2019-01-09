#!/bin/bash

set -e

git clone https://github.com/mono/skia.git -b v1.68.0 --depth 1
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --depth 1
git clone https://github.com/raspberrypi/tools.git --depth 1

mkdir libfontconfig1
pushd libfontconfig1
wget http://archive.raspbian.org/raspbian/pool/main/f/fontconfig/libfontconfig1_2.11.0-6.7_armhf.deb
ar vx libfontconfig1_2.11.0-6.7_armhf.deb
tar -xJvf data.tar.xz
 
wget http://archive.raspbian.org/raspbian/pool/main/f/fontconfig/libfontconfig1-dev_2.11.0-6.7_armhf.deb
ar vx libfontconfig1-dev_2.11.0-6.7_armhf.deb
tar -xJvf data.tar.xz

cp -R ./usr/lib/arm-linux-gnueabihf/* ../tools/arm-bcm2708/arm-linux-gnueabihf/arm-linux-gnueabihf/lib
cp -R usr/include/fontconfig ../tools/arm-bcm2708/arm-linux-gnueabihf/arm-linux-gnueabihf/include/
 
popd

export PATH="$PATH:`pwd`/tools/arm-bcm2708/arm-linux-gnueabihf/bin"

pushd skia

python tools/git-sync-deps

./bin/gn gen 'out/linux-arm' --args='
    cc = "arm-linux-gnueabihf-gcc"
    cxx = "arm-linux-gnueabihf-g++"
    is_official_build=true skia_enable_tools=false
    target_os="linux" target_cpu="arm"
    skia_use_icu=false skia_use_sfntly=false skia_use_piex=true
    skia_use_system_expat=false skia_use_system_freetype2=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false
    skia_enable_gpu=true
    extra_cflags=[ "-DSKIA_C_DLL" ]
    linux_soname_version=""'

# compile
../depot_tools/ninja 'SkiaSharp' -C 'out/linux-arm'

popd