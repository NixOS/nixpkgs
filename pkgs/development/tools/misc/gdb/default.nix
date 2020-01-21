{ stdenv, targetPackages

# Build time
, fetchurl, pkgconfig, perl, texinfo, setupDebugInfoDirs, buildPackages

# Run time
, ncurses, readline, gmp, mpfr, expat, libipt, zlib, dejagnu

, pythonSupport ? stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isCygwin, python3 ? null
, guile ? null
, safePaths ? [
   # $debugdir:$datadir/auto-load are whitelisted by default by GDB
   "$debugdir" "$datadir/auto-load"
   # targetPackages so we get the right libc when cross-compiling and using buildPackages.gdb
   targetPackages.stdenv.cc.cc.lib
  ]
}:

let
  basename = "gdb-${version}";
  version = "8.3.1";
in

assert pythonSupport -> python3 != null;

stdenv.mkDerivation rec {
  name =
    stdenv.lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                              (stdenv.targetPlatform.config + "-")
    + basename;

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}.tar.xz";
    sha256 = "1i2pjwaafrlz7wqm40b4znr77ai32rjsxkpl2az38yyarpbv8m8y";
  };

  postPatch = if stdenv.isDarwin then ''
    substituteInPlace gdb/darwin-nat.c \
      --replace '#include "bfd/mach-o.h"' '#include "mach-o.h"'
  '' else null;

  patches = [
    ./debug-info-from-env.patch
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    ./darwin-target-match.patch
  ];

  nativeBuildInputs = [ pkgconfig texinfo perl setupDebugInfoDirs ];

  buildInputs = [ ncurses readline gmp mpfr expat libipt zlib guile ]
    ++ stdenv.lib.optional pythonSupport python3
    ++ stdenv.lib.optional doCheck dejagnu;

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = stdenv.lib.optionals stdenv.isDarwin [ "format" ];

  NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ] ++ stdenv.lib.optional (stdenv.targetPlatform != stdenv.hostPlatform) "target";

  configureFlags = with stdenv.lib; [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--disable-install-libbfd"
    "--disable-shared" "--enable-static"
    "--with-system-zlib"
    "--with-system-readline"

    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-expat" "--with-libexpat-prefix=${expat.dev}"
    "--with-auto-load-safe-path=${builtins.concatStringsSep ":" safePaths}"
  ] ++ stdenv.lib.optional (!pythonSupport) "--without-python";

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/bfd.info
    '';

  # TODO: Investigate & fix the test failures.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "The GNU Project debugger";

    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';

    homepage = https://www.gnu.org/software/gdb/;

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = with platforms; linux ++ cygwin ++ darwin;
    maintainers = with maintainers; [ pierron globin ];
  };
}
