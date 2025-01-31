{ boost
, cmake
, fetchFromGitHub
, lib
, libGLU
, libGL
, openssl
, pkg-config
, SDL
, SDL_image
, SDL_mixer
, SDL_gfx
, stdenv
, yaml-cpp
, zlib
}:

stdenv.mkDerivation {
  pname = "openxcom";
  version = "1.0.0.2024.02.28";

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "e2c5a1b45c33957ce7e206207c5fb752c1e79ae1";
    hash = "sha256-2G2dSvoDdacdYsXS51h3aGLCCjbHwcvD4CNnQIH/J6A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    libGL
    libGLU
    SDL
    SDL_gfx
    SDL_image
    SDL_mixer
    yaml-cpp
    openssl
    zlib
  ];

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    mainProgram = "openxcom";
    homepage = "https://openxcom.org";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
