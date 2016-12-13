{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3, kmod
, procps }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.17";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "06pvmbsbff4bsi67n6x3jjngzy2llf8bplc75447ra1fwphc9jx6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libdrm libpciaccess cairo dri2proto udev libX11 kmod
    libXext libXv libXrandr glib bison libunwind python3 procps ];

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
