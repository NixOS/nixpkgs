{ lib, stdenv, targetPackages

# Build time
, fetchurl, pkg-config, perl, texinfo, setupDebugInfoDirs, buildPackages

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
  basename = "gdb";
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                 "${stdenv.targetPlatform.config}-";
in

assert pythonSupport -> python3 != null;

stdenv.mkDerivation rec {
  pname = targetPrefix + basename;
  version = "10.1";

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}-${version}.tar.xz";
    sha256 = "1h32dckz1y8fnyxh22iyw8h3hnhxr79v1ng85px3ljn1xv71wbzq";
  };

  postPatch = if stdenv.isDarwin then ''
    substituteInPlace gdb/darwin-nat.c \
      --replace '#include "bfd/mach-o.h"' '#include "mach-o.h"'
  '' else null;

  patches = [
    ./debug-info-from-env.patch
  ] ++ lib.optionals stdenv.isDarwin [
    ./darwin-target-match.patch
  ];

  nativeBuildInputs = [ pkg-config texinfo perl setupDebugInfoDirs ];

  buildInputs = [ ncurses readline gmp mpfr expat libipt zlib guile ]
    ++ lib.optional pythonSupport python3
    ++ lib.optional doCheck dejagnu;

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = lib.optionals stdenv.isDarwin [ "format" ];

  NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ] ++ lib.optional (stdenv.targetPlatform != stdenv.hostPlatform) "target";

  # GDB have to be built out of tree.
  preConfigure = ''
    mkdir _build
    cd _build
  '';
  configureScript = "../configure";

  configureFlags = with lib; [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--disable-install-libbfd"
    "--disable-shared" "--enable-static"
    "--with-system-zlib"
    "--with-system-readline"

    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-expat" "--with-libexpat-prefix=${expat.dev}"
    "--with-auto-load-safe-path=${builtins.concatStringsSep ":" safePaths}"
  ] ++ lib.optional (!pythonSupport) "--without-python";

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
