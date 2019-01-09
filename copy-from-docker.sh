#!/bin/bash

docker build -t libskiasharp-linuxarm .
docker run --rm -v "./runtimes/linux-arm/native:/temp" "libskiasharp-linuxarm" cp -r /build/skia/out/linux-arm /temp/