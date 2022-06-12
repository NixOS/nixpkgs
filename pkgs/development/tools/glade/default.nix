{ stdenv
, lib
, gettext
, fetchurl
, fetchpatch
, python3
, meson
, ninja
, pkg-config
, gtk3
, glib
, gjs
, webkitgtk
, gobject-introspection
, wrapGAppsHook
, itstool
, libxml2
, docbook-xsl-nons
, docbook_xml_dtd_42
, gnome
, gdk-pixbuf
, libxslt
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "glade";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/glade/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1dxsiz9ahqkxg2a1dw9sbd8jg59y5pdz4c1gvnbmql48gmj8gz4q";
  };

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:4:5: ERROR: Function does not take positional arguments.
    # Taken from https://gitlab.gnome.org/GNOME/glade/-/merge_requests/117
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/glade/-/commit/61304b2e8bac8ded76643cb7c3e781f73881dd2b.patch";
      sha256 = "9x6RK8Wgnm8bDxeBLV3PlUkUuH2706Ba9kwE5S87DgE=";
    })
    # help/meson.build:6:6: ERROR: Tried to create target "help-glade-da-update-po", but a target of that name already exists.
    # Taken from https://gitlab.gnome.org/GNOME/glade/-/merge_requests/117
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/glade/-/commit/04ba6f969f716fbfe3c7feb7e4bab8678cc1e9eb.patch";
      sha256 = "j3XfF7P6rndL+0PWqnp+QYph7Ba6bgcp4Pkikr2wuJA=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook
    docbook-xsl-nons
    docbook_xml_dtd_42
    libxslt
    libxml2
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    glib
    gjs
    webkitgtk
    libxml2
    python3
    python3.pkgs.pygobject3
    gsettings-desktop-schemas
    gdk-pixbuf
    gnome.adwaita-icon-theme
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Glade";
    description = "User interface designer for GTK applications";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
