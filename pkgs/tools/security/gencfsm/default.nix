{ stdenv, fetchurl, autoconf, automake, intltool, libtool, pkgconfig, encfs
, glib , gnome3, gtk3, libgnome_keyring, vala, wrapGAppsHook, xorg }:

stdenv.mkDerivation rec {
  version = "1.8.15";
  name = "gnome-encfs-manager-${version}";

  src = fetchurl {
    url = "https://launchpad.net/gencfsm/trunk/1.8/+download/gnome-encfs-manager_${version}.tar.gz";
    sha256 = "1iryli6fgw6a45abkrjacfac7dwjhbrhw652rqf0s183373db0mx";
  };

  buildInputs = [ autoconf automake intltool libtool pkgconfig vala glib encfs
    gtk3 libgnome_keyring gnome3.libgee_1 xorg.libSM xorg.libICE
    wrapGAppsHook ];

  patches = [ ./makefile-mkdir.patch ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--disable-appindicator" ];

  preFixup = ''gappsWrapperArgs+=(--prefix PATH : ${encfs}/bin)'';

  meta = with stdenv.lib; {
    homepage = http://www.libertyzero.com/GEncfsM/;
    description = "EncFS manager and mounter with GNOME3 integration";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.spacefrogg ];
  };
}
