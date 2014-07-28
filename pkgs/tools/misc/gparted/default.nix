{ stdenv, fetchurl, parted, gtk, glib, intltool, gettext, libuuid
, pkgconfig, gtkmm, libxml2 }:

stdenv.mkDerivation rec {
  name = "gparted-0.18.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
    sha256 = "0slyf0sbv7a7xvdcpn9ibnixpy0w4s6zwpz6sklkxcyfybw1j7xz";
  };

  configureFlags = "--disable-doc";

  buildInputs = [
    parted gtk glib intltool gettext libuuid pkgconfig gtkmm libxml2
  ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    description = "Graphical disk partitioning tool";
    homepage = http://gparted.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux;
  };
}
