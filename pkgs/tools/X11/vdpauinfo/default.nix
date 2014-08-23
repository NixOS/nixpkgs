{ stdenv, fetchurl, pkgconfig, xlibs, libvdpau }:

stdenv.mkDerivation rec {
  name = "vdpauinfo-0.1";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "17q1spsrd5i4jzhpacbs0bb4blf74j8s45rpg0znyc1yjfk5dj5h";
  };

  buildInputs = [ pkgconfig xlibs.libX11 libvdpau ];

  meta = {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system";
    license = "bsd";
  };
}
