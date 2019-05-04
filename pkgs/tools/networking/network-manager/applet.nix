{ stdenv, fetchurl, meson, ninja, intltool, gtk-doc, pkgconfig, networkmanager, gnome3
, libnotify, libsecret, polkit, isocodes, modemmanager, libxml2, docbook_xsl, docbook_xml_dtd_43
, mobile-broadband-provider-info, glib-networking, gsettings-desktop-schemas
, libgudev, jansson, wrapGAppsHook, gobject-introspection, python3, gtk3
, libappindicator-gtk3, withGnome ? false, gcr }:

let
  pname = "network-manager-applet";
  version = "1.8.20";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1v1lvw9ak37gxha11rv49sai1vdyv128hdy0kliibiv6alavn385";
  };

  mesonFlags = [
    "-Dlibnm_gtk=false" # It is deprecated
    "-Dselinux=false"
    "-Dappindicator=yes"
    "-Dgcr=${if withGnome then "true" else "false"}"
  ];

  outputs = [ "out" "lib" "dev" "devdoc" "man" ];

  buildInputs = [
    gtk3 networkmanager libnotify libsecret gsettings-desktop-schemas
    polkit isocodes mobile-broadband-provider-info libgudev
    modemmanager jansson glib-networking
    libappindicator-gtk3 gnome3.adwaita-icon-theme
  ] ++ stdenv.lib.optionals withGnome [ gcr ]; # advanced certificate chooser

  nativeBuildInputs = [ meson ninja intltool pkgconfig wrapGAppsHook gobject-introspection python3 gtk-doc docbook_xsl docbook_xml_dtd_43 libxml2 ];

  # Needed for wingpanel-indicator-network and switchboard-plug-network
  patches = [ ./hardcode-gsettings.patch ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

    substituteInPlace src/wireless-security/eap-method.c --subst-var-by NM_APPLET_GSETTINGS $lib/share/gsettings-schemas/${name}/glib-2.0/schemas
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanagerapplet";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/NetworkManager;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom rickynils ];
    platforms = platforms.linux;
  };
}
