{ lib, stdenv
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
