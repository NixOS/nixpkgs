{ stdenv, fetchurl, intltool, pkgconfig, libglade, networkmanager, gnome3
, libnotify, libsecret, dbus_glib, polkit, isocodes
, mobile_broadband_provider_info, glib_networking, gsettings_desktop_schemas
, makeWrapper, udev, libgudev, hicolor_icon_theme }:

let
  pn = "network-manager-applet";
  major = "1.0";
  # With version 1.0.12 of NM, we are no longer in sync
  # version = "${networkmanager.version}.10";
  version = "${major}.10";
in

stdenv.mkDerivation rec {
  name = "network-manager-applet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pn}/${major}/${name}.tar.xz";
    sha256 = "1szh5jyijxm6z55irkp5s44pwah0nikss40mx7pvpk38m8zaqidh";
  };

  configureFlags = [ "--sysconfdir=/etc" ];

  buildInputs = [
    gnome3.gtk libglade networkmanager libnotify libsecret dbus_glib gsettings_desktop_schemas
    polkit isocodes makeWrapper udev libgudev gnome3.gconf gnome3.libgnome_keyring
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  propagatedUserEnvPkgs = [ gnome3.gconf gnome3.gnome_keyring hicolor_icon_theme ];

  makeFlags = [
    ''CFLAGS=-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile_broadband_provider_info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
  ];

  preInstall =
    ''
      installFlagsArray=( "sysconfdir=$out/etc" )
    '';

  preFixup = ''
    wrapProgram "$out/bin/nm-applet" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules:${gnome3.dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gnome3.gtk}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --set GCONF_CONFIG_SOURCE "xml::~/.gconf" \
      --prefix PATH ":" "${gnome3.gconf}/bin"
    wrapProgram "$out/bin/nm-connection-editor" \
      --prefix XDG_DATA_DIRS : "${gnome3.gtk}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom urkud rickynils ];
    platforms = platforms.linux;
  };
}
