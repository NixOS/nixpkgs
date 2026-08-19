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
  ps,
  jq,
  memcached,
  iana-etc,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "mod_tile";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    tag = "v${version}";
    hash = "sha256-zDe+pFzK16K+8I0v1Z7p83PIgQlVDbjcnD4vzwdB1Oo=";
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
  # Do not run tests in parallel
  enableParallelChecking = false;

  nativeCheckInputs = [
    iana-etc
    ps
  ]
  ++ lib.filter (pkg: !pkg.meta.broken) [
    jq
    memcached
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/openstreetmap/mod_tile";
    description = "Efficiently render and serve OpenStreetMap tiles using Apache and Mapnik";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jglukasik ];
    platforms = lib.platforms.linux;
  };
}
