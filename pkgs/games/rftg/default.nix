{ stdenv, fetchurl, gtk2, pkgconfig }:

stdenv.mkDerivation rec {

  name = "rftg-${version}";
  version = "0.9.4";

  src = fetchurl {
    url = "http://keldon.net/rftg/rftg-${version}.tar.bz2";
    sha256 = "0j2y6ggpwdlvyqhirp010aix2g6aacj3kvggvpwzxhig30x9vgq8";
  };

  buildInputs = [ gtk2.dev pkgconfig ];

  meta = {
    homepage = http://keldon.net/rftg/;
    description = "Implementation of the card game Race for the Galaxy, including an AI";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.falsifian ];
  };

}
