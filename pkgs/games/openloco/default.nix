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
  xorg,
}:
let
  sfl-src = fetchFromGitHub {
    owner = "slavenf";
    repo = "sfl-library";
    tag = "1.9.2";
    hash = "sha256-/3++CtSuZJ5Sdg8U8mJ/gT+FTatKhBx8QeYjUVQCDWA=";
  };

  openloco-objects = fetchurl {
    url = "https://github.com/OpenLoco/OpenGraphics/releases/download/v0.1.3/objects.zip";
    sha256 = "c08937691b9d7a956305864b535c6e4537a84b81a9dc5d4c9016edff83dcceb6";
  };

in
stdenv.mkDerivation rec {
  pname = "openloco";
  version = "25.08";

  src = fetchFromGitHub {
    owner = "OpenLoco";
    repo = "OpenLoco";
    tag = "v${version}";
    hash = "sha256-f4GZxLibQM/od0tJoszaG94FkRH5vb9qwQ7OqVdt1cU=";
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
    xorg.libX11
  ];

  meta = {
    description = "Open source re-implementation of Chris Sawyer's Locomotion";
    homepage = "https://github.com/OpenLoco/OpenLoco";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
