{ lib, stdenv, fetchgit, cmake, pkg-config, SDL, SDL2, ncurses, docbook_xsl, git }:

stdenv.mkDerivation {
  pname = "sdl-jstest";
  version = "20180114";

  # Submodules
  src = fetchgit {
    url = "https://github.com/Grumbel/sdl-jstest";
    rev = "aafbdb1ed3e687583037ba55ae88b1210d6ce98b";
    sha256 = "sha256-Mw+ENOVZ0O8WercdDNLAAkNMPZ2NyxSa+nMtgNmXjFw=";
  };

  buildInputs = [ SDL SDL2 ncurses ];
  nativeBuildInputs = [ cmake pkg-config docbook_xsl git ];

  meta = with lib; {
    homepage = "https://github.com/Grumbel/sdl-jstest";
    description = "Simple SDL joystick test application for the console";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
