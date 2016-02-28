{ lib, stdenv, fetchurl, pkgconfig, libjpeg, libpng, flex, zlib, perl, libxml2
, makeWrapper, libtiff
, enableX11 ? false, libX11 }:

stdenv.mkDerivation rec {
  name = "netpbm-10.66.00";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.xz";
    sha256 = "1z33pxdir92m7jlvp5c2q44gxwj7jyf8skiqkr71kgirw4w4zsbz";
  };

  postPatch = /* CVE-2005-2471, from Arch */ ''
    substituteInPlace converter/other/pstopnm.c \
      --replace '"-DSAFER"' '"-DPARANOIDSAFER"'
  '';

  NIX_CFLAGS_COMPILE = "-fPIC"; # Gentoo adds this on every platform

  buildInputs =
    [ pkgconfig flex zlib perl libpng libjpeg libxml2 makeWrapper libtiff ]
    ++ lib.optional enableX11 libX11;

  configurePhase = ''
    cp config.mk.in config.mk
    echo "STATICLIB_TOO = n" >> config.mk
    substituteInPlace "config.mk" \
        --replace "TIFFLIB = NONE" "TIFFLIB = ${libtiff}/lib/libtiff.so" \
        --replace "TIFFHDR_DIR =" "TIFFHDR_DIR = ${libtiff}/include"
  '';

  preBuild = ''
    export LDFLAGS="-lz"
    substituteInPlace "pm_config.in.h" \
        --subst-var-by "rgbPath1" "$out/lib/rgb.txt" \
        --subst-var-by "rgbPath2" "/var/empty/rgb.txt" \
        --subst-var-by "rgbPath3" "/var/empty/rgb.txt"
    touch lib/standardppmdfont.c
  '';

  enableParallelBuilding = false;

  installPhase = ''
    make package pkgdir=$out

    rm -rf $out/link $out/*_template $out/{pkginfo,README,VERSION} $out/man/web

    mkdir -p $out/share/netpbm
    mv $out/misc $out/share/netpbm/

    # wrap any scripts that expect other programs in the package to be in their PATH
    for prog in ppmquant; do
        wrapProgram "$out/bin/$prog" --prefix PATH : "$out/bin"
    done
  '';

  meta = {
    homepage = http://netpbm.sourceforge.net/;
    description = "Toolkit for manipulation of graphic images";
    license = "GPL,free";
    platforms = stdenv.lib.platforms.linux;
  };
}
