{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk2 }:

stdenv.mkDerivation {
  name = "mate-themes-1.6.3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/1.6/mate-themes-1.6.3.tar.xz";
    sha256 = "1wakr9z3byw1yvnbaxg8cpfhp1bp1fmnaz742738m0fx6bzznj9i";
  };

  buildInputs = [ pkgconfig intltool iconnamingutils gtk2 ];

  meta = {
    description = "A set of themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}
