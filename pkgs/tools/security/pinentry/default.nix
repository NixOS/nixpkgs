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
  name = "pinentry-0.9.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "1awhajq21hcjgqfxg9czaxg555gij4bba6axrwg8w6lfmc3ml14h";
  };

  buildInputs = [ libcap gtk2 ncurses qt4 ];

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
      Pinentry provides a console and a GTK+ GUI that allows users to
      enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
  };
}
