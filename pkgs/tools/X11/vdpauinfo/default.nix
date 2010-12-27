{ stdenv, fetchurl, pkgconfig, xlibs, libvdpau }:

stdenv.mkDerivation rec {
  name = "vdpauinfo-0.0.6";
  
  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "0m2llqjnwh3x6y56hik3znym2mfk1haq81a15p54m60ngf0mvfsj";
  };

  buildInputs = [ pkgconfig xlibs.libX11 libvdpau ];

  meta = {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system";
    license = "bsd";
  };
}
