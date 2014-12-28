{ stdenv, fetchurl, pkgconfig, xlibs, libvdpau }:

stdenv.mkDerivation rec {
  name = "vdpauinfo-0.9";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "1qy84clsz3l3hvhaxw01rl4bjqlsaml5l63rc43vck6vh8vgwh50";
  };

  buildInputs = [ pkgconfig libvdpau ];

  meta = with stdenv.lib; {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
