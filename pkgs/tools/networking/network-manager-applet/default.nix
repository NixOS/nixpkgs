{ stdenv, fetchurl, intltool, pkgconfig, libglade, networkmanager, gnome3
, libnotify, libsecret, polkit, isocodes, modemmanager
, mobile-broadband-provider-info, glib-networking, gsettings-desktop-schemas
, udev, libgudev, hicolor-icon-theme, jansson, wrapGAppsHook, webkitgtk
, libindicator-gtk3, libappindicator-gtk3, withGnome ? false }:

stdenv.mkDerivation rec {
  name    = "${pname}-${major}.${minor}";
  pname   = "network-manager-applet";
  major   = "1.8";
  minor   = "6";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${major}/${name}.tar.xz";
    sha256 = "0c4wxwxpa7wlskvnqaqfa7mmc0c6a2pj7jcvymcchjnq4wn9wx01";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--without-selinux"
    "--with-appindicator"
  ];

  outputs = [ "out" "dev" ];

  buildInputs = [
    gnome3.gtk libglade networkmanager libnotify libsecret gsettings-desktop-schemas
    polkit isocodes udev libgudev gnome3.libgnome-keyring
    modemmanager jansson glib-networking
    libindicator-gtk3 libappindicator-gtk3
  ] ++ stdenv.lib.optional withGnome webkitgtk;

  nativeBuildInputs = [ intltool pkgconfig wrapGAppsHook ];

  propagatedUserEnvPkgs = [ gnome3.gnome-keyring hicolor-icon-theme ];

  makeFlags = [
    ''CFLAGS=-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile-broadband-provider-info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
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
