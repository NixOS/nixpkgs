{ stdenv, fetchFromGitHub, autoreconfHook, ncurses5 }:

stdenv.mkDerivation rec {
  pname = "angband";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "174fphiywwb4yb3kqavwaysx7c97an2n8wjbm4p4d41i1svjsryz";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses5 ];
  installFlags = [ "bindir=$(out)/bin" ];

  meta = with stdenv.lib; {
    homepage = "http://rephial.org/";
    description = "A single-player roguelike dungeon exploration game";
    maintainers = [ maintainers.chattered ];
    license = licenses.gpl2;
  };
}
