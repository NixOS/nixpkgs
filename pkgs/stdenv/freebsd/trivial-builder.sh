#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

tar -zxvf $src
cd $dname
mkdir -p $out/bin
./configure --prefix=$out $configureArgs
make
make install
