{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3 }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.14";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "030g1akybk19y3jcxd8pp573ymrd4w7mmzxbspp064lwdv9y35im";
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
