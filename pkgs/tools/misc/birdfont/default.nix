{ stdenv, fetchurl, pkgconfig, python3, xmlbird,
cairo, gdk_pixbuf, libgee, glib, gtk3, webkitgtk, libnotify, sqlite, vala,
gobject-introspection, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.25.0";

  src = fetchurl {
    url = "https://birdfont.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0fi86km9iaxs9b8lqz81079vppzp346kqiqk44vk45dclr5r6x22";
  };

  nativeBuildInputs = [ python3 pkgconfig vala gobject-introspection wrapGAppsHook ];
  buildInputs = [ xmlbird libgee cairo gdk_pixbuf glib gtk3 webkitgtk libnotify sqlite gsettings-desktop-schemas ];

  postPatch = "patchShebangs .";

  buildPhase = "./build.py";

  installPhase = "./install.py";
}
