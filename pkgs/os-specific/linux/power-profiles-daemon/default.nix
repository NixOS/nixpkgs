{ stdenv
, lib
, pkg-config
, meson
, ninja
, fetchFromGitLab
, libgudev
, glib
, gobject-introspection
, gettext
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, libxml2
, libxslt
, upower
, systemd
, python3
}:

stdenv.mkDerivation rec {
  pname = "power-profiles-daemon";
  version = "0.8.1";

  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "power-profiles-daemon";
    rev = version;
    sha256 = "sha256-OnCUr7KWVPpYGDseBUcJD/PdOobvFnyNA97NhnKbTKY=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
    libxml2 # for xmllint for stripping GResources
    libxslt # for xsltproc for building docs
    gobject-introspection
  ];

  buildInputs = [
    libgudev
    systemd
    upower
    glib
    (python3.withPackages (ps: with ps; [ ps.pygobject3 ])) # for cli tool
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=true"
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/hadess/power-profiles-daemon";
    description = "Makes user-selected power profiles handling available over D-Bus";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
