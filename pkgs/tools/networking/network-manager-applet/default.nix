{ stdenv, fetchurl, intltool, pkgconfig, libglade, networkmanager, gnome3
, libnotify, libsecret, dbus_glib, polkit, isocodes, libgnome_keyring 
, mobile_broadband_provider_info, glib_networking, gsettings_desktop_schemas
, makeWrapper, networkmanager_openvpn, networkmanager_vpnc
, networkmanager_openconnect, udev, hicolor_icon_theme }:

let
  pn = "network-manager-applet";
  major = "0.9";
  version = networkmanager.version;
in

stdenv.mkDerivation rec {
  name = "network-manager-applet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pn}/${major}/${name}.tar.xz";
    sha256 = "1sx97cp9nb5p82kg2dl6dmqri7wichpjqchhx7bk77limngby7jq";
  };

  buildInputs = [
    gnome3.gtk libglade networkmanager libnotify libsecret dbus_glib
    polkit isocodes makeWrapper udev gnome3.gconf gnome3.libgnome_keyring
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  propagatedUserEnvPkgs = [ gnome3.gconf gnome3.gnome_keyring hicolor_icon_theme ];

  makeFlags = [
    ''CFLAGS=-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile_broadband_provider_info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
  ];

  postInstall = ''
    mkdir -p $out/etc/NetworkManager/VPN
    ln -s ${networkmanager_openvpn}/etc/NetworkManager/VPN/nm-openvpn-service.name $out/etc/NetworkManager/VPN/nm-openvpn-service.name
    ln -s ${networkmanager_vpnc}/etc/NetworkManager/VPN/nm-vpnc-service.name $out/etc/NetworkManager/VPN/nm-vpnc-service.name
    ln -s ${networkmanager_openconnect}/etc/NetworkManager/VPN/nm-openconnect-service.name $out/etc/NetworkManager/VPN/nm-openconnect-service.name
    mkdir -p $out/lib/NetworkManager
    ln -s ${networkmanager_openvpn}/lib/NetworkManager/* $out/lib/NetworkManager/
    ln -s ${networkmanager_vpnc}/lib/NetworkManager/* $out/lib/NetworkManager/
    ln -s ${networkmanager_openconnect}/lib/NetworkManager/* $out/lib/NetworkManager/
    mkdir -p $out/libexec
    ln -s ${networkmanager_openvpn}/libexec/* $out/libexec/
    ln -s ${networkmanager_vpnc}/libexec/* $out/libexec/
    ln -s ${networkmanager_openconnect}/libexec/* $out/libexec/
    wrapProgram "$out/bin/nm-applet" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share:${gnome3.gtk}/share:$out/share" \
      --set GCONF_CONFIG_SOURCE "xml::~/.gconf" \
      --prefix PATH ":" "${gnome3.gconf}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom urkud rickynils ];
    platforms = platforms.linux;

    # resolve collision between evince and nm-applet for
    # gschemas.compiled
    priority = 6;
  };
}
