#! /bin/sh

export PATH=/bin:/usr/bin
envpkgs="$gtk $ssl"
. $setenv

export C_INCLUDE_PATH=$ssl/include:$C_INCLUDE_PATH

export LDFLAGS=-s

tar xvfj $src || exit 1
cd sylpheed-* || exit 1
./configure --prefix=$out --enable-ssl --disable-gdk-pixbuf --disable-imlibtest || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
