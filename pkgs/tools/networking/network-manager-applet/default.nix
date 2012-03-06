{ stdenv, fetchurl, intltool, pkgconfig, gtk, glib, libglade
, networkmanager, GConf, libnotify, gnome_keyring, dbus_glib
, polkit, isocodes }:

let
  pn = "network-manager-applet";
  major = "0.9";
  version = "${major}.2.0";
in

stdenv.mkDerivation rec {
  name = "network-manager-applet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pn}/${major}/${name}.tar.xz";
    sha256 = "ebe725d0140f658c6a3f384674c72fba7a7c417df3be0e84ee8f45e6dfc219de";
  };

  buildInputs = [ gtk libglade networkmanager GConf libnotify gnome_keyring
    polkit isocodes ];

  buildNativeInputs = [ intltool pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.urkud ];
    platforms = platforms.linux;
  };
}
