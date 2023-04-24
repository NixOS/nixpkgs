{ stdenv
, lib
, desktop-file-utils
, fetchurl
, glib
, gettext
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gnome
}:

stdenv.mkDerivation rec {
  pname = "d-spy";
  version = "1.6.0";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/d-spy/${lib.versions.majorMinor version}/d-spy-${version}.tar.xz";
    sha256 = "otCiEFE7tGRw0A40VEeRIIMwFT9Ms0+FhxcpEaxPiv0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
    gettext
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "d-spy";
    };
  };

  meta = with lib; {
    description = "D-Bus exploration tool";
    homepage = "https://gitlab.gnome.org/GNOME/d-spy";
    license = with licenses; [
      lgpl3Plus # library
      gpl3Plus # app
    ];
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
