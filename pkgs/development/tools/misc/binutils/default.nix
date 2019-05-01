{ stdenv, lib, buildPackages
, fetchurl, zlib, autoreconfHook
# Enabling all targets increases output size to a multiple.
, withAllTargets ? false, libbfd, libopcodes
, enableShared ? true
, noSysDirs, gold ? true, bison ? null
, fetchpatch
}:

let
  reuseLibs = enableShared && withAllTargets;

  # Remove gold-symbol-visibility patch when updating, the proper fix
  # is now upstream.
  # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commitdiff;h=330b90b5ffbbc20c5de6ae6c7f60c40fab2e7a4f;hp=99181ccac0fc7d82e7dabb05dc7466e91f1645d3
  version = "2.31.1";
  basename = "binutils-${version}";
  # The targetPrefix prepended to binary names to allow multiple binuntils on the
  # PATH to both be usable.
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                  "${stdenv.targetPlatform.config}-";
in

stdenv.mkDerivation rec {
  name = targetPrefix + basename;

  # HACK to ensure that we preserve source from bootstrap binutils to not rebuild LLVM
  src = stdenv.__bootPackages.binutils-unwrapped.src or (fetchurl {
    url = "mirror://gnu/binutils/${basename}.tar.bz2";
    sha256 = "1l34hn1zkmhr1wcrgf0d4z7r3najxnw3cx2y2fk7v55zjlk3ik7z";
  });

  patches = [
    # Make binutils output deterministic by default.
    ./deterministic.patch

    # Bfd looks in BINDIR/../lib for some plugins that don't
    # exist. This is pointless (since users can't install plugins
    # there) and causes a cycle between the lib and bin outputs, so
    # get rid of it.
    ./no-plugins.patch

    # Help bfd choose between elf32-littlearm, elf32-littlearm-symbian, and
    # elf32-littlearm-vxworks in favor of the first.
    # https://github.com/NixOS/nixpkgs/pull/30484#issuecomment-345472766
    ./disambiguate-arm-targets.patch

    # For some reason bfd ld doesn't search DT_RPATH when cross-compiling. It's
    # not clear why this behavior was decided upon but it has the unfortunate
    # consequence that the linker will fail to find transitive dependencies of
    # shared objects when cross-compiling. Consequently, we are forced to
    # override this behavior, forcing ld to search DT_RPATH even when
    # cross-compiling.
    ./always-search-rpath.patch

    # https://sourceware.org/bugzilla/show_bug.cgi?id=22868
    ./gold-symbol-visibility.patch

    # https://sourceware.org/bugzilla/show_bug.cgi?id=23428
    # un-break features so linking against musl doesn't produce crash-only binaries
    ./0001-x86-Add-a-GNU_PROPERTY_X86_ISA_1_USED-note-if-needed.patch
    ./0001-x86-Properly-merge-GNU_PROPERTY_X86_ISA_1_USED.patch
    ./0001-x86-Properly-add-X86_ISA_1_NEEDED-property.patch
  ] ++ lib.optional stdenv.targetPlatform.isiOS ./support-ios.patch
    ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.targetPlatform != stdenv.hostPlatform) [
    (fetchpatch {
      url = "https://sourceware.org/bugzilla/attachment.cgi?id=11141";
      name = "gold-threads.patch";
      sha256 = "0p26dxpba8n7z3pwjg7qf94f0gzbvwkjq0j9ng1w3sljj0gyaf1j";
    })
  ];

  outputs = [ "out" "info" "man" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    bison
  ] ++ lib.optionals stdenv.targetPlatform.isiOS [
    autoreconfHook
  ];
  buildInputs = [ zlib ];

  inherit noSysDirs;

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
  NIX_CFLAGS_COMPILE = if stdenv.hostPlatform.isDarwin
    then "-Wno-string-plus-int -Wno-deprecated-declarations"
    else "-static-libgcc";

  hardeningDisable = [ "format" "pie" ];

  # TODO(@Ericson2314): Always pass "--target" and always targetPrefix.
  configurePlatforms = [ "build" "host" ] ++ lib.optional (stdenv.targetPlatform != stdenv.hostPlatform) "target";

  configureFlags =
    (if enableShared then [ "--enable-shared" "--disable-static" ]
                     else [ "--disable-shared" "--enable-static" ])
  ++ lib.optional withAllTargets "--enable-targets=all"
  ++ [
    "--enable-64-bit-bfd"
    "--with-system-zlib"

    "--enable-deterministic-archives"
    "--disable-werror"
    "--enable-fix-loongson2f-nop"

    # Turn on --enable-new-dtags by default to make the linker set
    # RUNPATH instead of RPATH on binaries.  This is important because
    # RUNPATH can be overriden using LD_LIBRARY_PATH at runtime.
    "--enable-new-dtags"
  ] ++ lib.optionals gold [ "--enable-gold" "--enable-plugins" ];

  doCheck = false; # fails

  postFixup = lib.optionalString reuseLibs ''
    rm "$out"/lib/lib{bfd,opcodes}-${version}.so
    ln -s '${lib.getLib libbfd}/lib/libbfd-${version}.so' "$out/lib/"
    ln -s '${lib.getLib libopcodes}/lib/libopcodes-${version}.so' "$out/lib/"
  '';

  # else fails with "./sanity.sh: line 36: $out/bin/size: not found"
  doInstallCheck = stdenv.buildPlatform == stdenv.hostPlatform && stdenv.hostPlatform == stdenv.targetPlatform;

  enableParallelBuilding = true;

  passthru = {
    inherit targetPrefix version;
  };

  meta = with lib; {
    description = "Tools for manipulating binaries (linker, assembler, etc.)";
    longDescription = ''
      The GNU Binutils are a collection of binary tools.  The main
      ones are `ld' (the GNU linker) and `as' (the GNU assembler).
      They also include the BFD (Binary File Descriptor) library,
      `gprof', `nm', `strip', etc.
    '';
    homepage = https://www.gnu.org/software/binutils/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;

    /* Give binutils a lower priority than gcc-wrapper to prevent a
       collision due to the ld/as wrappers/symlinks in the latter. */
    priority = 10;
  };
}
