#! /bin/sh

envpkgs="$glib $atk $pango"
. $stdenv/setup || exit 1
export PATH=$pkgconfig/bin:$perl/bin:$PATH

tar xvfj $src || exit 1
cd gtk+-* || exit 1
./configure --prefix=$out --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1

echo $envpkgs > $out/envpkgs || exit 1
