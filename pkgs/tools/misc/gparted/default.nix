{ stdenv, fetchurl, parted, gtk, glib, intltool, gettext, libuuid
, pkgconfig, gtkmm, libxml2 }:

stdenv.mkDerivation rec {
  name = "gparted-0.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
    sha256 = "03s9dp2q281lkkfjgk9ahc8i6dk4d2a03z4bh2d19a7r3b2mmdww";
  };

  configureFlags = "--disable-doc";

  buildInputs = [
    parted gtk glib intltool gettext libuuid pkgconfig gtkmm libxml2
  ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    description = "Graphical disk partitioning tool";
    homepage = http://gparted.sourceforge.net;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
  };
}
