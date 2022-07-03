{ lib
, stdenv
, fetchFromGitHub
, cmake
, libGLU
, libGL
, zlib
, openssl
, libyamlcpp
, boost
, SDL
, SDL_image
, SDL_mixer
, SDL_gfx
}:

stdenv.mkDerivation rec {
  pname = "openxcom";
  version = "1.0.0.2019.10.18";

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "f9853b2cb8c8f741ac58707487ef493416d890a3";
    hash = "sha256-APv49ZT94oeM4KVKGtUdoQ1t8Ly8lsocr+FqXiRXbk0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost libyamlcpp libGLU libGL openssl zlib ];

  meta = with lib; {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = "https://openxcom.org";
    maintainers = with maintainers; [ cpages ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
