{ stdenv, fetchurl, pkgconfig, python3, xmlbird,
cairo, gdk-pixbuf, libgee, glib, gtk3, webkitgtk, libnotify, sqlite, vala_0_44,
gobject-introspection, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.29.0";

  src = fetchurl {
    url = "https://birdfont.org/releases/${pname}-${version}.tar.xz";
    sha256 = "18z3qbrsbfpn00c4xq3ck1mnmvrnqgl9g1s7m4dgc1871fi6sv8w";
  };

  nativeBuildInputs = [ python3 pkgconfig vala_0_44 gobject-introspection wrapGAppsHook ];
  buildInputs = [ xmlbird libgee cairo gdk-pixbuf glib gtk3 webkitgtk libnotify sqlite gsettings-desktop-schemas ];

  postPatch = "patchShebangs .";

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = with stdenv.lib; {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = "https://birdfont.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
