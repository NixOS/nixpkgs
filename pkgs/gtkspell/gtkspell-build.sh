#! /bin/sh

envpkgs="$gtk $pspell"
. $stdenv/setup || exit 1
export PATH=$pkgconfig/bin:$PATH

export C_INCLUDE_PATH=$pspell/include:$C_INCLUDE_PATH

tar xvfz $src || exit 1
cd gtkspell-* || exit 1
./configure --prefix=$out --disable-gtk-doc || exit 1
make || exit 1
make install || exit 1

echo $envpkgs > $out/envpkgs || exit 1
