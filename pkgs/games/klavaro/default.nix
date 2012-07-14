{ stdenv, fetchurl, pkgconfig, intltool, curl, gtk, gtkdatabox }:

stdenv.mkDerivation rec {
  name = "klavaro-1.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${name}.tar.bz2";
    sha256 = "06c35247866fb74f7c1a52a2350b352fdb44dace7216fdbebc1fa54990d14fc9";
  };

  buildInputs = [ pkgconfig intltool curl gtk gtkdatabox ];

  meta = {
    description = "Just another free touch typing tutor program";

    license = "GPLv3+";

    platforms = stdenv.lib.platforms.linux;
  };
}
