{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk2 }:

stdenv.mkDerivation {
  name = "mate-themes-1.6.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/1.6/mate-themes-1.6.1.tar.xz";
    sha256 = "0lm2kvlwj0rpznb0n2g1sh1r6nz0p45i7flbnxivl9gi632wdmfp";
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
