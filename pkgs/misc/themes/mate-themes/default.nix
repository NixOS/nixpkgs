{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk2 }:

stdenv.mkDerivation {
  name = "mate-themes-1.6.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/1.6/mate-themes-1.6.2.tar.xz";
    sha256 = "145mjdijjvkpjjgqdfwjp30jvvs0qzxlnh15q6mig8df6drg5fn6";
  };

  buildInputs = [ pkgconfig intltool iconnamingutils gtk2 ];

  meta = {
    description = "A set of themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };
}
