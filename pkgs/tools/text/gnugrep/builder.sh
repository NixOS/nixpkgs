#! /bin/sh -e

set -x
export NIX_DEBUG=1
buildinputs="$pcre"
. $stdenv/setup

echo $NIX_LDFLAGS

tar xvfj $src
cd grep-*
./configure --prefix=$out
make
make install
