{ stdenv, buildPackages
, fetchurl, zlib
, buildPlatform, hostPlatform, targetPlatform
, noSysDirs, gold ? true, bison ? null
}:

let
  # Note to whoever is upgrading this: 2.29 is broken.
  # ('nix-build pkgs/stdenv/linux/make-bootstrap-tools.nix -A test' segfaults on aarch64)
  # Also glibc might need patching, see commit 733e20fee4a6700510f71fbe1a58ac23ea202f6a.
  version = "2.28.1";
  basename = "binutils-${version}";
  inherit (stdenv.lib) optional optionals optionalString;
  # The prefix prepended to binary names to allow multiple binuntils on the
  # PATH to both be usable.
  prefix = optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-";
in

stdenv.mkDerivation rec {
  name = prefix + basename;

  src = fetchurl {
    url = "mirror://gnu/binutils/${basename}.tar.bz2";
    sha256 = "1sj234nd05cdgga1r36zalvvdkvpfbr12g5mir2n8i1dwsdrj939";
  };

  patches = [
    # Turn on --enable-new-dtags by default to make the linker set
    # RUNPATH instead of RPATH on binaries.  This is important because
    # RUNPATH can be overriden using LD_LIBRARY_PATH at runtime.
    ./new-dtags.patch

    # Since binutils 2.22, DT_NEEDED flags aren't copied for dynamic outputs.
    # That requires upstream changes for things to work. So we can patch it to
    # get the old behaviour by now.
    ./dtneeded.patch

    # Make binutils output deterministic by default.
    ./deterministic.patch

    # Always add PaX flags section to ELF files.
    # This is needed, for instance, so that running "ldd" on a binary that is
    # PaX-marked to disable mprotect doesn't fail with permission denied.
    ./pt-pax-flags.patch

    # Bfd looks in BINDIR/../lib for some plugins that don't
    # exist. This is pointless (since users can't install plugins
    # there) and causes a cycle between the lib and bin outputs, so
    # get rid of it.
    ./no-plugins.patch
  ];

  outputs = [ "out" ]
    ++ optional (targetPlatform == hostPlatform && !hostPlatform.isDarwin) "lib" # problems in Darwin stdenv
    ++ [ "info" ]
    ++ optional (targetPlatform == hostPlatform) "dev";

  nativeBuildInputs = [ bison ]
    ++ optional (hostPlatform != buildPlatform) buildPackages.stdenv.cc;
  buildInputs = [ zlib ];

  inherit noSysDirs;

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    # Clear the default library search path.
    if test "$noSysDirs" = "1"; then
        echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt
    fi

    # Use symlinks instead of hard links to save space ("strip" in the
    # fixup phase strips each hard link separately).
    for i in binutils/Makefile.in gas/Makefile.in ld/Makefile.in gold/Makefile.in; do
        sed -i "$i" -e 's|ln |ln -s |'
    done
  '';

  # As binutils takes part in the stdenv building, we don't want references
  # to the bootstrap-tools libgcc (as uses to happen on arm/mips)
  NIX_CFLAGS_COMPILE = if hostPlatform.isDarwin
    then "-Wno-string-plus-int -Wno-deprecated-declarations"
    else "-static-libgcc";

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = stdenv.lib.optionals (targetPlatform != hostPlatform) [ "build" "host" "target" ];
  configureFlags =
    [ "--enable-shared" "--enable-deterministic-archives" "--disable-werror" ]
    ++ optional (stdenv.system == "mips64el-linux") "--enable-fix-loongson2f-nop"
    ++ optionals gold [ "--enable-gold" "--enable-plugins" ]
    ++ optional (stdenv.system == "i686-linux") "--enable-targets=x86_64-linux-gnu";

  enableParallelBuilding = true;

  passthru = {
    inherit prefix;
  };

  meta = with stdenv.lib; {
    description = "Tools for manipulating binaries (linker, assembler, etc.)";
    longDescription = ''
      The GNU Binutils are a collection of binary tools.  The main
      ones are `ld' (the GNU linker) and `as' (the GNU assembler).
      They also include the BFD (Binary File Descriptor) library,
      `gprof', `nm', `strip', etc.
    '';
    homepage = http://www.gnu.org/software/binutils/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;

    /* Give binutils a lower priority than gcc-wrapper to prevent a
       collision due to the ld/as wrappers/symlinks in the latter. */
    priority = 10;
  };
}
