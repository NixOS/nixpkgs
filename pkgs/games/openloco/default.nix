{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  SDL2,
  cmake,
  libpng,
  libzip,
  openal,
  pkg-config,
  yaml-cpp,
  fmt,
}:
let
  sfl-src = fetchFromGitHub {
    owner = "slavenf";
    repo = "sfl-library";
    tag = "1.9.0";
    hash = "sha256-Udry/Y753l274PU6RvpPgkIr85wSCnz3mLQ0xzerUAc=";
  };

  openloco-objects = fetchurl {
    url = "https://github.com/OpenLoco/OpenGraphics/releases/download/v0.1.1/objects.zip";
    sha256 = "e75ad13a8e8d58458e0c54e5ce62902a073d7bb025ef8fb97cb56108ff7c57c3";
  };

in
stdenv.mkDerivation rec {
  pname = "openloco";
  version = "25.02";

  src = fetchFromGitHub {
    owner = "OpenLoco";
    repo = "OpenLoco";
    tag = "v${version}";
    hash = "sha256-RsiEYBNx+Lf7OyyyCShQmgtwBuxDrZkRCYCbMmZ8ZMM=";
  };

  postPatch = ''
    # the upstream build process determines the version tag from git; since we
    # are not using a git checkout, we patch it manually
    sed -i '/#define NAME "OpenLoco"/a#define OPENLOCO_VERSION_TAG "${version}"' src/OpenLoco/src/Version.cpp

    # prefetch sfl header sources
    grep -q 'GIT_TAG \+${sfl-src.tag}' thirdparty/CMakeLists.txt
    sed -i 's#GIT_REPOSITORY \+https://github.com/slavenf/sfl-library#SOURCE_DIR ${sfl-src}#' thirdparty/CMakeLists.txt

    # prefetch openloco-objects
    sed -i 's#URL \+${openloco-objects.url}#URL ${openloco-objects}#' CMakeLists.txt
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
    description = "Open source re-implementation of Chris Sawyer's Locomotion";
    homepage = "https://github.com/OpenLoco/OpenLoco";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
