{ stdenv, fetchurl, noSysDirs, zlib, cross ? null, gold ? false, bison ? null, flex2535 ? null, bc ? null, dejagnu ? null }:

let
    basename = "binutils-2.21";
in
stdenv.mkDerivation rec {
  name = basename + stdenv.lib.optionalString (cross != null) "-${cross.config}";

  # WARNING: Upstream made a mistake in packaging that may mean anyone
  # but the FSF hosting this tarball is accidentally in violation of
  # the GPL. We can't update binutils until the next stdenv-updates,
  # so we are stuck with this version. The issue is discussed in
  # this email: http://sourceware.org/ml/binutils/2011-08/msg00198.html
  # The tarball for this minor version will not be fixed, as only the
  # tarballs for the latest minor version of each major version will
  # be repackaged. The fixed sources for the closest version to this one
  # can be found at mirror://gnu/binutils/binutils-2.21.1a.tar.bz2
  # or http://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2
  # The sources missing from this tarball come from cgen. It is unclear
  # WHICH sources should be included, but the cvs tree can be checked out
  # by:
  # cvs -z 9 -d :pserver:anoncvs@sourceware.org:/cvs/src login
  # {enter "anoncvs" as the password}
  # cvs -z 9 -d :pserver:anoncvs@sourceware.org:/cvs/src co cgen
  src = fetchurl {
    url = "http://nixos.org/tarballs/${basename}.tar.bz2";
    sha256 = "1iyhc42zfa0j2gaxy4zvpk47sdqj4rqvib0mb8597ss8yidyrav0";
  };

  patches = [
    # Turn on --enable-new-dtags by default to make the linker set
    # RUNPATH instead of RPATH on binaries.  This is important because
    # RUNPATH can be overriden using LD_LIBRARY_PATH at runtime.
    ./new-dtags.patch
  ];

  buildInputs =
    [ zlib ]
    ++ stdenv.lib.optional gold [dejagnu flex2535 bison /* Some Gold tests require this: */ bc];

  inherit noSysDirs;

  preConfigure = ''
    # Clear the default library search path.
    if test "$noSysDirs" = "1"; then
	echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt
    fi

    # Use symlinks instead of hard links to save space ("strip" in the
    # fixup phase strips each hard link separately).
    for i in binutils/Makefile.in gas/Makefile.in ld/Makefile.in; do
        substituteInPlace $i --replace 'ln ' 'ln -s '
    done
  '';

  configureFlags = "--disable-werror" # needed for dietlibc build
      + stdenv.lib.optionalString (stdenv.system == "mips64el-linux")
        " --enable-fix-loongson2f-nop"
      + stdenv.lib.optionalString (cross != null) " --target=${cross.config}"
      + stdenv.lib.optionalString gold " --enable-gold";

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
