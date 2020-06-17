{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, xorgproto, udev
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3, kmod
, procps, utilmacros, gtk-doc, openssl, peg, elfutils
}:

stdenv.mkDerivation rec {
  pname = "intel-gpu-tools";
  version = "1.25";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/igt-gpu-tools-${version}.tar.xz";
    sha256 = "04fx7xclhick3k7fyk9c4mn8mxzf1253j1r0hrvj9sl40j7lsia0";
  };

  nativeBuildInputs = [ pkgconfig utilmacros ];
  buildInputs = [ libdrm libpciaccess cairo xorgproto udev libX11 kmod
    libXext libXv libXrandr glib bison libunwind python3 procps
    gtk-doc openssl peg elfutils ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=array-bounds" ];

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
    homepage = "https://01.org/linuxgraphics/";
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ pSub ];
  };
}
