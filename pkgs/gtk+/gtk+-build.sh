#! /bin/sh

envpkgs="$glib $atk $pango $tiff $jpeg $png $x11"
. $stdenv/setup || exit 1
export PATH=$pkgconfig/bin:$perl/bin:$PATH

# !!! abstraction problem: libtiff optionally needs libjpeg's headers.
# idem for libpng depending on zlib
export NIX_CFLAGS_COMPILE="-I$tiff/include -I$jpeg/include -I$png/include -I$zlib/include $NIX_CFLAGS_COMPILE"

tar xvfj $src || exit 1
cd gtk+-* || exit 1
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib \
 --with-libtiff=$tiff || exit 1
make || exit 1
make install || exit 1

echo $envpkgs > $out/envpkgs || exit 1
