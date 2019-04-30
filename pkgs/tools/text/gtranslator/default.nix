{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, itstool
, gettext
, python3
, wrapGAppsHook
, libxml2
, libgda
, gspell
, glib
, gtk3
, gtksourceview4
, gnome3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gtranslator";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1dqigah7x6h3afw5jcs3lw3h9y0acj72arcgxr89l6galvknr2xa";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
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
    libgda
    gettext
    gspell
    gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME translation making program";
    homepage = https://wiki.gnome.org/Apps/Gtranslator;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
