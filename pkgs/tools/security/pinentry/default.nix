{ fetchurl, stdenv, pkgconfig
, libcap ? null, ncurses ? null, gtk2 ? null, qt4 ? null
}:

let
  hasX = gtk2 != null || qt4 != null;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "pinentry-0.9.1";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "15cn7q6wg3k433l9ks48pz4dbikp7ysp0h8jqynz6p9rdf2qxl4w";
  };

  buildInputs = [ libcap gtk2 ncurses qt4 ];

  configureFlags = [
    (mkWith   (libcap != null)  "libcap"          null)
    (mkWith   (hasX)            "x"               null)
    (mkEnable (ncurses != null) "pinentry-curses" null)
    (mkEnable true              "pinentry-tty"    null)
    (mkEnable (gtk2 != null)    "pinentry-gtk2"   null)
    (mkEnable (qt4 != null)     "pinentry-qt4"    null)
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = "http://gnupg.org/aegypten2/";
    description = "GnuPG's interface to passphrase input";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    longDescription = ''
      Pinentry provides a console and a GTK+ GUI that allows users to
      enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
  };
}
