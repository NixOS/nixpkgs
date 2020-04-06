{ stdenv, fetchurl
, pkgconfig, libsoup, meson, ninja }:

let
  version = "2.4";
in stdenv.mkDerivation rec {
  pname = "phodav";
  inherit version;

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/phodav/${version}/${pname}-${version}.tar.xz";
    sha256 = "1hxq8c5qfah3w7mxcyy3yhzdgswplll31a69p5mqdl04bsvw5pbx";
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
    homepage = https://wiki.gnome.org/phodav;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
