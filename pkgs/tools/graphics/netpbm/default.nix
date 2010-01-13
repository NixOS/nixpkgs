{stdenv, fetchsvn, libjpeg, libpng, flex, zlib, perl, libxml2, makeWrapper }:

stdenv.mkDerivation {
  name = "netpbm-advanced-844";

  src = fetchsvn {
    url = https://netpbm.svn.sourceforge.net/svnroot/netpbm/advanced;
    rev = 844;
    sha256 = "8729e63bb5cc9fd500a68d5aed91fa4b973ebc068e3014b47390ba7b4d85968e";
  };

  patches = [ ./rgbpaths.patch ];

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";

  buildInputs = [ flex zlib perl libpng libjpeg libxml2 makeWrapper ];

  configurePhase = "cp config.mk.in config.mk";

  preBuild = ''
    export LDFLAGS=-lz
    substituteInPlace "pm_config.in.h" \
        --subst-var-by "rgbPath1" "$out/lib/rgb.txt" \
        --subst-var-by "rgbPath2" "/var/empty/rgb.txt" \
        --subst-var-by "rgbPath3" "/var/empty/rgb.txt"
  '';

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
  };
}
