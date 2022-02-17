{ lib
, stdenv
, fetchurl
, colord
, gettext
, meson
, ninja
, gobject-introspection
, gtk-doc
, docbook-xsl-ns
, docbook-xsl-nons
, docbook_xml_dtd_412
, libxslt
, glib
, gtk3
, gtk4
, pkg-config
, lcms2
}:

stdenv.mkDerivation rec {
  pname = "colord-gtk";
  version = "0.3.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/colord/releases/${pname}-${version}.tar.xz";
    sha256 = "uUZmVtZtmm/7wt0E+pHI9q9Ra/nvqstpdE7sD1bzwdA=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    ninja
    gobject-introspection
    gtk-doc
    docbook-xsl-ns
    docbook-xsl-nons
    docbook_xml_dtd_412
    libxslt
  ];

  buildInputs = [
    glib
    lcms2
  ];

  propagatedBuildInputs = [
    colord
    gtk3
    gtk4
  ];

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/colord/intro.html";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
