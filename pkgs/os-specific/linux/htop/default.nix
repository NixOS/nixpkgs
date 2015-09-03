{ fetchFromGitHub, stdenv, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-1.0.3-584-8f07868f";

  src = fetchFromGitHub {
    sha256 = "0s7l9v7n7hw32hznvdq2sykyxgb30hmzycwcjxw8f0c2mww61xcd";
    rev = "8f07868fefeb844a852fab704c0763b0e9a9bf01";
    repo = "htop";
    owner = "hishamhm";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rob simons relrod ];
  };
}
