{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3 }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.16";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "1q9sfb15081zm1rq4z67sfj13ryvbdha4fa6pdzdsfd9261nvgn6";
  };

  buildInputs = [ pkgconfig libdrm libpciaccess cairo dri2proto udev libX11
                  libXext libXv libXrandr glib bison libunwind python3 ];

  preBuild = ''
    patchShebangs debugger/system_routine/pre_cpp.py
  '';

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxgraphics/;
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
