{ stdenv, fetchFromGitHub, autoreconfHook, ncurses5 }:

stdenv.mkDerivation rec {
  version = "4.0.5";
  name = "angband-${version}";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "1l7ybqmsxpsijm7iqiqjpa7lhjafxml743q4crxn8wnwrbjzbi86";
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
