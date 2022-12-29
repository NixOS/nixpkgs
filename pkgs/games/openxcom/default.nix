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
, SDL
, SDL_image
, SDL_mixer
, SDL_gfx
}:

stdenv.mkDerivation rec {
  pname = "openxcom";
  version = "1.0.0.2023.08.12";

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "bd632cc8569a57fdc3b68ce53f6ea850422ec5ac";
    hash = "sha256-ouYZ4rAEluqeP+ZUrbEZwCpXCw0cZLWsf1GbIE3jaTc=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost yaml-cpp libGLU libGL openssl zlib ];

  meta = with lib; {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = "https://openxcom.org";
    maintainers = with maintainers; [ cpages ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
