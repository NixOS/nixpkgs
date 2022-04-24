{ lib, stdenv, targetPackages

# Build time
, fetchurl, fetchpatch, pkg-config, perl, texinfo, setupDebugInfoDirs, buildPackages

# Run time
, ncurses, readline, gmp, mpfr, expat, libipt, zlib, dejagnu, sourceHighlight

, pythonSupport ? stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isCygwin, python3 ? null
, enableDebuginfod ? false, elfutils
, guile ? null
, safePaths ? [
   # $debugdir:$datadir/auto-load are whitelisted by default by GDB
   "$debugdir" "$datadir/auto-load"
   # targetPackages so we get the right libc when cross-compiling and using buildPackages.gdb
   targetPackages.stdenv.cc.cc.lib
  ]
}:

let
  basename = "gdb";
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                 "${stdenv.targetPlatform.config}-";
in

assert pythonSupport -> python3 != null;

stdenv.mkDerivation rec {
  pname = targetPrefix + basename;
  version = "11.2";

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}-${version}.tar.xz";
    hash = "sha256-FJfDanGIG4ZxqahKDuQPqreIyjDXuhnYRjw8x4cVLjI=";
  };

  postPatch = if stdenv.isDarwin then ''
    substituteInPlace gdb/darwin-nat.c \
      --replace '#include "bfd/mach-o.h"' '#include "mach-o.h"'
  '' else if stdenv.hostPlatform.isMusl then ''
    substituteInPlace sim/ppc/emul_unix.c --replace sys/termios.h termios.h
  '' else null;

  patches = [
    ./debug-info-from-env.patch

    # Pull upstream fix for gcc-12. Will be included in gdb-12.
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://sourceware.org/git/?p=binutils-gdb.git;a=patch;h=e97436b1b789dcdb6ffb502263f4c86f8bc22996";
      sha256 = "1mpgw6s9qgnwhwyg3hagc6vhqhvia0l1s8nr22bcahwqxi3wvzcw";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    ./darwin-target-match.patch
  ] ++ lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
    name = "musl-fix-pagesize-page_size.patch";
    url = "https://sourceware.org/git/?p=binutils-gdb.git;a=patch;h=fd0975b96b16d96010dce439af9620d3dfb65426";
    hash = "sha256-M3U7uIIFJnYu0g8/sMLJPhm02q7cGOi6pLjgsUUjeKI=";
  });

  nativeBuildInputs = [ pkg-config texinfo perl setupDebugInfoDirs ];

  buildInputs = [ ncurses readline gmp mpfr expat libipt zlib guile sourceHighlight ]
    ++ lib.optional pythonSupport python3
    ++ lib.optional doCheck dejagnu
    ++ lib.optional enableDebuginfod (elfutils.override { enableDebuginfod = true; });

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = lib.optionals stdenv.isDarwin [ "format" ];

  NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  configurePlatforms = [ "build" "host" "target" ];

  # GDB have to be built out of tree.
  preConfigure = ''
    mkdir _build
    cd _build
  '';
  configureScript = "../configure";

  configureFlags = with lib; [
    # Set the program prefix to the current targetPrefix.
    # This ensures that the prefix always conforms to
    # nixpkgs' expectations instead of relying on the build
    # system which only receives `config` which is merely a
    # subset of the platform description.
    "--program-prefix=${targetPrefix}"

    "--enable-targets=all" "--enable-64-bit-bfd"
    "--disable-install-libbfd"
    "--disable-shared" "--enable-static"
    "--with-system-zlib"
    "--with-system-readline"

    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-expat" "--with-libexpat-prefix=${expat.dev}"
    "--with-auto-load-safe-path=${builtins.concatStringsSep ":" safePaths}"
  ] ++ lib.optional (!pythonSupport) "--without-python"
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-nls"
    ++ lib.optional enableDebuginfod "--with-debuginfod=yes";

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/bfd.info
    '';

  # TODO: Investigate & fix the test failures.
  doCheck = false;

  meta = with lib; {
    description = "The GNU Project debugger";

    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';

    homepage = "https://www.gnu.org/software/gdb/";

    license = lib.licenses.gpl3Plus;

    platforms = with platforms; linux ++ cygwin ++ darwin;
    maintainers = with maintainers; [ pierron globin lsix ];
  };
}
