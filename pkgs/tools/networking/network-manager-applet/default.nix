{ stdenv, fetchurl, intltool, pkgconfig, gtk, glib, libglade
, networkmanager, GConf, libnotify, gnome_keyring, dbus_glib
, polkit}:
stdenv.mkDerivation rec {

  name = "network-manager-applet-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/network-manager-applet/0.8/network-manager-applet-${version}.tar.bz2";
    sha256 = "0rn3mr0v8i3bkfhpvx6bbyhv1i6j6s120pkayq2318bg5ivbk12a";
  };

  buildInputs = [ intltool pkgconfig gtk glib libglade networkmanager GConf libnotify
                  gnome_keyring dbus_glib polkit];

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control appler for GNOME.";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}