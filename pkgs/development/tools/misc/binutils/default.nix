{stdenv, fetchurl, noSysDirs, cross ? null}:

let 
    basename = "binutils-2.20";
in
stdenv.mkDerivation rec {
  name = basename + stdenv.lib.optionalString (cross != null) "-${cross.config}";

  src = fetchurl {
    url = "mirror://gnu/binutils/${basename}.tar.bz2";
    sha256 = "1c3m789p5rwmmnck5ms4zcnc40axss3gxzivz571al1vmbq0kpz1";
  };

  patches = [
    # Turn on --enable-new-dtags by default to make the linker set
    # RUNPATH instead of RPATH on binaries.  This is important because
    # RUNPATH can be overriden using LD_LIBRARY_PATH at runtime.
    ./new-dtags.patch
  ];

  inherit noSysDirs;

  preConfigure = ''
    # Clear the default library search path.
    if test "$noSysDirs" = "1"; then
	echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt
    fi
  '';

  configureFlags = "--disable-werror" # needed for dietlibc build
      + stdenv.lib.optionalString (cross != null) " --target=${cross.config}";

  meta = {
    description = "GNU Binutils, tools for manipulating binaries (linker, assembler, etc.)";

    longDescription = ''
      The GNU Binutils are a collection of binary tools.  The main
      ones are `ld' (the GNU linker) and `as' (the GNU assembler).
      They also include the BFD (Binary File Descriptor) library,
      `gprof', `nm', `strip', etc.
    '';

    homepage = http://www.gnu.org/software/binutils/;

    license = "GPLv3+";

    /* Give binutils a lower priority than gcc-wrapper to prevent a
       collision due to the ld/as wrappers/symlinks in the latter. */
    priority = "10";
  };
}
