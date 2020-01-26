{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "2.44";
  pname = "frotz";

  src = fetchFromGitHub {
    owner = "DavidGriffith";
    repo = "frotz";
    rev = version;
    sha256 = "0gjkk4gxzqmxfdirrz2lr0bms6l9fc31vkmlywigkbdlh8wxgypp";
  };

  makeFlags = [ "CC=cc" "PREFIX=$(out)" "CURSES=-lncurses" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = http://frotz.sourceforge.net/;
    description = "A z-machine interpreter for Infocom games and other interactive fiction.";
    platforms = platforms.unix;
    maintainers = [ maintainers.nicknovitski ];
    license = licenses.gpl2;
  };
}
