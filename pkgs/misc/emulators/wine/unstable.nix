{ stdenv, fetchurl, pkgconfig, xlibs, flex, bison, mesa, mesa_noglu, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
, libxml2, libxslt, openssl, gnutls, cups, libdrm, makeWrapper
}:

assert stdenv.isLinux;
assert stdenv.gcc.gcc != null;

let
    version = "1.7.23";
    name = "wine-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/wine/${name}.tar.bz2";
      sha256 = "012ww1yifayakw9n2m23sx83dc3i2xiq3bn5n9iprppdhwxpp76v";
    };

    gecko = fetchurl {
      url = "mirror://sourceforge/wine/wine_gecko-2.24-x86.msi";
      sha256 = "0b10f55q3sldlcywscdlw3kd7vl9izlazw7jx30y4rpahypaqf3f";
    };

    gecko64 = fetchurl {
      url = "mirror://sourceforge/wine/wine_gecko-2.24-x86_64.msi";
      sha256 = "1j4wdlhzvjrabzr9igcnx0ivm5mcb8kp7bwkpfpfsanbifk7sma7";
    };

    mono = fetchurl {
      url = "mirror://sourceforge/wine/wine-mono-4.5.2.msi";
      sha256 = "1bgasysf3qacxgh5rlk7qlw47ar5zgd1k9gb22pihi5s87dlw4nr";
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
    freetype fontconfig stdenv.gcc.gcc mesa mesa_noglu.osmesa libdrm
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
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
