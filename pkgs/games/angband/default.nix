{ stdenv, fetchFromGitHub, autoreconfHook, ncurses5 }:

stdenv.mkDerivation rec {
  version = "4.1.3";
  name = "angband-${version}";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "0g9m7pq8a1hzhr83v552hfk37qc868lms2mlsq29pbi8vxdjybk7";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses5 ];
  installFlags = "bindir=$(out)/bin";

  meta = with stdenv.lib; {
    homepage = http://rephial.org/;
    description = "A single-player roguelike dungeon exploration game";
    maintainers = [ maintainers.chattered ];
    license = licenses.gpl2;
  };
}
