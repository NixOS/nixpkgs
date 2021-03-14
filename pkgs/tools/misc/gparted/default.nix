{ lib, stdenv, fetchurl, intltool, gettext, makeWrapper, coreutils, gnused, gnome3
, gnugrep, parted, glib, libuuid, pkg-config, gtkmm3, libxml2
, gpart, hdparm, procps, util-linux, polkit, wrapGAppsHook, substituteAll
}:

stdenv.mkDerivation rec {
  name = "gparted-1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/${name}.tar.gz";
    sha256 = "sha256-bJBxXSVNen7AIIspAHtkFg3Z+330xKp/jsLJ0jEUxxk=";
  };

  # Tries to run `pkexec --version` to get version.
  # however the binary won't be suid so it returns
  # an error preventing the program from detection
  patches = [
    (substituteAll {
      src = ./polkit.patch;
      polkit_version = polkit.version;
    })
  ];

  configureFlags = [ "--disable-doc" ];

  buildInputs = [ parted glib libuuid gtkmm3 libxml2 polkit.bin gnome3.adwaita-icon-theme  ];
  nativeBuildInputs = [ intltool gettext pkg-config wrapGAppsHook ];

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix PATH : "${lib.makeBinPath [ gpart hdparm util-linux procps coreutils gnused gnugrep ]}"
    )
  '';

  # Doesn't get installed automaticallly if PREFIX != /usr
  postInstall = ''
    install -D -m0644 org.gnome.gparted.policy \
      $out/share/polkit-1/actions/org.gnome.gparted.policy
  '';

  meta = with lib; {
    description = "Graphical disk partitioning tool";
    longDescription = ''
      GNOME Partition Editor for creating, reorganizing, and deleting disk
      partitions. GParted enables you to change the partition organization
      while preserving the partition contents.
    '';
    homepage = "https://gparted.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
