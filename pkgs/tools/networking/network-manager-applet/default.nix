{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, networkmanager, GConf
, libnotify, libsecret, dbus_glib, polkit, isocodes, libgnome_keyring
, mobile_broadband_provider_info, glib_networking, gsettings_desktop_schemas
, makeWrapper, networkmanager_openvpn, udev }:

let
  pn = "network-manager-applet";
  major = "0.9";
  version = "${major}.8.2";
in

stdenv.mkDerivation rec {
  name = "network-manager-applet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pn}/${major}/${name}.tar.xz";
    sha256 = "1ixd19b7ap29lz9lq4mmlq9lqsmnisix1a33hrxrl68wjx1wfh55";
  };

  buildInputs = [
    gtk libglade networkmanager GConf libnotify libsecret dbus_glib
    polkit isocodes makeWrapper udev libgnome_keyring
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  makeFlags = [
    ''CFLAGS=-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile_broadband_provider_info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
  ];

  postInstall = ''
    ln -s ${networkmanager_openvpn}/etc/NetworkManager $out/etc/NetworkManager
    ln -s ${networkmanager_openvpn}/lib/* $out/lib
    wrapProgram "$out/bin/nm-applet" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share:$out/share" \
      --set GCONF_CONFIG_SOURCE "xml::~/.gconf" \
      --prefix PATH ":" "${GConf}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom urkud rickynils ];
    platforms = platforms.linux;
  };
}
