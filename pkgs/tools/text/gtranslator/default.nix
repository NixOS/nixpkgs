{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, itstool
, gettext
, python3
, wrapGAppsHook
, libxml2
, libgda6
, libhandy
, libsoup
, json-glib
, gspell
, glib
, libdazzle
, gtk3
, gtksourceview4
, gnome
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gtranslator";
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "E28R/gOhlJkMQ6/jOL0eoK0U5+H26Gjlv3xbUsTF5eE=";
  };

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:15:5: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtranslator/-/commit/7ac572cc8c8c37ca3826ecf0d395edd3c38e8e22.patch";
      sha256 = "aRg6dYweftV8F7FXykO7m0G+p4SLTFnhTcZx72UCMDE=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gettext
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    glib
    gtk3
    libdazzle
    gtksourceview4
    libgda6
    libhandy
    libsoup
    json-glib
    gettext
    gspell
    gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "GNOME translation making program";
    homepage = "https://wiki.gnome.org/Apps/Gtranslator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
