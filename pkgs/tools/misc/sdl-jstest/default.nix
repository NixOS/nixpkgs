{ fetchFromGitHub, stdenv, cmake, pkgconfig, SDL, SDL2, ncurses, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "sdl-jstest-${version}";
  version = "2016-03-29";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "sdl-jstest";
    rev = "301a0e8cf3f96de4c5e58d9fe4413e5cd2b4e6d4";
    sha256 = "1qrz09by5snc3n1wppf2y0pj7rx29dlh1g84glga8vvb03n3yb14";
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
