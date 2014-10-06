{ stdenv, fetchurl, parted, gtk, glib, intltool, gettext, libuuid
, pkgconfig, gtkmm, libxml2 }:

stdenv.mkDerivation rec {
  name = "gparted-0.19.1";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
    sha256 = "1x0mbks94jpzphb8hm8w0iqjrn665jkdm4qnzrvxrnvy0x3m2fwd";
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
