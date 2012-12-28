{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, networkmanager, GConf
, libnotify, libgnome_keyring, dbus_glib, polkit, isocodes
, mobile_broadband_provider_info }:

let
  pn = "network-manager-applet";
  major = "0.9";
  version = "${major}.4.1";
in

stdenv.mkDerivation rec {
  name = "network-manager-applet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pn}/${major}/${name}.tar.xz";
    sha256 = "b6b6de75e28d1fbcdfdbb51c0e40fcd6bc0ec0385bfecd16c457260491cd2ff7";
  };

  buildInputs = [
    gtk libglade networkmanager GConf libnotify libgnome_keyring dbus_glib
    polkit isocodes 
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  makeFlags = [
    ''CFLAGS=-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile_broadband_provider_info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
  ];

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom urkud rickynils ];
    platforms = platforms.linux;
  };
}
