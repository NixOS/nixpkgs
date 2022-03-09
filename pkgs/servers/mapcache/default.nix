{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, apacheHttpd, apr, aprutil, curl, db, fcgi, gdal, geos
, libgeotiff, libjpeg, libpng, libtiff, pcre, pixman, proj, sqlite, zlib
}:

stdenv.mkDerivation rec {
  pname = "mapcache";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "MapServer";
    repo = pname;
    rev = "rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-13lOQC4PJtByhvceuF00uoipLFHrFiyJrsy2iWcEANc=";
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

  meta = with lib; {
    description = "A server that implements tile caching to speed up access to WMS layers";
    homepage = "https://mapserver.org/mapcache/";
    changelog = "https://www.mapserver.org/development/changelog/mapcache/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
