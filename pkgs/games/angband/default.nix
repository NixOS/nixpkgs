{ stdenv, fetchFromGitHub, autoreconfHook, ncurses5 }:

stdenv.mkDerivation rec {
  pname = "angband";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "0fr59986swx9a2xkxkbfgadzpwy2lq55fgcib05k393kibyz49kg";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses5 ];
  installFlags = [ "bindir=$(out)/bin" ];

  meta = with stdenv.lib; {
    homepage = http://rephial.org/;
    description = "A single-player roguelike dungeon exploration game";
    maintainers = [ maintainers.chattered ];
    license = licenses.gpl2;
  };
}
