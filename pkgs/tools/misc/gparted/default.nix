{ stdenv, fetchurl, parted, gtk, glib, intltool, gettext, libuuid
, pkgconfig, gtkmm, gnomedocutils, libxml2 }:

stdenv.mkDerivation {
  name = "gparted-0.8.1";

  src = fetchurl {
    url = mirror://sourceforge/gparted/gparted-0.5.1/gparted-0.8.1.tar.bz2;
    sha256 = "128pnrcqp3d4a4jnjxm0mqglbyrs2q841pmg5g8ilyc827b6j163";
  };

  configureFlags = "--disable-doc";

  buildInputs =
    [ parted gtk glib intltool gettext libuuid pkgconfig gtkmm
      gnomedocutils libxml2
    ];

  meta = { 
    description = "Graphical disk partitioning tool";
    homepage = http://gparted.sourceforge.net;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
  };
}
