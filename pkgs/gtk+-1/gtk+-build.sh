#! /bin/sh

export PATH=/bin:/usr/bin
envpkgs="$glib"
. $setenv

tar xvfz $src || exit 1
cd gtk+-* || exit 1
LDFLAGS=-s ./configure --prefix=$out --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
