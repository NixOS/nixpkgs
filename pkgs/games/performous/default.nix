{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext
, glibmm, libxmlxx, pango, librsvg
, SDL2, glew, boost, libav, portaudio, epoxy
}:

stdenv.mkDerivation rec {
  name = "performous-${version}";
  version = "1.1";

  meta = with stdenv.lib; {
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

  nativeBuildInputs = [ cmake pkgconfig gettext ];

  buildInputs = [
    glibmm libxmlxx pango librsvg
    SDL2 glew boost libav portaudio epoxy
  ];
}
