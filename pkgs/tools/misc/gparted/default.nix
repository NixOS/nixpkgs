{ stdenv, fetchurl, parted, gtk, glib, intltool, gettext, libuuid
, pkgconfig, gtkmm, libxml2 }:

stdenv.mkDerivation rec {
  name = "gparted-0.21.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
    sha256 = "1ab56pplnlnqnhvvgfx1s47g9iz78sb048xlwv7v7hzzx16c73rr";
  };

  configureFlags = "--disable-doc";

  buildInputs = [
    parted gtk glib intltool gettext libuuid pkgconfig gtkmm libxml2
  ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = with stdenv.lib; {
    description = "Graphical disk partitioning tool";
    longDescription = ''
      GNOME Partition Editor for creating, reorganizing, and deleting disk
      partitions. GParted enables you to change the partition organization
      while preserving the partition contents.
    '';
    homepage = http://gparted.sourceforge.net;
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
