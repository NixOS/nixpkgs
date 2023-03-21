{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, libpng
, libzip
, openal
, pkg-config
, span-lite
, yaml-cpp
}:

stdenv.mkDerivation rec {
  pname = "openloco";
  version = "23.02";

  src = fetchFromGitHub {
    owner = "OpenLoco";
    repo = "OpenLoco";
    rev = "v${version}";
    hash = "sha256-35g7tnKez4tnTdZzavfU+X8f3btFG6EbLkU+cqL6Qek=";
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
    span-lite
  ];

  meta = {
    description = "An open source re-implementation of Chris Sawyer's Locomotion";
    homepage = "https://github.com/OpenLoco/OpenLoco";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
