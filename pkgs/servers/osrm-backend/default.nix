{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  bzip2,
  libxml2,
  libzip,
  boost,
  lua,
  luabind,
  tbb,
  expat,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "osrm-backend";
  version = "5.27.1-unstable-2024-11-03";

  src = fetchFromGitHub {
    owner = "Project-OSRM";
    repo = "osrm-backend";
    rev = "3614af7f6429ee35c3f2e836513b784a74664ab6";
    hash = "sha256-iix++G49cC13wZGZIpXu1SWGtVAcqpuX3GhsIaETzUU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    bzip2
    libxml2
    libzip
    boost
    lua
    luabind
    tbb
    expat
  ];

  # Needed with GCC 12
  env.NIX_CFLAGS_COMPILE = "-Wno-error=uninitialized";

  postInstall = ''
    mkdir -p $out/share/osrm-backend
    cp -r ../profiles $out/share/osrm-backend/profiles
  '';

  passthru.tests = {
    inherit (nixosTests) osrm-backend;
  };

  meta = {
    homepage = "https://github.com/Project-OSRM/osrm-backend/wiki";
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    changelog = "https://github.com/Project-OSRM/osrm-backend/blob/master/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erictapen ];
    platforms = lib.platforms.unix;
  };
}
