{ lib, stdenv, fetchurl, gettext, coreutils, gnused, gnome
, adwaita-icon-theme
, gnugrep, parted, glib, libuuid, pkg-config, gtkmm3, libxml2
, gpart, hdparm, procps, util-linux, polkit, wrapGAppsHook3, substituteAll
, mtools, dosfstools, xhost
}:

stdenv.mkDerivation rec {
  pname = "gparted";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/gparted/gparted-${version}.tar.gz";
    sha256 = "sha256-m59Rs85JTdy1mlXhrmZ5wJQ2YE4zHb9aU21g3tbG6ls=";
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

  enableParallelBuilding = true;

  configureFlags = [ "--disable-doc" "--enable-xhost-root" ];

  buildInputs = [ parted glib libuuid gtkmm3 libxml2 polkit.bin adwaita-icon-theme  ];
  nativeBuildInputs = [ gettext pkg-config wrapGAppsHook3 ];

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix PATH : "${lib.makeBinPath [ gpart hdparm util-linux procps coreutils gnused gnugrep mtools dosfstools xhost ]}"
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
    mainProgram = "gparted";
  };
}
