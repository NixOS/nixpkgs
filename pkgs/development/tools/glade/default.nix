{ stdenv
, gettext
, fetchurl
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
, gnome3
, gdk-pixbuf
, libxslt
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "glade";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glade/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1kfgs2dpjd8dnnjkfc4xdy8yjjavlzimqzyfr1pq1m1h96z506hp";
  };

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
    gnome3.adwaita-icon-theme
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Glade";
    description = "User interface designer for GTK applications";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
