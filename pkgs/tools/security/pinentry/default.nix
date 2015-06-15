{ fetchurl, stdenv, pkgconfig
, libcap ? null, ncurses ? null, gtk2 ? null, qt4 ? null
}:

let
  mkFlag = pfxTrue: pfxFalse: cond: name: "--${if cond then pfxTrue else pfxFalse}-${name}";
  mkEnable = mkFlag "enable" "disable";
  mkWith = mkFlag "with" "without";
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

  # configure cannot find moc on its own
  preConfigure = stdenv.lib.optionalString (qt4 != null) ''
    export QTDIR="${qt4}"
    export MOC="${qt4}/bin/moc"
  '';

  configureFlags = [
    (mkWith   (libcap != null)  "libcap")
    (mkWith   (hasX)            "x")
    (mkEnable (ncurses != null) "pinentry-curses")
    (mkEnable true              "pinentry-tty")
    (mkEnable (gtk2 != null)    "pinentry-gtk2")
    (mkEnable (qt4 != null)     "pinentry-qt4")
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = "http://gnupg.org/aegypten2/";
    description = "GnuPG's interface to passphrase input";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK+ and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
