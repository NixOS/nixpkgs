#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd unzip-* || exit 1
make -f unix/Makefile generic || exit 1
make -f unix/Makefile prefix=$out install || exit 1
