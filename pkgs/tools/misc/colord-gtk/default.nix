{ stdenv, fetchurl, colord, intltool, glib, gtk3, pkgconfig, lcms2 }:

stdenv.mkDerivation rec {
  name = "colord-gtk-0.1.26";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "0i9y3bb5apj6a0f8cx36l6mjzs7xc0k7nf0magmf58vy2mzhpl18";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool colord glib gtk3 lcms2 ];

  meta = {
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
