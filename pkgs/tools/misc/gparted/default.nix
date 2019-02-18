{ stdenv, fetchurl, intltool, gettext, makeWrapper
, parted, glib, libuuid, pkgconfig, gtkmm2, libxml2, hicolor-icon-theme
, gpart, hdparm, procps, utillinux
}:

stdenv.mkDerivation rec {
  name = "gparted-0.33.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.gz";
    sha256 = "1ml1ky3s75lbxr91p608q3prsdh9x899mw7nbgk252pqhg4vh8sh";
  };

  configureFlags = [ "--disable-doc" ];

  buildInputs = [ parted glib libuuid gtkmm2 libxml2 hicolor-icon-theme ];
  nativeBuildInputs = [ intltool gettext makeWrapper pkgconfig ];

  postInstall = ''
    wrapProgram $out/bin/gparted \
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
    homepage = https://gparted.org;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
