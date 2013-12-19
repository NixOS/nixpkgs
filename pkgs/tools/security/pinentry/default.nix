{ fetchurl, stdenv, pkgconfig, glib
, useGtk ? true, gtk
, useNcurses ? true, ncurses
, useQt4 ? false, qt4 }:

assert useGtk || useNcurses || useQt4;

stdenv.mkDerivation rec {
  name = "pinentry-0.8.3";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "1bd047crf7xb8g61mval8v6qww98rddlsw2dz6j8h8qbnl4hp2sn";
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

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = "http://gnupg.org/aegypten2/";
    description = "GnuPG's interface to passphrase input";
    license = "GPLv2+";

    longDescription = ''
      Pinentry provides a console and a GTK+ GUI that allows users to
      enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
  };
}
