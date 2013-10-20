{ stdenv, fetchurl, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
, libxml2, libxslt, openssl, gnutls, cups, libdrm, makeWrapper
}:

assert stdenv.isLinux;
assert stdenv.gcc.gcc != null;

let gecko = fetchurl {
      url = "mirror://sourceforge/wine/wine_gecko-2.21-x86.msi";
      sha256 = "0sb9zfrvlrjx1icfb94clgac239i9yfhyv48zv9iddgmvdjk8ysi";
    };

    gecko64 = fetchurl {
      url = "mirror://sourceforge/wine/wine_gecko-2.21-x86_64.msi";
      sha256 = "0grc86dkq90i59zw43hakh62ra1ajnk11m64667xjrlzi7f0ndxw";
    };

    mono = fetchurl {
      url = "mirror://sourceforge/wine/wine-mono-0.0.8.msi";
      sha256 = "00jl24qp7vh3hlqv7wsw1s529lr5p0ybif6s73jy85chqaxj7z1x";
    };

in stdenv.mkDerivation rec {
  version = "1.7.4";
  name = "wine-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wine/${name}.tar.bz2";
    sha256 = "1bj21d94i0mqvkmzxd4971232yniribk7q3fllf23ynbpppk1wg1";
  };

  buildInputs = [
    xlibs.xlibs flex bison xlibs.libXi mesa
    xlibs.libXcursor xlibs.libXinerama xlibs.libXrandr
    xlibs.libXrender xlibs.libXxf86vm xlibs.libXcomposite
    alsaLib ncurses libpng libjpeg lcms fontforge
    libxml2 libxslt openssl gnutls cups makeWrapper
  ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath ${path}/lib ") [
    freetype fontconfig stdenv.gcc.gcc mesa libdrm
    xlibs.libXinerama xlibs.libXrender xlibs.libXrandr
    xlibs.libXcursor xlibs.libXcomposite libpng libjpeg
    openssl gnutls cups
  ];

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;

  postInstall = ''
    install -D ${gecko} $out/share/wine/gecko/${gecko.name}
  '' + stdenv.lib.optionalString (stdenv.system == "x86_64-linux") ''
    install -D ${gecko} $out/share/wine/gecko/${gecko64.name}
  '' + ''
    install -D ${mono} $out/share/wine/mono/${mono.name}
    wrapProgram $out/bin/wine --prefix LD_LIBRARY_PATH : ${stdenv.gcc.gcc}/lib
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.winehq.org/";
    license = "LGPL";
    inherit version;
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    maintainers = [stdenv.lib.maintainers.raskin stdenv.lib.maintainers.simons];
    platforms = stdenv.lib.platforms.linux;
  };
}
