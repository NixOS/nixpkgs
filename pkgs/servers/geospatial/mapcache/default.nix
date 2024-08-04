{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, apacheHttpd, apr, aprutil, curl, db, fcgi, gdal, geos
, libgeotiff, libjpeg, libpng, libtiff, pcre, pixman, proj, sqlite, zlib
}:

stdenv.mkDerivation rec {
  pname = "mapcache";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "MapServer";
    repo = pname;
    rev = "rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-AwdZdOEq9SZ5VzuBllg4U1gdVxZ9IVdqiDrn3QuRdCk=";
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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-std=c99";

  meta = with lib; {
    description = "Server that implements tile caching to speed up access to WMS layers";
    homepage = "https://mapserver.org/mapcache/";
    changelog = "https://www.mapserver.org/development/changelog/mapcache/";
    license = licenses.mit;
    maintainers = teams.geospatial.members;
    platforms = platforms.unix;
  };
}
