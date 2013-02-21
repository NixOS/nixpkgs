{ stdenv, fetchurl, parted, gtk, glib, intltool, gettext, libuuid
, pkgconfig, gtkmm, libxml2 }:

stdenv.mkDerivation rec {
  name = "gparted-0.14.1";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
    sha256 = "0697sq2dbs9cn689bk68gs9pj3k08bfp9wfg6j291zrprdd3rddi";
  };

  configureFlags = "--disable-doc";

  buildInputs = [
    parted gtk glib intltool gettext libuuid pkgconfig gtkmm libxml2
  ];

  meta = {
    description = "Graphical disk partitioning tool";
    homepage = http://gparted.sourceforge.net;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
  };
}
