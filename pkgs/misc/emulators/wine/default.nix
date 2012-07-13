{ stdenv, fetchurl, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
, libxml2, libxslt, openssl, gnutls
}:

assert stdenv.isLinux;
assert stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  name = "wine-1.5.5";

  src = fetchurl {
    url = "mirror://sourceforge/wine/${name}.tar.bz2";
    sha256 = "e7d5ba716d2ac47193fa31eff66cc179145ddcb453c6923eaea70596a82b084e";
  };

  gecko = fetchurl {
    url = "mirror://sourceforge/wine/wine_gecko-1.5-x86.msi";
    sha256 = "2e372a1b87ff2a22ad5127400ece4b09e55591d9f84e00bb562d294898a49b5c";
  };

  buildInputs = [
    xlibs.xlibs flex bison xlibs.libXi mesa
    xlibs.libXcursor xlibs.libXinerama xlibs.libXrandr
    xlibs.libXrender xlibs.libXxf86vm xlibs.libXcomposite
    alsaLib ncurses libpng libjpeg lcms fontforge
    libxml2 libxslt openssl gnutls
  ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath ${path}/lib ") [
    freetype fontconfig stdenv.gcc.gcc mesa mesa.libdrm
    xlibs.libXinerama xlibs.libXrender xlibs.libXrandr
    xlibs.libXcursor xlibs.libXcomposite libpng libjpeg
    openssl gnutls
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
