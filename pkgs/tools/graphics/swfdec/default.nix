{stdenv, fetchurl
, cairo, pango, glib, liboil, zlib, gstreamer, gst-plugins-base
, gst-plugins-good , gtk2, libsoup, alsaLib, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "swfdec";
  version = "0.8.4";

  src = fetchurl {
    url = "http://swfdec.freedesktop.org/download/swfdec/0.8/swfdec-${version}.tar.gz";
    sha256 = "00nqrd0fzf0g76rn80d7h56n6hxv7x1x6k89zj45bj564lzwc3vs";
  };

  buildInputs = [
    cairo glib liboil pango zlib gstreamer gst-plugins-base gst-plugins-good
    gtk2 libsoup alsaLib pkgconfig
  ];
  
  postInstall = ''
    mkdir "$out/bin"
    cp tools/.libs/swfdec-extract "$out/bin"
    cp tools/.libs/dump "$out/bin/swfdec-dump"
    cp player/.libs/swfplay "$out/bin/swfplay"
  '';

  enableParallelBuilding = true;

  meta = {
    inherit version;
    description = "Decoder/renderer for Macromedia Flash animations";
    license = stdenv.lib.licenses.lgpl21 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://swfdec.freedesktop.org/wiki/;
  };
}
