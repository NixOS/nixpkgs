{stdenv, fetchurl, intltool, pkgconfig, qt4, gtk2, gtk3, kdelibs, cmake, ... }:

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
    cmake
  ];

  patches = [ ./immodules_cache.patch ];

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
  ];

  dontUseCmakeConfigure = true;

  src = fetchurl {
    url = "http://uim.googlecode.com/files/uim-${version}.tar.bz2";
    sha1 = "43b9dbdead6797880e6cfc9c032ecb2d37d42777";
  };

  meta = {
    homepage = "http://code.google.com/p/uim/";
    description = "A multilingual input method framework";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
