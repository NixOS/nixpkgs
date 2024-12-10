{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  pkg-config,
  apacheHttpd,
  apr,
  aprutil,
  boost,
  cairo,
  curl,
  glib,
  harfbuzz,
  icu,
  iniparser,
  libmemcached,
  mapnik,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "mod_tile";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    rev = "refs/tags/v${version}";
    hash = "sha256-zXUwTG8cqAkY5MC1jAc2TtMgNMQPLc5nc22okVYP4ME=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/openstreetmap/mod_tile";
    description = "Efficiently render and serve OpenStreetMap tiles using Apache and Mapnik";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jglukasik ];
    platforms = platforms.linux;
  };
}
