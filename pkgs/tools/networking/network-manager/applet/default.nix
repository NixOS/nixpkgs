{ stdenv
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, networkmanager
, gnome3
, libnotify
, libsecret
, polkit
, modemmanager
, libnma
, mobile-broadband-provider-info
, glib-networking
, gsettings-desktop-schemas
, libgudev
, jansson
, wrapGAppsHook
, gobject-introspection
, python3
, gtk3
, libappindicator-gtk3
, glib
}:

stdenv.mkDerivation rec {
  pname = "network-manager-applet";
  version = "1.16.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1rf3nm0hjcy9f8ajb4vmvwy503w8yj8d4daxkcb7w7i7b92qmyfn";
  };

  mesonFlags = [
    "-Dselinux=false"
    "-Dappindicator=yes"
  ];

  outputs = [ "out" "man" ];

  buildInputs = [
    libnma
    gtk3
    networkmanager
    libnotify
    libsecret
    gsettings-desktop-schemas
    polkit
    libgudev
    modemmanager
    jansson
    glib-networking
    libappindicator-gtk3
    gnome3.adwaita-icon-theme
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook
    gobject-introspection
    python3
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanagerapplet";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/GNOME/network-manager-applet/";
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom ];
    platforms = platforms.linux;
  };
}
