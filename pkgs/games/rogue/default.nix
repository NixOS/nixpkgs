{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "rogue-5.4.2";
  src = fetchurl {
    url = http://rogue.rogueforge.net/files/rogue5.4/rogue5.4.2-src.tar.gz;
    md5 = "bd656cb017a579eba835a0ee445a0a32";
  };
  setSourceRoot = "sourceRoot=.";
  buildInputs = [ncurses];
  preBuild = "
    ln -s ${ncurses}/include ncurses
    substituteInPlace Makefile --replace curses ncurses
  ";
  installPhase = "
    ensureDir $out/bin
    cp rogue54 $out/bin
    ln -s rogue54 $out/bin/rogue
  ";
  NIX_CFLAGS_COMPILE = "-I.";
}
