#! /bin/sh

. $stdenv/setup || exit 1

envpkgs="$ssl $db4 $expat"
. $setenv

tar xvfz $src || exit 1
cd httpd-* || exit 1
LDFLAGS=-Wl,-S ./configure --prefix=$out --enable-ssl --with-ssl=$ssl --with-berkeley-db=$db4 \
 --with-expat=$expat --enable-mods-shared=all --without-gdbm || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
rm -rf $out/manual || exit 1
