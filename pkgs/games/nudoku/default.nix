{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "nudoku";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jubalh";
    repo = pname;
    rev = version;
    hash = "sha256-b8IZIoyFGBe17UtFPHPNJ7cCh+HA4NIfmFJ3LtfcZes=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config gettext ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "An ncurses based sudoku game";
    mainProgram = "nudoku";
    homepage = "https://jubalh.github.io/nudoku";
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill weathercold ];
  };
}
