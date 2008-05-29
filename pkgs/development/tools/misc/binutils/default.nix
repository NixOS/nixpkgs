{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "binutils-2.18";
  
  src = fetchurl {
    url = mirror://gnu/binutils/binutils-2.18.tar.bz2;
    sha256 = "16zfc7llbjdn69bbdy7kqgg2xa67ypgj7z5qicgwzvghaaj36yj8";
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
  
  configureFlags = "--disable-werror"; # needed for dietlibc build

  meta = {
    description = "Tools for manipulating binaries (linker, assembler, etc.)";

    /* Give binutils a lower priority than gcc-wrapper to prevent a
       collision due to the ld/as wrappers/symlinks in the latter. */
    priority = "10";
  };
}
