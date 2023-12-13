{ stdenv
, lib
, fetchurl
, fetchpatch
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
  version = "45.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "MBAgTfXHpa4Cf1owsVRNaXfUF/Dku53il/CtGoAzGHM=";
  };

  patches = [
    # Fix build with libxml2 2.12
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtranslator/-/commit/db991f4c897f8a13bfb2db6f1b8bc60f39a98e4d.patch";
      hash = "sha256-AFhxMXoJM/x6U92HzPP721vNIUQZPRQ0eEReZREmKiQ=";
    })
  ];

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
    homepage = "https://wiki.gnome.org/Apps/Gtranslator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
