#! /bin/sh

envpkgs="$glib $Xft $x11"
. $stdenv/setup || exit 1
export PATH=$pkgconfig/bin:$PATH

tar xvfj $src || exit 1
cd pango-* || exit 1
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib || exit 1
make || exit 1
make install || exit 1

echo $envpkgs > $out/envpkgs || exit 1
