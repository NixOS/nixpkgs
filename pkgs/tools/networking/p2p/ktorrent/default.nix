{ stdenv, fetchurl, pkgconfig, kdelibs, xlibs, zlib
, libpng, libjpeg, perl, gmp
}:

stdenv.mkDerivation {
  name = "ktorrent-2.2.7";
  
  src = fetchurl {
    url = http://ktorrent.org/downloads/2.2.7/ktorrent-2.2.7.tar.bz2;
    sha256 = "0wvv294grv07zwdsycfsyhq5fllqyljrcg5g9iwgn84fk3nszlbi";
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
