{ stdenv, fetchurl, intltool, gettext, makeWrapper
, parted, gtk, glib, libuuid, pkgconfig, gtkmm, libxml2, hicolor_icon_theme
, hdparm, utillinux
}:

stdenv.mkDerivation rec {
  name = "gparted-0.24.0";

  src = fetchurl {
    sha256 = "0q6d1s9f4qgdivj4vm9w87qmdfyq8s65jzkhv05rp9cl72rqlf82";
    url = "mirror://sourceforge/gparted/${name}.tar.bz2";
  };

  configureFlags = "--disable-doc";

  buildInputs = [ parted gtk glib libuuid gtkmm libxml2 hicolor_icon_theme ];
  nativeBuildInputs = [ intltool gettext makeWrapper pkgconfig ];

  postInstall = ''
    wrapProgram $out/sbin/gpartedbin \
      --prefix PATH : "${hdparm}/bin:${utillinux}/bin"
  '';

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
