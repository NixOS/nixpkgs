{ stdenv, fetchurl, intltool, pkgconfig, gtk, glib, libglade
, networkmanager, GConf, libnotify, gnome_keyring, dbus_glib
, polkit, xz }:

let
  pn = "network-manager-applet";
  major = "0.9";
  version = "${major}.0";
in

stdenv.mkDerivation rec {
  name = "network-manager-applet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pn}/${major}/${name}.tar.xz";
    sha256 = "097y7c29bgd9wm0im06ka3cd94zssg4s626y5lw7yrypq3hzg18f";
  };

  buildInputs = [ gtk libglade networkmanager GConf libnotify gnome_keyring
    polkit];

  buildNativeInputs = [ intltool pkgconfig xz ];

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.urkud ];
    platforms = platforms.linux;
  };
}
