{ stdenv, fetchurl, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontconfig, fontforge
}:

assert stdenv.isLinux;

let lib = import ../../../lib/default.nix; in

stdenv.mkDerivation {
  name = "wine-0.9.53";

  src = fetchurl {
		#url = mirror://sourceforge/wine/wine-0.9.49.tar.bz2;
		url = mirror://sourceforge/wine/wine-0.9.53.tar.bz2;
		#sha256 = "d41edd08cf7fd21d7350a633995107533a25f925c8859995d3a6fc131f54b3c1";
		sha256 = "06317d78b7db39458656b6acc6b265ce97f358aefd7ded679263f397a89f1200";
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
