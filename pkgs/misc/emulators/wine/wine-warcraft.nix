{ stdenv, fetchgit, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
, libxml2, libxslt, openssl, gnutls
}:

assert stdenv.isLinux;
assert stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  name = "wine-warcraft-${version}";
  version = "1.1.19";

  src = fetchgit {
    url = git://repo.or.cz/wine/warcraft3.git;
    rev = "38faaffd99331b71284d8da5f76f38625107ed6d";
  };

  buildInputs = [
    xlibs.xlibs flex bison xlibs.libXi mesa
    xlibs.libXcursor xlibs.libXinerama xlibs.libXrandr
    xlibs.libXrender xlibs.libXxf86vm xlibs.libXcomposite
    xlibs.xf86vidmodeproto
    alsaLib ncurses libpng libjpeg lcms fontforge
    libxml2 libxslt openssl gnutls
  ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath ${path}/lib ") [
    freetype fontconfig stdenv.gcc.gcc mesa mesa.libdrm
    xlibs.libXinerama xlibs.libXrender xlibs.libXrandr
    xlibs.libXcursor xlibs.libXcomposite xlibs.libXxf86vm
    xlibs.xf86vidmodeproto
    openssl gnutls
  ];

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;

  meta = with stdenv.lib; {
    homepage = "http://www.winehq.org/";
    license = "LGPL";
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix with patches for Warcraft 3";
    maintainers = [ maintainers.phreedom ];
    platforms = [ "i686-linux" ];
  };
}
