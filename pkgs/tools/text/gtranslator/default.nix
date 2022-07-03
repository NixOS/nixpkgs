{ stdenv
, lib
, fetchurl
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
, libsoup_3
, json-glib
, gspell
, glib
, gtk3
, gtksourceview4
, gnome
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gtranslator";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "Kme8v+ZDBhsGltiaEIR9UL81kF/zNhuYcTV9PjQi8Ts=";
  };

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
    gtksourceview4
    libgda6
    libhandy
    libsoup_3
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
