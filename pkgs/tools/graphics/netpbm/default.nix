{stdenv, fetchsvn, libjpeg, libpng, flex, zlib, perl, libxml2 }:

stdenv.mkDerivation {
  name = "netpbm-advanced-844";

  src = fetchsvn {
    url = https://netpbm.svn.sourceforge.net/svnroot/netpbm/advanced;
    rev = 844;
    sha256 = "8729e63bb5cc9fd500a68d5aed91fa4b973ebc068e3014b47390ba7b4d85968e";
  };

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";

  buildInputs = [ flex zlib perl libpng libjpeg libxml2 ];

  configurePhase = "cp config.mk.in config.mk";

  makeFlags = "LDFLAGS=-lz";

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
  '';

  meta = {
    homepage = http://netpbm.sourceforge.net/;
    description = "Toolkit for manipulation of graphic images";
    license = "GPL,free";
  };
}
