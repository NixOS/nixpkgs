{ stdenv, fetchurl, pkgconfig, kdelibs, xlibs, zlib
, libpng, libjpeg, perl, gmp
}:

stdenv.mkDerivation {
  name = "ktorrent-2.2.1";
  src = fetchurl {
    url = http://ktorrent.pwsp.net/downloads/2.2.1/ktorrent-2.2.1.tar.gz;
    sha256 = "1wv7y8p21fliys55hcbxgxndz6y7ilr3cqyz99y32sm0v6l7qpyd";
  };
  buildInputs = [
    pkgconfig kdelibs kdelibs.qt xlibs.xlibs zlib libpng libjpeg perl gmp
  ];
  configureFlags = "--without-arts";
}
