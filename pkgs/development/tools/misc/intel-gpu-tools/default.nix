{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.12";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "1qwbwgvsqxba0adzlwxqmdw1asykx0pmk9ra0ff0nmjj9apf0gql";
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
