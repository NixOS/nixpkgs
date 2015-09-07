{ fetchgit, stdenv, cmake, pkgconfig, SDL, SDL2, ncurses, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "sdl-jstest-20150625";
  src = fetchgit {
    url = "https://github.com/Grumbel/sdl-jstest";
    rev = "3f54b86ebe0d2f95e9c1d034bc4ed02d6d2b6409";
    sha256 = "d33e0a2c66b551ecf333590f1a6e1730093af31cee1be8757748624d42e14df1";
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
