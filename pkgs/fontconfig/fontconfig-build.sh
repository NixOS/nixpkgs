#! /bin/sh

export PATH=/bin:/usr/bin
envpkgs=$freetype
. $setenv

tar xvfz $src || exit 1
cd fcpackage*/fontconfig || exit 1
./configure --prefix=$out --with-confdir=$out/etc/fonts --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
