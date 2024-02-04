{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "nudoku";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jubalh";
    repo = pname;
    rev = version;
    hash = "sha256-BWUwIsw9Ym4q/FsphAoJXNppzr2UFCOojgdi6Pf9sKQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config gettext ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "An ncurses based sudoku game";
    homepage = "http://jubalh.github.io/nudoku/";
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill weathercold ];
  };
}
