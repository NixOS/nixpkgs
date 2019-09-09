{ stdenv, fetchurl
, intltool, pkgconfig, glib, libsoup }:

let
  version = "2.2";
in stdenv.mkDerivation rec {
  pname = "phodav";
  inherit version;

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/phodav/${version}/${pname}-${version}.tar.xz";
    sha256 = "1hap0lncbcmivnflh0fbx7y58ry78p9wgj7z03r64ic0kvf0a0q8";
  };

  buildInputs = [ intltool glib libsoup ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "WebDav server implementation and library using libsoup";
    homepage = https://wiki.gnome.org/phodav;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
