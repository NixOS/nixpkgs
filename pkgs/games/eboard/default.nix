{ stdenv, fetchurl, pkgconfig, gtk }:

stdenv.mkDerivation {
  name = "eboard-1.1.1";
  
  src = fetchurl {
    url = mirror://sourceforge/eboard/eboard-1.1.1.tar.bz2;
    sha256 = "0vm25j1s2zg1lipwjv9qrcm877ikfmk1yh34i8f5l3bwd63115xd";
  };

  patches = [ ./eboard.patch ];

  buildInputs = [ pkgconfig gtk ];

  meta = {
    homepage = http://www.bergo.eng.br/eboard/;
    description = "eboard is a chess interface for Unix-like systems";
  };
}
