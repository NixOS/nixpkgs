{
  fetchFromGitHub,
  fetchpatch2,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "mod_tile";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hIVkhcs6bvADpCZ5LA3MTEJX2EvkVSTwLnYRywZM/mg=";
  };

  patches = [
    (fetchpatch2 {
      name = "cache-expire-tests-single-address-host.patch";
      url = "https://github.com/openstreetmap/mod_tile/commit/a56b8f572c333a32dd8ce9f56298230fbd90ecee.patch?full_index=1";
      hash = "sha256-e25bX2zw4oI9Ox96uPoKGh4ISbZzUvmQ+roC/nx8zb8=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    apacheHttpd
    curl
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
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
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
    maintainers = with lib.maintainers; [
      jglukasik
      nivalux
    ];
    platforms = lib.platforms.linux;
  };
})
