{ fetchurl, stdenv, pkgconfig, glib
, useGtk ? !stdenv.isDarwin, gtk
, useNcurses ? true, ncurses
, useQt4 ? false, qt4 }:

assert useGtk || useNcurses || useQt4;

stdenv.mkDerivation rec {
  name = "pinentry-0.9.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "1awhajq21hcjgqfxg9czaxg555gij4bba6axrwg8w6lfmc3ml14h";
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
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Pinentry provides a console and a GTK+ GUI that allows users to
      enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
  };
}
