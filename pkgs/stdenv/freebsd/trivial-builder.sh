#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

tar -zxvf $src
cd $dname

for PATCH in $patches; do
    patch <$PATCH
done
mkdir -p $out/bin
./configure --prefix=$out $configureArgs
make
make install
