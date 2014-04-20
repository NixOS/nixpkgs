{ stdenv, fetchurl, colord, intltool, glib, gtk3, pkgconfig, lcms2 }:

stdenv.mkDerivation rec {
  name = "colord-gtk-0.1.25";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "02hblw9rw24dhj0wqfw86pfq4y4icb6iaa92308a9jwa6k2923xx";
  };

  buildInputs = [ intltool colord glib gtk3 pkgconfig lcms2 ];

  meta = {
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
