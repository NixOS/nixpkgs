{
  boost,
  cmake,
  fetchFromGitHub,
  lib,
  libGLU,
  libGL,
  openssl,
  pkg-config,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_gfx,
  stdenv,
  yaml-cpp,
  zlib,
}:

stdenv.mkDerivation {
  pname = "openxcom";
  version = "1.0.0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "0f262a10ff447d09571375cef6e646f70868dae2";
    hash = "sha256-q36Lx+PRFKhL87hZr2INcjlxNUX5Y5k8YkA9WDEjagQ=";
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
