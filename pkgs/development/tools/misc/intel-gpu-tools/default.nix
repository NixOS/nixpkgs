{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.11";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "1r5dbp2gdxqryv1fhxy83k4d1kfp7rv8q370fhncamrb8m8390j8";
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
