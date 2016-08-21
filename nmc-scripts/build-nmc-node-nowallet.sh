#!/bin/bash
#
# Build and install Namecoin node from source (without wallet)
# https://github.com/namecoin/namecoin-core/blob/master/doc/build-unix.md
#

# -- Install main depencencies --
apt-get update && apt-get install -y libboost-all-dev \
        dh-autoreconf curl libcurl4-openssl-dev \
        git apg libboost-all-dev build-essential libtool \
        libevent-dev wget bsdmainutils autoconf \
        apg libqrencode-dev libcurl4-openssl-dev \
        automake make libssl-dev libminiupnpc-dev \
        pkg-config libzmq3-dev

# -- Clone Namecoin source repository --
[ -d "namecoin-core" ] || git clone https://github.com/namecoin/namecoin-core.git

# -- Build Namecoin --
cd namecoin-core
./autogen.sh
# CXX flags tuned to conserve memory
./configure \
        CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768" \
        --enable-cxx \
        --disable-shared \
        --with-pic \
        --without-gui \
        --enable-upnp-default
make && make install

# -- Clean --
cd .. 
rm -rf namecoin-core       
apt-get autoremove -y
apt-get clean 
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

exit 0
