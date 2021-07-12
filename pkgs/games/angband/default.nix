{ lib, stdenv, fetchFromGitHub, autoreconfHook, ncurses5 }:

stdenv.mkDerivation rec {
  pname = "angband";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "sha256-z1HTt3+lWIr2F9YZFdw47lkYVgYl17qbb/OJ9YyYQa8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses5 ];
  installFlags = [ "bindir=$(out)/bin" ];

  meta = with lib; {
    homepage = "http://rephial.org/";
    description = "A single-player roguelike dungeon exploration game";
    maintainers = [ maintainers.chattered ];
    license = licenses.gpl2;
  };
}
