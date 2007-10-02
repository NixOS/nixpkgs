{ stdenv, fetchurl, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
}:

assert stdenv.isLinux;

let lib = import ../../../lib/default.nix; in

stdenv.mkDerivation {
  name = "wine-0.9.46";

  src = fetchurl {
		url = mirror://sourceforge/wine/wine-0.9.46.tar.bz2;
		sha256 = "0c5fapw38bivipi8yzci3swxyhl9g67dpicqzslwmffwbi9y9z3i";
	};

  buildInputs = [
    xlibs.xlibs flex bison xlibs.libXi mesa
    xlibs.libXcursor xlibs.libXinerama xlibs.libXrandr
    xlibs.libXrender xlibs.libXxf86vm alsaLib ncurses
    libpng libjpeg lcms fontforge
  ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath " + path + "/lib") [
    freetype fontconfig stdenv.gcc.gcc mesa mesa.libdrm
    xlibs.libXinerama xlibs.libXrender xlibs.libXrandr xlibs.libXcursor
  ];

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;

  meta = {
    homepage = "http://www.winehq.org/";
    license = "LGPL";
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
  };
}
