{stdenv, fetchsvn, libjpeg, libpng, flex, zlib, perl, libxml2 }:

stdenv.mkDerivation {
  name = "netpbm-advanced-844";

  src = fetchsvn {
    url = https://netpbm.svn.sourceforge.net/svnroot/netpbm/advanced;
    rev = 844;
  };

  buildInputs = [ flex zlib perl libpng libjpeg libxml2 ];

  configurePhase = "cp config.mk.in config.mk";

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
