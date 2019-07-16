{ stdenv, fetchurl, pkgconfig, python3, xmlbird,
cairo, gdk_pixbuf, libgee, glib, gtk3, webkitgtk, libnotify, sqlite, vala,
gobject-introspection, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.26.0";

  src = fetchurl {
    url = "https://birdfont.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0lcbwmwfb18dpr5kpnrl2zx59jhvj7k7vzjld51zv0zhcvl9fg3j";
  };

  nativeBuildInputs = [ python3 pkgconfig vala gobject-introspection wrapGAppsHook ];
  buildInputs = [ xmlbird libgee cairo gdk_pixbuf glib gtk3 webkitgtk libnotify sqlite gsettings-desktop-schemas ];

  postPatch = "patchShebangs .";

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = with stdenv.lib; {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = https://birdfont.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
