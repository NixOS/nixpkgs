{ stdenv, fetchurl, parted, gtk, glib, intltool, gettext, libuuid
, pkgconfig, gtkmm, libxml2, hicolor_icon_theme
}:

stdenv.mkDerivation rec {
  name = "gparted-0.23.0";

  src = fetchurl {
    sha256 = "0m57bni3nkbbqq920ydzvasy2qc5j6w6bdssyn12jk4157gxvlbz";
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
  };

  configureFlags = "--disable-doc";

  buildInputs = [ parted gtk glib libuuid gtkmm libxml2 hicolor_icon_theme ];
  nativeBuildInputs = [ intltool gettext pkgconfig ];

  meta = with stdenv.lib; {
    description = "Graphical disk partitioning tool";
    longDescription = ''
      GNOME Partition Editor for creating, reorganizing, and deleting disk
      partitions. GParted enables you to change the partition organization
      while preserving the partition contents.
    '';
    homepage = http://gparted.org;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
