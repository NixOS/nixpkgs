{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, libpng
, libzip
, openal
, pkg-config
, yaml-cpp
, fmt
}:

stdenv.mkDerivation rec {
  pname = "openloco";
  version = "24.01.1";

  src = fetchFromGitHub {
    owner = "OpenLoco";
    repo = "OpenLoco";
    rev = "v${version}";
    hash = "sha256-QkJmJGObp5irk66SSGTxjydcp3sPaCbxcjcU3XGTVfo=";
  };

  # the upstream build process determines the version tag from git; since we
  # are not using a git checkout, we patch it manually
  postPatch = ''
    sed -i '/#define NAME "OpenLoco"/a#define OPENLOCO_VERSION_TAG "${version}"' src/OpenLoco/src/Version.cpp
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=null-dereference";

  cmakeFlags = [
    "-DOPENLOCO_BUILD_TESTS=NO"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    SDL2
    libpng
    libzip
    openal
    yaml-cpp
    fmt
  ];

  meta = {
    description = "An open source re-implementation of Chris Sawyer's Locomotion";
    homepage = "https://github.com/OpenLoco/OpenLoco";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
