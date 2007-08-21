{ stdenv, fetchurl, xlibs, flex, bison, mesa, alsaLib
, ncurses, libpng, libjpeg, lcms, freetype, fontforge
}:

assert stdenv.isLinux;

let lib = import ../../../lib/default.nix; in

stdenv.mkDerivation {
  name = "wine-0.9.43";

  src = fetchurl {
    url = http://switch.dl.sourceforge.net/sourceforge/wine/wine-0.9.43.tar.bz2;
    sha256 = "0r6rz3zi5p7razn957lf2zy290hp36jrlfz4cpy23y9179r8i66x";
  };

  buildInputs = [
    xlibs.xlibs flex bison xlibs.libXi mesa
    xlibs.libXcursor xlibs.libXinerama xlibs.libXrandr
    xlibs.libXrender xlibs.libXxf86vm alsaLib ncurses
    libpng libjpeg lcms fontforge
  ];

  patches = [
    # Based on http://bugs.winehq.org/attachment.cgi?id=5708,
    # see http://bugs.winehq.org/show_bug.cgi?id=2398.
    ./opengl-child-window.patch
  ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath " + path + "/lib") [
    freetype stdenv.gcc.gcc mesa mesa.libdrm
    xlibs.libXinerama xlibs.libXrender xlibs.libXrandr xlibs.libXcursor
  ];

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;
}
