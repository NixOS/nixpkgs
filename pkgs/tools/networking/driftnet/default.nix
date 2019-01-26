{ stdenv, lib, fetchFromGitHub, libpcap, libjpeg , libungif, libpng
, giflib, glib, gtk2, cairo, pango, gdk_pixbuf, atk
, pkgconfig, autoreconfHook }:

with lib;

stdenv.mkDerivation rec {
  name = "driftnet-${version}";
  version = "1.1.5";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libpcap libjpeg libungif libpng giflib
    glib gtk2 glib cairo pango gdk_pixbuf atk autoreconfHook
  ];

  src = fetchFromGitHub {
    owner = "deiv";
    repo = "driftnet";
    rev = "0ae4a91";
    sha256 = "1sagpx0mw68ggvqd9c3crjhghqmj7391mf2cb6cjw1cpd2hcddsj";
  };

  meta = {
    description = "Driftnet watches network traffic, and picks out and displays JPEG and GIF images for display";
    homepage = https://github.com/deiv/driftnet;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
