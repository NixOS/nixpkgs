{ fetchurl, stdenv, pkgconfig, glib
, useGtk ? true, gtk ? null
, useNcurses ? true, ncurses ? null
, useQt4 ? false, qt4 ? null }:

assert useGtk -> (gtk != null);
assert useNcurses -> (ncurses != null);
assert useQt4 -> (qt4 != null);

stdenv.mkDerivation rec {
  name = "pinentry-0.8.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.gz";
    sha256 = "06phs3gbs6gf0z9g28z3jgsw312dhhpdgzrx4hhps53xrbwpyv22";
  };

  buildInputs = [ glib pkgconfig gtk ncurses ] ++ stdenv.lib.optional useQt4 qt4;

  meta = { 
    description = "GnuPG's interface to passphrase input";

    longDescription = ''
      Pinentry provides a console and a GTK+ GUI that allows users to
      enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';

    homepage = http://gnupg.org/aegypten2/;
    license = "GPLv2+";
  };
}
