<<<<<<< HEAD
{ boost
, cmake
, fetchFromGitHub
, lib
, libGLU
, libGL
, openssl
, pkg-config
=======
{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libGLU
, libGL
, zlib
, openssl
, yaml-cpp
, boost
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, SDL
, SDL_image
, SDL_mixer
, SDL_gfx
<<<<<<< HEAD
, stdenv
, yaml-cpp
, zlib
}:

stdenv.mkDerivation {
  pname = "openxcom";
  version = "1.0.0.2023.08.12";
=======
}:

stdenv.mkDerivation rec {
  pname = "openxcom";
  version = "1.0.0.2019.10.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
<<<<<<< HEAD
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
=======
    rev = "f9853b2cb8c8f741ac58707487ef493416d890a3";
    hash = "sha256-APv49ZT94oeM4KVKGtUdoQ1t8Ly8lsocr+FqXiRXbk0=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost yaml-cpp libGLU libGL openssl zlib ];

  meta = with lib; {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = "https://openxcom.org";
    maintainers = with maintainers; [ cpages ];
    platforms = platforms.linux;
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
