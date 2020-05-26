{ stdenv, fetchgit, cmake, pkgconfig, SDL, SDL2, ncurses, docbook_xsl, git }:

stdenv.mkDerivation {
  pname = "sdl-jstest";
  version = "2018-06-15";

  # Submodules
  src = fetchgit {
    url = "https://github.com/Grumbel/sdl-jstest";
    rev = "aafbdb1ed3e687583037ba55ae88b1210d6ce98b";
    sha256 = "0p4cjzcq0bbkzad19jwdklylqhq2q390q7dpg8bfzl2rwls883rk";
  };

  buildInputs = [ SDL SDL2 ncurses ];
  nativeBuildInputs = [ cmake pkgconfig docbook_xsl git ];
  
  meta = with stdenv.lib; {
    homepage = "https://github.com/Grumbel/sdl-jstest";
    description = "Simple SDL joystick test application for the console";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
