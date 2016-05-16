{stdenv, fetchurl, intltool, pkgconfig, qt4, gtk2, gtk3, kdelibs, ncurses,
 cmake, anthy, automoc4, m17n_lib, m17n_db}:

stdenv.mkDerivation rec {
  version = "1.8.6";
  name = "uim-${version}";

  buildInputs = [
    intltool
    pkgconfig
    qt4
    gtk2
    gtk3
    kdelibs
    ncurses
    cmake
    anthy
    automoc4
    m17n_lib
    m17n_db
  ];

  patches = [ ./data-hook.patch ];

  configureFlags = [
    "--with-gtk2"
    "--with-gtk3"
    "--enable-kde4-applet"
    "--enable-notify=knotify4"
    "--enable-pref"
    "--with-qt4"
    "--with-qt4-immodule"
    "--with-skk"
    "--with-x"
    "--with-anthy-utf8"
  ];

  dontUseCmakeConfigure = true;

  src = fetchurl {
    url = "http://uim.googlecode.com/files/uim-${version}.tar.bz2";
    sha1 = "43b9dbdead6797880e6cfc9c032ecb2d37d42777";
  };

  meta = with stdenv.lib; {
    homepage    = "http://code.google.com/p/uim/";
    description = "A multilingual input method framework";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
