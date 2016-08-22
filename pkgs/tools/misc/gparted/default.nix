{ stdenv, fetchurl, intltool, gettext, makeWrapper
, parted, gtk, glib, libuuid, pkgconfig, gtkmm, libxml2, hicolor_icon_theme
, gpart, hdparm, procps, utillinux
}:

stdenv.mkDerivation rec {
  name = "gparted-0.26.1";

  src = fetchurl {
    sha256 = "1h9d6x335wxpm49yphzm9n1hbh2hcg0p2rphv76mrvsss91bcm1g";
    url = "mirror://sourceforge/gparted/${name}.tar.gz";
  };

  configureFlags = [ "--disable-doc" ];

  buildInputs = [ parted gtk glib libuuid gtkmm libxml2 hicolor_icon_theme ];
  nativeBuildInputs = [ intltool gettext makeWrapper pkgconfig ];

  postInstall = ''
    wrapProgram $out/sbin/gparted \
      --prefix PATH : "${procps}/bin"
    wrapProgram $out/sbin/gpartedbin \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gpart hdparm utillinux ]}"
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
