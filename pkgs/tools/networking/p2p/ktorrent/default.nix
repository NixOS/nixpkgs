{ stdenv, fetchurl, pkgconfig, kdelibs, xlibs, zlib
, libpng, libjpeg, perl, gmp
}:

stdenv.mkDerivation {
  name = "ktorrent-2.2.5";
  
  src = fetchurl {
    url = http://ktorrent.org/downloads/2.2.5/ktorrent-2.2.5.tar.bz2;
    sha256 = "1rkblfpg4ysg4935i3l22ns553h37rn2flm4rgkqzdf67aq0akkx";
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
