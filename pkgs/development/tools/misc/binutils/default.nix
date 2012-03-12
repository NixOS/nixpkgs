{ stdenv, fetchurl, noSysDirs, zlib, cross ? null, gold ? false, bison ? null, flex2535 ? null, bc ? null, dejagnu ? null }:

let basename = "binutils-2.21.1a"; in
stdenv.mkDerivation ( rec {
  name = basename + stdenv.lib.optionalString (cross != null) "-${cross.config}";

  src = fetchurl {
    url = "mirror://gnu/binutils/${basename}.tar.bz2";
    sha256 = "0m7nmd7gc9d9md43wbrv65hz6lbi2crqwryzpigv19ray1lzmv6d";
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
        sed -i "$i" -e 's|ln |ln -s |'
    done
  '';

  # As binutils takes part in the stdenv building, we don't want references
  # to the bootstrap-tools libgcc (as uses to happen on arm/mips)
  NIX_CFLAGS_COMPILE = "-static-libgcc";

  configureFlags = "--disable-werror" # needed for dietlibc build
      + stdenv.lib.optionalString (stdenv.system == "mips64el-linux")
        " --enable-fix-loongson2f-nop"
      + stdenv.lib.optionalString (cross != null) " --target=${cross.config}"
      + stdenv.lib.optionalString gold " --enable-gold";

  enableParallelBuilding = true;
      
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
} // (stdenv.lib.optionalAttrs gold { 
  postInstall = ''
    rm $out/bin/ld
    ln -sf $out/bin/ld.gold $out/bin/ld
  '';
} ) )
