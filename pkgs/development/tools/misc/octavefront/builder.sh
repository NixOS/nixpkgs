#! /bin/sh -e

buildinputs="$autoconf $g77 $texinfo $bison $flex $gperf $rna $aterm"
. $stdenv/setup

g77orig=$(cat $g77/orig-gcc)
export NIX_LDFLAGS="-rpath $g77orig/lib $NIX_LDFLAGS"

tar xvfz $src
cd octavefront-*
./autogen.sh
./configure --prefix=$out --disable-readline --enable-rna=$rna --enable-aterm
make
make install
strip -S $out/lib/*/*.a
