{ stdenv, fetchurl, autoconf, automake, intltool, libtool, pkgconfig, encfs
, glib , gnome3, gtk3, libgnome_keyring, vala, wrapGAppsHook, xorg }:

stdenv.mkDerivation rec {
  version = "1.8.16";
  name = "gnome-encfs-manager-${version}";

  src = fetchurl {
    url = "https://launchpad.net/gencfsm/trunk/1.8/+download/gnome-encfs-manager_${version}.tar.gz";
    sha256 = "06sz6zcmvxkqww5gx4brcqs4hlpy9d8sal9nmw0pdsvh8k5vmpgn";
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
