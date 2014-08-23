{ stdenv, fetchsvn, pkgconfig, libjpeg, libpng, flex, zlib, perl, libxml2, makeWrapper, libX11, libtiff }:

let rev = 1742; in
stdenv.mkDerivation {
  name = "netpbm-advanced-${toString rev}";

  src = fetchsvn {
    url = https://netpbm.svn.sourceforge.net/svnroot/netpbm/advanced;
    inherit rev;
    sha256 = "0csx6g0ci66nx1a6z0a9dkpfp66mdvcpp5r7g6zrx4jp18r9hzb2";
  };

  postPatch = /* CVE-2005-2471, from Arch */ ''
    substituteInPlace converter/other/pstopnm.c \
      --replace '"-DSAFER"' '"-DPARANOIDSAFER"'
  '';

  NIX_CFLAGS_COMPILE = "-fPIC"; # Gentoo adds this on every platform

  buildInputs = [ pkgconfig flex zlib perl libpng libjpeg libxml2 makeWrapper libX11 libtiff ];

  configurePhase = ''
    cp config.mk.in config.mk
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

  enableParallelBuilding = true;

  installPhase = ''
    make package pkgdir=$PWD/netpbmpkg
    # Pass answers to the script questions
    ./installnetpbm << EOF
    $PWD/netpbmpkg
    $out
    Y
    $out/bin
    $out/lib
    N
    $out/lib
    $out/lib
    $out/include
    $out/man
    N
    EOF

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
