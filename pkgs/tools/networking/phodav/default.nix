{ stdenv, fetchurl
, pkgconfig, libsoup, meson, ninja }:

let
  version = "2.5";
in stdenv.mkDerivation rec {
  pname = "phodav";
  inherit version;

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/phodav/${version}/${pname}-${version}.tar.xz";
    sha256 = "045rdzf8isqmzix12lkz6z073b5qvcqq6ad028advm5gf36skw3i";
  };

  mesonFlags = [
    "-Davahi=disabled"
    "-Dsystemd=disabled"
    "-Dgtk_doc=disabled"
    "-Dudev=disabled"
  ];

  nativeBuildInputs = [ libsoup pkgconfig meson ninja ];

  outputs = [ "out" "dev" "lib" ];

  meta = with stdenv.lib; {
    description = "WebDav server implementation and library using libsoup";
    homepage = "https://wiki.gnome.org/phodav";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
