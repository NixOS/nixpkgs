{ lib, stdenv
, fetchurl
, colord
, gettext
, meson
, ninja
, gobject-introspection
, gtk-doc
, docbook-xsl-ns
, docbook_xsl
, docbook_xml_dtd_412
, libxslt
, glib
, gtk3
, pkg-config
, lcms2
}:

stdenv.mkDerivation rec {
  pname = "colord-gtk";
  version = "0.2.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/colord/releases/${pname}-${version}.tar.xz";
    sha256 = "05y78jbcbar22sgyhzffhv98dbpl4v6k8j9p807h17y6ighglk1a";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    ninja
    gobject-introspection
    gtk-doc
    docbook-xsl-ns
    docbook_xsl
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
  ];

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/colord/intro.html";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
