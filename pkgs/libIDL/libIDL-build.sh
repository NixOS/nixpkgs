#! /bin/sh

envpkgs="$glib"
. $stdenv/setup || exit 1
export PATH=$pkgconfig/bin:$lex/bin:$yacc/bin:$PATH

tar xvfj $src || exit 1
cd libIDL-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1

echo $envpkgs > $out/envpkgs || exit 1
