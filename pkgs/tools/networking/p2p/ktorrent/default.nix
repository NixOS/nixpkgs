{ stdenv, fetchurl, pkgconfig, kdelibs, xlibs, zlib
, libpng, libjpeg, perl, gmp
}:

stdenv.mkDerivation {
  name = "ktorrent-2.2.8";
  
  src = fetchurl {
    url = http://ktorrent.org/downloads/2.2.8/ktorrent-2.2.8.tar.bz2;
    sha256 = "10zpc50sggg8h1g6vgcv12mm4sw4d6jvzvnghdplqs86m5bwpg9k";
  };
  
  buildInputs = [
    pkgconfig kdelibs kdelibs.qt xlibs.xlibs zlib libpng libjpeg perl gmp
  ];
  
  configureFlags = "--without-arts";

  meta = {
    homepage = http://ktorrent.org/;
    description = "A BitTorrent client for KDE";
  };
}
