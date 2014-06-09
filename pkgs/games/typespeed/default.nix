{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "typespeed-0.6.5";
  buildInputs = [ ncurses ];
  src = fetchurl {
    url = http://typespeed.sourceforge.net/typespeed-0.6.5.tar.gz;
    sha256 = "5c860385ceed8a60f13217cc0192c4c2b4705c3e80f9866f7d72ff306eb72961";
  };

  patches = [ ./typespeed-config-in-home.patch ];

  configureFlags = "--datadir=\${out}/share/";

  meta = {
    description = "A curses based typing game.";
    homepage = http://typespeed.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
