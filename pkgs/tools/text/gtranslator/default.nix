{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, itstool
, gettext
, wrapGAppsHook4
, libxml2
, libadwaita
, libgda6
, libsoup_3
, libspelling
, json-glib
, glib
, gtk4
, gtksourceview5
, gnome
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gtranslator";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-CjC/D9gtiPmiBmWei19Z6qk/uA9nUwu/lGHFv2ocC+s=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gettext
    wrapGAppsHook4
  ];

  buildInputs = [
    libxml2
    glib
    gtk4
    gtksourceview5
    libadwaita
    libgda6
    libsoup_3
    libspelling
    json-glib
    gettext
    gsettings-desktop-schemas
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "GNOME translation making program";
    mainProgram = "gtranslator";
    homepage = "https://wiki.gnome.org/Apps/Gtranslator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
