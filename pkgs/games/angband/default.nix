{ stdenv, fetchFromGitHub, autoreconfHook, ncurses5 }:

stdenv.mkDerivation rec {
  version = "4.1.2";
  name = "angband-${version}";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "1n18i8ni154ym3d32zlbxcw0zz62h66iifr0h1yvvv2kp13p5zix";
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
