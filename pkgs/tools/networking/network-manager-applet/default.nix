{ stdenv, fetchurl, intltool, pkgconfig, libglade, networkmanager, gnome3
, libnotify, libsecret, polkit, isocodes, modemmanager, librsvg
, mobile_broadband_provider_info, glib_networking, gsettings_desktop_schemas
, makeWrapper, udev, libgudev, hicolor_icon_theme, jansson, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "network-manager-applet";
  version = networkmanager.version;

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${networkmanager.major}/${name}.tar.xz";
    sha256 = "09ijxicsqf39y6h8kwbfjyljfbqkkx4vrpyfn6gfg1h9mvp4cf39";
  };

  configureFlags = [ "--sysconfdir=/etc" ];

  buildInputs = [
    gnome3.gtk libglade networkmanager libnotify libsecret gsettings_desktop_schemas
    polkit isocodes makeWrapper udev libgudev gnome3.gconf gnome3.libgnome_keyring
    modemmanager jansson librsvg
  ];

  nativeBuildInputs = [ intltool pkgconfig wrapGAppsHook ];

  propagatedUserEnvPkgs = [ gnome3.gconf gnome3.gnome_keyring hicolor_icon_theme ];

  makeFlags = [
    ''CFLAGS=-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile_broadband_provider_info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
  ];

  preInstall = ''
    installFlagsArray=( "sysconfdir=$out/etc" )
  '';

  meta = with stdenv.lib; {
    homepage    = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ phreedom urkud rickynils ];
    platforms   = platforms.linux;
  };
}
