{ stdenv, fetchurl, pkgconfig, intltool, curl, gtk, gtkdatabox }:

stdenv.mkDerivation rec {
  name = "klavaro-2.00";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${name}.tar.bz2";
    sha256 = "1w94r7r132sg7554xhcgvymxxxgfas99lkgv6j3nmxa8m2fzhwlq";
  };

  buildInputs = [ pkgconfig intltool curl gtk gtkdatabox ];

  meta = {
    description = "Just another free touch typing tutor program";

    license = "GPLv3+";

    platforms = stdenv.lib.platforms.linux;
  };
}
