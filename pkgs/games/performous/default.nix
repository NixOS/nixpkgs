{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext
, glibmm, libxmlxx, pango, librsvg
, SDL2, glew, boost, libav, portaudio
}:

stdenv.mkDerivation {
  name = "performous-1.0";

  meta = with stdenv.lib; {
    description = "Karaoke, band and dancing game";
    homepage    = "http://performous.org/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "performous";
    repo = "performous";
    rev = "1.0";
    sha256 = "1wgydwnhadrjkj3mjzrhppfmphrxnqfljs361206imirmvs7s15l";
  };

  nativeBuildInputs = [ cmake pkgconfig gettext ];

  buildInputs = [
    glibmm libxmlxx pango librsvg
    SDL2 glew boost libav portaudio
  ];
}
