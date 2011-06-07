{ fetchurl, stdenv, pkgconfig, glib
, useGtk ? true, gtk
, useNcurses ? true, ncurses
, useQt4 ? false, qt4 }:

assert useGtk || useNcurses || useQt4;

stdenv.mkDerivation rec {
  name = "pinentry-0.8.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.gz";
    sha256 = "06phs3gbs6gf0z9g28z3jgsw312dhhpdgzrx4hhps53xrbwpyv22";
  };

  buildInputs = let opt = stdenv.lib.optional; in []
    ++ opt useGtk glib
    ++ opt useGtk gtk
    ++ opt useNcurses ncurses
    ++ opt useQt4 qt4;

  configureFlags = [ "--disable-pinentry-gtk" "--disable-pinentry-qt" ]
    ++ (if useGtk || useQt4 then ["--with-x"] else ["--without-x"])
    ++ (if useGtk then ["--enable-pinentry-gtk2"] else ["--disable-pinentry-gtk"])
    ++ (if useQt4 then ["--enable-pinentry-qt4"] else ["--disable-pinentry-qt4"]);

  buildNativeInputs = [ pkgconfig ];

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
