{ fetchgit, stdenv, cmake, pkgconfig, SDL, SDL2, ncurses, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "sdl-jstest-20150611";
  src = fetchgit {
    url = "https://github.com/Grumbel/sdl-jstest";
    rev = "684d168e5526da16760dcfc6d40da0103ab284cc";
    sha256 = "fc110a858edc2defc5cd8b176a5ce74666d3957d0268b861d0f9669362a1bd03";
  };

  buildInputs = [ SDL SDL2 ncurses ];
  nativeBuildInputs = [ cmake pkgconfig docbook_xsl ];
  
  meta = with stdenv.lib; {
    homepage = https://github.com/Grumbel/sdl-jstest;
    description = "Simple SDL joystick test application for the console";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
