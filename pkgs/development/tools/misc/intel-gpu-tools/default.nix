{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev, libX11, libXext, libXv, libXrandr, glib, bison }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.9";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "1lqy1adplb2bqpddznsavjc2fxn6rvzxnndmi8cnq7pyw25c5r0x";
  };

  buildInputs = [ pkgconfig libdrm libpciaccess cairo dri2proto udev libX11 libXext libXv libXrandr glib bison ];

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxgraphics/;
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
