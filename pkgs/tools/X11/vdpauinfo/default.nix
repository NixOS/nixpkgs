{ stdenv, fetchurl, pkgconfig, xorg, libvdpau }:

stdenv.mkDerivation rec {
  name = "vdpauinfo-1.0";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "1i2b0k9h8r0lnxlrkgqzmrjakgaw3f1ygqqwzx8w6676g85rcm20";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvdpau ];

  meta = with stdenv.lib; {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
