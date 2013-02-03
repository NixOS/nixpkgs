{ stdenv, fetchurl, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
, libxml2, libxslt, openssl, gnutls, cups
}:

assert stdenv.isLinux;
assert stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  version = "1.5.23";
  name = "wine-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wine/${name}.tar.bz2";
    sha256 = "1wgs2bdl3sn3j0za7fk9zfjlii1x6qkvmyw4jxzz1mfw6nizswzr";
  };

  gecko = fetchurl {
    url = "mirror://sourceforge/wine/wine_gecko-1.9-x86.msi";
    sha256 = "10p7djsf85xjk8rzg3hgw5fskrn8402y2aijy701xwm4hy9ga79g";
  };

  buildInputs = [
    xlibs.xlibs flex bison xlibs.libXi mesa
    xlibs.libXcursor xlibs.libXinerama xlibs.libXrandr
    xlibs.libXrender xlibs.libXxf86vm xlibs.libXcomposite
    alsaLib ncurses libpng libjpeg lcms fontforge
    libxml2 libxslt openssl gnutls cups
  ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath ${path}/lib ") [
    freetype fontconfig stdenv.gcc.gcc mesa mesa.libdrm
    xlibs.libXinerama xlibs.libXrender xlibs.libXrandr
    xlibs.libXcursor xlibs.libXcomposite libpng libjpeg
    openssl gnutls cups
  ];

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;

  postInstall = "install -D ${gecko} $out/share/wine/gecko/${gecko.name}";

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.winehq.org/";
    license = "LGPL";
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    maintainers = [stdenv.lib.maintainers.raskin stdenv.lib.maintainers.simons];
    platforms = stdenv.lib.platforms.linux;
  };
}
