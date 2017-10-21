{ lib, stdenv, fetchsvn, pkgconfig, libjpeg, libpng, flex, zlib, perl, libxml2
, makeWrapper, libtiff
, enableX11 ? false, libX11 }:

stdenv.mkDerivation rec {
  # Determine version and revision from:
  # https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/advanced
  name = "netpbm-10.77.02";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/netpbm/code/advanced";
    rev = 2883;
    sha256 = "1lxa5gasmqrwgihkk8ij7vb9kgdw3d5mp25kydkrf6x4wibg1w5f";
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
        --replace "TIFFHDR_DIR =" "TIFFHDR_DIR = ${libtiff.dev}/include" \
        --replace "JPEGLIB = NONE" "JPEGLIB = ${libjpeg.out}/lib/libjpeg.so" \
        --replace "JPEGHDR_DIR =" "JPEGHDR_DIR = ${libjpeg.dev}/include"
   '' + stdenv.lib.optionalString stdenv.isDarwin ''
    echo "LDSHLIB=-dynamiclib -install_name $out/lib/libnetpbm.\$(MAJ).dylib" >> config.mk
    echo "NETPBMLIBTYPE = dylib" >> config.mk
    echo "NETPBMLIBSUFFIX = dylib" >> config.mk
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
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
