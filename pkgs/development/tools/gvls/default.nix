{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, glib
, vala
, jsonrpc-glib
, json-glib
, gtk3
, pango
, gtksourceview3
, libgee
, vala-lint
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gvls";
  version = "20.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "esodan";
    repo = "gvls";
    rev = "${pname}-${version}";
    sha256 = "sha256-Y/nMdMNyW7YYBIWJAmMOcaxx2+1940R42WaSGeDwp/8=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  patches = [
    # https://gitlab.gnome.org/esodan/gvls/-/merge_requests/14
    (fetchpatch {
      url = "https://gitlab.gnome.org/esodan/gvls/-/commit/35930cc5797f3834491dae837d996371a751c7de.patch";
      sha256 = "sha256-tDAWLhOCJ+t0UaFEZD9EZKrSI/4FzhE4sZtelx+/wF0=";
    })
  ];

  mesonFlags = [
    "-Dvapidir=${placeholder "out"}/share"
  ];

  buildInputs = [
    glib
    gtk3
    gtksourceview3
    json-glib
    jsonrpc-glib
    libgee
    pango
  ];
  # Tests fail, probably they need http support not available inside the
  # sandbox
  doCheck = false;

  propagatedBuildInputs = [
    vala
    vala-lint
  ];

  meta = with lib; {
    description = "Language Server Provider for Vala";
    homepage = "https://gitlab.gnome.org/esodan/gvls";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
