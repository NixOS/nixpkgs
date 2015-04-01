{ stdenv, fetchurl, pkgconfig, xlibs, flex, bison, mesa, mesa_noglu, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
, libxml2, libxslt, openssl, gnutls, cups, libdrm, makeWrapper
}:

assert stdenv.isLinux;
assert stdenv.cc.cc.isGNU or false;

let
    version = "1.7.39";
    name = "wine-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/wine/${name}.tar.bz2";
      sha256 = "0p1kj61hkfyhbxdfgj3z3hlxi5nvcbdknkjqiicbabkpzq3v1zva";
    };

    gecko = fetchurl {
      url = "mirror://sourceforge/wine/wine_gecko-2.36-x86.msi";
      sha256 = "12hjks32yz9jq4w3xhk3y1dy2g3iakqxd7aldrdj51cqiz75g95g";
    };

    gecko64 = fetchurl {
      url = "mirror://sourceforge/wine/wine_gecko-2.36-x86_64.msi";
      sha256 = "0i7dchrzsda4nqbkhp3rrchk74rc2whn2af1wzda517m9c0886vh";
    };

    mono = fetchurl {
      url = "mirror://sourceforge/wine/wine-mono-4.5.4.msi";
      sha256 = "1wnn273f232141x9x0sahg4w499x0g2p0xphxmwm5wh1xrzyvg10";
    };

in stdenv.mkDerivation rec {
  inherit version name src;

  buildInputs = [
    pkgconfig
    xlibs.xlibs flex bison xlibs.libXi mesa mesa_noglu.osmesa
    xlibs.libXcursor xlibs.libXinerama xlibs.libXrandr
    xlibs.libXrender xlibs.libXxf86vm xlibs.libXcomposite
    alsaLib ncurses libpng libjpeg lcms fontforge
    libxml2 libxslt openssl gnutls cups makeWrapper
  ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath ${path}/lib ") [
    freetype fontconfig stdenv.cc.cc mesa mesa_noglu.osmesa libdrm
    xlibs.libXinerama xlibs.libXrender xlibs.libXrandr
    xlibs.libXcursor xlibs.libXcomposite libpng libjpeg
    openssl gnutls cups ncurses
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
    wrapProgram $out/bin/wine --prefix LD_LIBRARY_PATH : ${stdenv.cc.cc}/lib
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.winehq.org/";
    license = "LGPL";
    inherit version;
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
