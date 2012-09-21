#!/bin/sh
set -e
CWD=`pwd`
rm -fr /tmp/build_haproxy
set -x
mkdir /tmp/build_haproxy
cd /tmp/build_haproxy
tar -xf ~/src/haproxy-1.5-dev12.tar.gz
cd haproxy-1.5-dev12
make install DESTDIR=/tmp/build_haproxy/installdir TARGET=linux2628 CPU=i686 USE_PCRE=1 USE_STATIC_PCRE=1 ARCH=i386 USE_OPENSSL=1
cd ..
fpm -s dir -t deb -n haproxy -v 1.5.dev.12 -C /tmp/build_haproxy/installdir -p haproxy-VERSION_ARCH.deb -d "libc6 (>= 2.15)" -d "libssl1.0.0 (>= 1.0.1)" -d "zlib1g (>= 1:1.2.3.4)" usr/local/sbin
cd $CWD
mkdir -p build
mv /tmp/build_haproxy/haproxy-1.5.dev.12_i386.deb build/
