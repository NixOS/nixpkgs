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
  version = "1.0.0.2023.08.12";

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "bd632cc8569a57fdc3b68ce53f6ea850422ec5ac";
    hash = "sha256-ouYZ4rAEluqeP+ZUrbEZwCpXCw0cZLWsf1GbIE3jaTc=";
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
    homepage = "https://openxcom.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ cpages ];
    platforms = lib.platforms.linux;
  };
}
