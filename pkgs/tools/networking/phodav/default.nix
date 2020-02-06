{ stdenv, fetchurl
, pkgconfig, libsoup, meson, ninja }:

let
  version = "2.3";
in stdenv.mkDerivation rec {
  pname = "phodav";
  inherit version;

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/phodav/${version}/${pname}-${version}.tar.xz";
    sha256 = "0ndy5qva6bq7vhk06jq2d4nr5fp98xsdwypg42vjz91h9ii1xxkf";
  };

  mesonFlags = [
    "-Davahi=disabled"
    "-Dsystemd=disabled"
    "-Dgtk_doc=disabled"
  ];

  nativeBuildInputs = [ libsoup pkgconfig meson ninja ];

  meta = with stdenv.lib; {
    description = "WebDav server implementation and library using libsoup";
    homepage = https://wiki.gnome.org/phodav;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
