{ stdenv, fetchurl, pkgconfig, kde, xlibs, zlib
, libpng, libjpeg, perl, gmp, cmake, gettext, boost
}:

stdenv.mkDerivation {
  name = "ktorrent-3.3.3";
  
  src = fetchurl {
    url = http://ktorrent.org/downloads/3.3.3/ktorrent-3.3.3.tar.bz2;
    sha256 = "1f2hr8q8j1fxd3wa74vavq7b0spdsjfcl3jbyfi9xhk9mxxlm216";
  };
  
  buildInputs = [
    pkgconfig xlibs.xlibs zlib libpng libjpeg perl gmp cmake gettext boost
  ];

  propagatedBuildInputs = [
    kde.qt4 kde.automoc4 kde.kdelibs kde.phonon kde.qca2 kde.kdepimlibs
  ];

  cmakeFlags = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
  includeAllQtDirs=true;
  
  meta = {
    homepage = http://ktorrent.org/;
    description = "A BitTorrent client for KDE";
  };
}
