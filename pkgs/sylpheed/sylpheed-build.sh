#! /bin/sh

. $stdenv/setup || exit 1

envpkgs="$gtk $ssl"
. $setenv || exit 1

export C_INCLUDE_PATH=$ssl/include:$C_INCLUDE_PATH

tar xvfj $src || exit 1
cd sylpheed-* || exit 1
LDFLAGS=-Wl,-S ./configure --prefix=$out --enable-ssl --disable-gdk-pixbuf --disable-imlibtest || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1
