{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.13";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "0d5ff9l12zw9mdsjwbwn6y9k1gz6xlzsx5k87apz9vq6q625irn6";
  };

  buildInputs = [ pkgconfig libdrm libpciaccess cairo dri2proto udev libX11
                  libXext libXv libXrandr glib bison libunwind ];

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxgraphics/;
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
