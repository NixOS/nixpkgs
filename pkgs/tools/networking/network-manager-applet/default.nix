{ stdenv, fetchurl, intltool, pkgconfig, libglade, networkmanager, gnome3
, libnotify, libsecret, polkit, isocodes, modemmanager, librsvg
, mobile_broadband_provider_info, glib_networking, gsettings_desktop_schemas
, makeWrapper, udev, libgudev, hicolor_icon_theme, jansson, wrapGAppsHook, webkitgtk
, withGnome ? false }:

stdenv.mkDerivation rec {
  name    = "${pname}-${major}.${minor}";
  pname   = "network-manager-applet";
  major   = "1.8";
  minor   = "2";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${major}/${name}.tar.xz";
    sha256 = "09f9hjpn9nkhw57mk6pi7q1bq3lhf5hvmwas0fknscssak7yjmry";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--without-selinux"
  ];

  outputs = [ "out" "dev" ];

  buildInputs = [
    gnome3.gtk libglade networkmanager libnotify libsecret gsettings_desktop_schemas
    polkit isocodes makeWrapper udev libgudev gnome3.gconf gnome3.libgnome_keyring
    modemmanager jansson librsvg glib_networking gnome3.dconf
  ] ++ stdenv.lib.optional withGnome webkitgtk;

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
    maintainers = with maintainers; [ phreedom rickynils ];
    platforms   = platforms.linux;
  };
}
