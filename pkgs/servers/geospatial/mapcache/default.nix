{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, apacheHttpd, apr, aprutil, curl, db, fcgi, gdal, geos
, libgeotiff, libjpeg, libpng, libtiff, pcre, pixman, proj, sqlite, zlib
}:

stdenv.mkDerivation rec {
  pname = "mapcache";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "MapServer";
    repo = pname;
    rev = "rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-+QP4xXhP+MNqnhMUtMdtKrcuJ0M2BXWu3mbxXzj5ybc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    apacheHttpd
    apr
    aprutil
    curl
    db
    fcgi
    gdal
    geos
    libgeotiff
    libjpeg
    libpng
    libtiff
    pcre
    pixman
    proj
    sqlite
    zlib
  ];

  cmakeFlags = [
    "-DWITH_BERKELEY_DB=ON"
    "-DWITH_MEMCACHE=ON"
    "-DWITH_TIFF=ON"
    "-DWITH_GEOTIFF=ON"
    "-DWITH_PCRE=ON"
    "-DAPACHE_MODULE_DIR=${placeholder "out"}/modules"
  ];

  NIX_CFLAGS_COMPILE = "-std=c99";

  meta = with lib; {
    description = "A server that implements tile caching to speed up access to WMS layers";
    homepage = "https://mapserver.org/mapcache/";
    changelog = "https://www.mapserver.org/development/changelog/mapcache/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
