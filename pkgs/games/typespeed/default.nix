{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "typespeed-0.6.5";
  builder = ./builder.sh;
  buildInputs = [ ncurses ];
  configureFlags = "--with-highscoredir=/tmp";
  src = fetchurl {
    url = http://typespeed.sourceforge.net/typespeed-0.6.5.tar.gz;
    sha256 = "5c860385ceed8a60f13217cc0192c4c2b4705c3e80f9866f7d72ff306eb72961";
  };
}
