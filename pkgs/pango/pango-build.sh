#! /bin/sh

export PATH=$pkgconfig/bin:/bin:/usr/bin
envpkgs="$glib $Xft"
. $setenv

tar xvfj $src || exit 1
cd pango-* || exit 1
LDFLAGS=-s ./configure --prefix=$out --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
