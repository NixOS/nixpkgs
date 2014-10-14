{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev, libX11, libXext, libXv, libXrandr, glib, bison }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.8";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "0n9pzwjzx4xiffcy3nkc7q7689sid2ry8m9xx4vgxxspr8ds3qpz";
  };

  configureFlags = [ "--disable-tests" ];

  buildInputs = [ pkgconfig libdrm libpciaccess cairo dri2proto udev libX11 libXext libXv libXrandr glib bison ];

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxgraphics/;
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
