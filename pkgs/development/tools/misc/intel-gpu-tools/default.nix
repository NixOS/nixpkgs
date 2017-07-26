{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3, kmod
, procps, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.19";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "1wdhwf3im6ids95qw5r9hjj9hvp0qhzgi4llrlriy723q3kqm754";
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
