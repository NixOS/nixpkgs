{ stdenv, fetchurl, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
, libxml2, libxslt, openssl, gnutls
}:

assert stdenv.isLinux;
assert stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  name = "wine-1.3.32";

  src = fetchurl {
    url = "mirror://sourceforge/wine/${name}.tar.bz2";
    sha256 = "fe1691ef8e9c5c4afeb345ad0f0b364d055cfe67a7e64b0a4a44da4d85cfa8b6";
  };

  gecko = fetchurl {
    url = "mirror://sourceforge/wine/wine_gecko-1.3-x86.msi";
    sha256 = "1bmm826dhq82jzxdld4x9cyg8mgzg8llkki59n9fvxggi7l5jxab";
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
