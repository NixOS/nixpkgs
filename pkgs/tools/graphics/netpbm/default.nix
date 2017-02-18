{ lib, stdenv, fetchsvn, pkgconfig, libjpeg, libpng, flex, zlib, perl, libxml2
, makeWrapper, libtiff
, enableX11 ? false, libX11 }:

let
  version = "10.73.07";
  rev = 2885;

in stdenv.mkDerivation rec {
  name = "netpbm-${version}";

  src = fetchsvn {
    url    = "http://svn.code.sf.net/p/netpbm/code/stable";
    inherit rev;
    sha256 = "004p95769800zh9a2zzm41k8l29c5wnnk6viz9b4fgb2g4gl3sn1";
  };

  postPatch = /* CVE-2005-2471, from Arch */ ''
    substituteInPlace converter/other/pstopnm.c \
      --replace '"-DSAFER"' '"-DPARANOIDSAFER"'
  '';

  buildInputs =
    [ pkgconfig flex zlib perl libpng libjpeg libxml2 makeWrapper libtiff ]
    ++ lib.optional enableX11 libX11;

  configurePhase = ''
    cp config.mk.in config.mk
    echo "STATICLIB_TOO = n" >> config.mk
    substituteInPlace "config.mk" \
        --replace "TIFFLIB = NONE" "TIFFLIB = ${libtiff.out}/lib/libtiff.so" \
        --replace "TIFFHDR_DIR =" "TIFFHDR_DIR = ${libtiff.dev}/include"
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

  meta = with stdenv.lib; {
    homepage = http://netpbm.sourceforge.net/;
    description = "Toolkit for manipulation of graphic images";
    license = "GPL,free";
    platforms = with platforms; linux;
  };
}
