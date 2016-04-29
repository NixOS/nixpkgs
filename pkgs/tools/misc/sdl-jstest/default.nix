{ fetchgit, stdenv, cmake, pkgconfig, SDL, SDL2, ncurses, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "sdl-jstest-20150806";
  src = fetchgit {
    url = "https://github.com/Grumbel/sdl-jstest";
    rev = "7b792376178c9656c851ddf106c7d57b2495e8b9";
    sha256 = "3aa9a002de9c9999bd7c6248b94148f15dba6106489e418b2a1a410324f75eb8";
  };

  buildInputs = [ SDL SDL2 ncurses ];
  nativeBuildInputs = [ cmake pkgconfig docbook_xsl ];
  
  meta = with stdenv.lib; {
    homepage = "https://github.com/Grumbel/sdl-jstest";
    description = "Simple SDL joystick test application for the console";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
