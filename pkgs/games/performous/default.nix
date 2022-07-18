{ lib
, stdenv
, fetchFromGitHub
, SDL2
, boost
, cmake
, ffmpeg
, gettext
, glew
, glibmm
, libepoxy
, librsvg
, libxmlxx
, pango
, pkg-config
, portaudio
}:

stdenv.mkDerivation rec {
  pname = "performous";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "performous";
    repo = "performous";
    rev = version;
    hash = "sha256-neTHfug2RkcH/ZvAMCJv++IhygGU0L5Ls/jQYjLEQCI=";
  };

  patches = [ ./performous-cmake.patch ];

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    SDL2
    boost
    ffmpeg
    glew
    glibmm
    libepoxy
    librsvg
    libxmlxx
    pango
    portaudio
  ];

  meta = with lib; {
    homepage = "http://performous.org/";
    description = "Karaoke, band and dancing game";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
