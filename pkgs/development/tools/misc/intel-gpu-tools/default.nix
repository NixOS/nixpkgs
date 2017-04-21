{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3, kmod
, procps, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.18";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "1vp4czxp8xa6qk4pg3mrxhc2yadw2rv6p8r8247mkpcbb8dzjxyz";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake ];
  buildInputs = [ libdrm libpciaccess cairo dri2proto udev libX11 kmod
    libXext libXv libXrandr glib bison libunwind python3 procps ];

  preBuild = ''
    patchShebangs debugger/system_routine/pre_cpp.py
    substituteInPlace tools/Makefile.am --replace '$(CAIRO_CFLAGS)' '$(CAIRO_CFLAGS) $(GLIB_CFLAGS)'
  '';

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxgraphics/;
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
