{ stdenv
, lib
, fetchFromGitLab
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
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gvls";
  version = "0.14.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "esodan";
    repo = "gvls";
    rev = "${pname}-${version}";
    sha256 = "1brz3dxdjfww1b8npzrpzanndmy835w6fvkfydjbqz1h89myv73a";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    pango
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    gtksourceview3
    json-glib
    jsonrpc-glib
    libgee
    vala
  ];

  meta = with lib; {
    description = "Language Server Provider for Vala";
    homepage = "https://gitlab.gnome.org/esodan/gvls";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.linux;
  };
}
