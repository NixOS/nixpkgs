#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
envpkgs="$glib $atk $pango"
. $setenv

tar xvfj $src || exit 1
cd gtk+-* || exit 1
./configure --prefix=$out --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
