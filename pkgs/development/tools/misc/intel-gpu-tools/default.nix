{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3, kmod
, procps, autoreconfHook, utilmacros, gnome2 }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.22";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.xz";
    sha256 = "0p4swf9577p6hzglw1lh2sz63wjkk37b7691saj2qw8ha7fc2rix";
  };

  nativeBuildInputs = [ pkgconfig utilmacros ];
  buildInputs = [ libdrm libpciaccess cairo dri2proto udev libX11 kmod
    libXext libXv libXrandr glib bison libunwind python3 procps
    gnome2.gtkdoc ];

  preConfigure = ''
    ./autogen.sh
  '';

  preBuild = ''
    patchShebangs debugger/system_routine/pre_cpp.py
    substituteInPlace tools/Makefile.am --replace '$(CAIRO_CFLAGS)' '$(CAIRO_CFLAGS) $(GLIB_CFLAGS)'
    substituteInPlace tests/Makefile.am --replace '$(CAIRO_CFLAGS)' '$(CAIRO_CFLAGS) $(GLIB_CFLAGS)'
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxgraphics/;
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ pSub ];
  };
}
