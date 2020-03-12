{ stdenv, fetchurl, pkgconfig, libvdpau }:

stdenv.mkDerivation rec {
  pname = "vdpauinfo";
  version = "1.3";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/vdpauinfo/uploads/6fa9718c507ef0fb6966170ef55344bf/${pname}-${version}.tar.gz";
    sha256 = "0s6jdadnycyd1agsnfx7hrf17hmipasx1fpmppd4m1z6i9sp1i6g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvdpau ];

  meta = with stdenv.lib; {
    homepage = https://people.freedesktop.org/~aplattner/vdpau/;
    description = "Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
