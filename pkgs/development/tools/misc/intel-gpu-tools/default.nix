{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3, kmod
, procps, utilmacros, gnome2, openssl }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-${version}";
  version = "1.23";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/igt-gpu-tools-${version}.tar.xz";
    sha256 = "1l4s95m013p2wvddwr4cjqyvsgmc88zxx2887p1fbb1va5n0hjsd";
  };

  nativeBuildInputs = [ pkgconfig utilmacros ];
  buildInputs = [ libdrm libpciaccess cairo dri2proto udev libX11 kmod
    libXext libXv libXrandr glib bison libunwind python3 procps
    gnome2.gtkdoc openssl ];

  preConfigure = ''
    ./autogen.sh
  '';

  preBuild = ''
    patchShebangs tests

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
