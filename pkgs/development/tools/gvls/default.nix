{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
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
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "Language Server Provider for Vala";
    homepage = "https://gitlab.gnome.org/esodan/gvls";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
