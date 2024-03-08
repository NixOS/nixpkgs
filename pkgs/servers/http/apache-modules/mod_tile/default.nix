{ fetchFromGitHub
, lib
, stdenv
, cmake
, pkg-config
, apacheHttpd
, apr
, aprutil
, boost
, cairo
, curl
, glib
, harfbuzz
, icu
, iniparser
, libmemcached
, mapnik
}:

stdenv.mkDerivation rec {
  pname = "mod_tile";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    rev = "v${version}";
    hash = "sha256-jDuOcmKzZGU6L0aOfPKRGpDLbX0O9ueTufBy7Bd6KMU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    apacheHttpd
    apr
    aprutil
    boost
    cairo
    curl
    glib
    harfbuzz
    icu
    iniparser
    libmemcached
    mapnik
  ];

  enableParallelBuilding = true;

  # Explicitly specify directory paths
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_MANDIR" "share/man")
    (lib.cmakeFeature "CMAKE_INSTALL_MODULESDIR" "modules")
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "")
    (lib.cmakeBool "ENABLE_TESTS" doCheck)
  ];

  # And use DESTDIR to define the install destination
  installFlags = [ "DESTDIR=$(out)" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/openstreetmap/mod_tile";
    description = "Efficiently render and serve OpenStreetMap tiles using Apache and Mapnik";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jglukasik ];
    platforms = platforms.linux;
  };
}
