{ lib, stdenv
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, networkmanager
, gnome
, libsecret
, polkit
, modemmanager
, libnma
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
  version = "1.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-qzaORw9rFh/IuDS8l5ErfnmvkrjNfqOZwtQAzomrpag=";
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
    libsecret
    gsettings-desktop-schemas
    polkit
    libgudev
    modemmanager
    jansson
    glib
    glib-networking
    libappindicator-gtk3
    gnome.adwaita-icon-theme
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
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanagerapplet";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/network-manager-applet/";
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    mainProgram = "nm-applet";
    platforms = platforms.linux;
  };
}
