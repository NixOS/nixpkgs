#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

envpkgs="$ssl $db4 $expat"
. $setenv || exit 1

tar xvfz $src || exit 1
cd httpd-* || exit 1
./configure --prefix=$out --enable-ssl --with-ssl=$ssl --with-berkeley-db=$db4 \
 --with-expat=$expat --enable-mods-shared=all --without-gdbm \
 --enable-threads --with-devrandom=/dev/urandom || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
rm -rf $out/manual || exit 1
