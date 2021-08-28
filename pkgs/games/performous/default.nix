{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gettext
, glibmm, libxmlxx, pango, librsvg
, SDL2, glew, boost, ffmpeg, portaudio, epoxy
}:

stdenv.mkDerivation rec {
  pname = "performous";
  version = "1.1";

  meta = with lib; {
    description = "Karaoke, band and dancing game";
    homepage    = "http://performous.org/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "performous";
    repo = "performous";
    rev = version;
    sha256 = "08j0qhr65l7qnd5vxl4l07523qpvdwi31h4vzl3lfiinx1zcgr4x";
  };

  patches = [ ./performous-cmake.patch ];

  nativeBuildInputs = [ cmake pkg-config gettext ];

  buildInputs = [
    glibmm libxmlxx pango librsvg
    SDL2 glew boost ffmpeg portaudio epoxy
  ];
}
