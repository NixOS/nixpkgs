{ stdenv, fetchurl, autoconf, automake, intltool, libtool, pkgconfig, encfs
, glib , gnome3, gtk3, libgnome-keyring, vala, wrapGAppsHook, xorg, gobject-introspection
}:

stdenv.mkDerivation rec {
  version = "1.8.19";
  name = "gnome-encfs-manager-${version}";

  src = fetchurl {
    url = "https://launchpad.net/gencfsm/trunk/1.8/+download/gnome-encfs-manager_${version}.tar.xz";
    sha256 = "1h6x8dyp1fvxvr8fwki98ppf4sa20qf7g59jc9797b2vrgm60h1i";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake intltool libtool vala glib encfs
    gtk3 libgnome-keyring gnome3.libgee xorg.libSM xorg.libICE
    wrapGAppsHook gobject-introspection  ];

  patches = [ ./makefile-mkdir.patch ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--disable-appindicator" ];

  preFixup = ''gappsWrapperArgs+=(--prefix PATH : ${encfs}/bin)'';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.libertyzero.com/GEncfsM/;
    downloadPage = https://launchpad.net/gencfsm/;
    description = "EncFS manager and mounter with GNOME3 integration";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.spacefrogg ];
  };
}
