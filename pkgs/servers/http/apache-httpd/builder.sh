#! /bin/sh

buildinputs="$openssl $db4 $expat $perl"
. $stdenv/setup || exit 1

if test $db4Support; then
    extraflags="--with-berkeley-db=$db4 $extraflags"
fi

if test $sslSupport; then
    extraflags="--enable-ssl --with-ssl=$openssl $extraflags"
fi

tar xvfz $src || exit 1
cd httpd-* || exit 1
./configure --prefix=$out \
 --with-expat=$expat --enable-mods-shared=all --without-gdbm \
 --enable-threads --with-devrandom=/dev/urandom \
 $extraflags || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
rm -rf $out/manual || exit 1
