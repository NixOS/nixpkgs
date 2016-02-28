{ stdenv, lib, fetchFromGitHub, libpcap, libjpeg , libungif, libpng
, giflib, glib, gtk2, cairo, pango, gdk_pixbuf, atk
, pkgconfig, autoreconfHook }:

with lib;

stdenv.mkDerivation rec {
  name = "driftnet-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "8d47fd563a06122d4a6f9b9b9d27ba3d635148c0";

  buildInputs = [
    pkgconfig libpcap libjpeg libungif libpng giflib
    glib gtk2 glib cairo pango gdk_pixbuf atk autoreconfHook
  ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "deiv";
    repo = "driftnet";
    sha256 = "1i9fqbsfrhvr36r17v3ydr1bqsszns8gyjbvlfqbdd4l5l5n6amg";
  };

  meta = {
    description = "Driftnet watches network traffic, and picks out and displays JPEG and GIF images for display";
    homepage = https://github.com/deiv/driftnet;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
