{ stdenv, fetchurl, intltool, pkgconfig, cmake
, ncurses, m17n_lib, m17n_db, expat
, withAnthy ? true, anthy ? null
, withGtk ? true
, withGtk2 ? withGtk, gtk2 ? null
, withGtk3 ? withGtk, gtk3 ? null
, withQt ? true
, withQt4 ? withQt, qt4 ? null
, withKde ? withQt
, withKde4 ? withKde && withQt4, kdelibs4 ? null, automoc4 ? null
}:

with stdenv.lib;

assert withAnthy -> anthy != null;
assert withGtk2 -> gtk2 != null;
assert withGtk3 -> gtk3 != null;
assert withQt4 -> qt4 != null;
assert withKde4 -> withQt4 && kdelibs4 != null && automoc4 != null;

stdenv.mkDerivation rec {
  version = "1.8.6";
  name = "uim-${version}";

  buildInputs = [
    intltool
    pkgconfig
    ncurses
    cmake
    m17n_lib
    m17n_db
    expat
  ]
  ++ optional withAnthy anthy
  ++ optional withGtk2 gtk2
  ++ optional withGtk3 gtk3
  ++ optional withQt4 qt4
  ++ optionals withKde4 [
    kdelibs4 automoc4
  ];

  patches = [ ./data-hook.patch ];

  configureFlags = [
    "--enable-pref"
    "--with-skk"
    "--with-x"
    "--with-xft"
    "--with-expat=${expat.dev}"
  ]
  ++ optional withAnthy "--with-anthy-utf8"
  ++ optional withGtk2 "--with-gtk2"
  ++ optional withGtk3 "--with-gtk3"
  ++ optionals withQt4 [
    "--with-qt4"
    "--with-qt4-immodule"
  ] ++ optionals withKde4 [
    "--enable-kde4-applet"
    "--enable-notify=knotify4"
  ];

  dontUseCmakeConfigure = true;

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uim/uim-${version}.tar.bz2";
    sha1 = "43b9dbdead6797880e6cfc9c032ecb2d37d42777";
  };

  meta = with stdenv.lib; {
    homepage    = "https://github.com/uim/uim";
    description = "A multilingual input method framework";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
