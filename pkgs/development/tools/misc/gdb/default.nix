{ lib, stdenv, targetPackages

# Build time
, fetchurl, pkg-config, perl, texinfo, setupDebugInfoDirs, buildPackages

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
  version = "11.1";

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}-${version}.tar.xz";
    sha256 = "151z6d0265hv9cgx9zqqa4bd6vbp20hrljhd6bxl7lr0gd0crkyc";
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
