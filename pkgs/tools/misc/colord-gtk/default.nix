{
  lib,
  stdenv,
  fetchurl,
  colord,
  gettext,
  meson,
  ninja,
  gobject-introspection,
  gtk-doc,
  docbook-xsl-ns,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  libxslt,
  glib,
  withGtk4 ? false,
  gtk3,
  gtk4,
  pkg-config,
  lcms2,
}:

stdenv.mkDerivation rec {
  pname = "colord-gtk";
  version = "0.3.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/colord/releases/${pname}-${version}.tar.xz";
    sha256 = "wXa4ibdWMKF/Tj1+8kwJo+EjaOYzSWCHRZyLU6w6Ei0=";
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

  propagatedBuildInputs =
    [
      colord
    ]
    ++ (
      if withGtk4 then
        [
          gtk4
        ]
      else
        [
          gtk3
        ]
    );

  mesonFlags = [
    "-Dgtk4=${lib.boolToString withGtk4}"
    "-Dgtk3=${lib.boolToString (!withGtk4)}"
  ];

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/colord/intro.html";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
    mainProgram = "cd-convert";
  };
}
