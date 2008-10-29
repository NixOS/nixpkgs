{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation rec {
  name = "binutils-2.19";
  
  src = fetchurl {
    url = "mirror://gnu/binutils/${name}.tar.bz2";
    sha256 = "12jjvb9p9j59a46glxy15ff5h4i2s3izpx05gf8jmxibzh7s2bmx";
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
    description = "GNU Binutils, tools for manipulating binaries (linker, assembler, etc.)";

    homepage = http://www.gnu.org/software/binutils/;

    license = "GPLv3+";

    /* Give binutils a lower priority than gcc-wrapper to prevent a
       collision due to the ld/as wrappers/symlinks in the latter. */
    priority = "10";
  };
}
