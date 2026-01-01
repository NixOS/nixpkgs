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
<<<<<<< HEAD
  ps,
  jq,
  memcached,
  iana-etc,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "mod_tile";
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zDe+pFzK16K+8I0v1Z7p83PIgQlVDbjcnD4vzwdB1Oo=";
=======
    hash = "sha256-JC275LKsCeEo5DcIX0X7kcLoijQJqfJvBvw8xi2gwpk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/openstreetmap/mod_tile";
    description = "Efficiently render and serve OpenStreetMap tiles using Apache and Mapnik";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jglukasik ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
