#! /bin/sh -e

set -x

buildinputs="$autoconf $g77 $texinfo $bison $flex $gperf $rna $aterm"
. $stdenv/setup

g77orig=$(cat $g77/nix-support/orig-gcc)
export NIX_LDFLAGS="-rpath $g77orig/lib $NIX_LDFLAGS"

export NIX_STRIP_DEBUG=
export NIX_CFLAGS_COMPILE="-g $NIX_CFLAGS_COMPILE"

tar xvfz $src
cd octavefront-*
./autogen.sh
./configure --prefix=$out --disable-readline --enable-rna=$rna --enable-aterm
make
make install
#strip -S $out/lib/*/*.a
