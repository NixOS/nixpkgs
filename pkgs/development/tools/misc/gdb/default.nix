{ lib, stdenv, targetPackages

# Build time
, fetchurl, pkg-config, perl, texinfo, setupDebugInfoDirs, buildPackages

# Run time
, ncurses, readline, gmp, mpfr, expat, libipt, zlib, zstd, xz, dejagnu, sourceHighlight, libiconv

, pythonSupport ? stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isCygwin, python3 ? null
, enableDebuginfod ? lib.meta.availableOn stdenv.hostPlatform elfutils, elfutils
, guile ? null
, hostCpuOnly ? false
, enableSim ? false
, safePaths ? [
   # $debugdir:$datadir/auto-load are whitelisted by default by GDB
   "$debugdir" "$datadir/auto-load"
   # targetPackages so we get the right libc when cross-compiling and using buildPackages.gdb
   targetPackages.stdenv.cc.cc.lib
  ]
, writeScript
}:

let
  basename = "gdb";
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                 "${stdenv.targetPlatform.config}-";
in

assert pythonSupport -> python3 != null;

stdenv.mkDerivation rec {
  pname = targetPrefix + basename + lib.optionalString hostCpuOnly "-host-cpu-only";
  version = "14.2";

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}-${version}.tar.xz";
    hash = "sha256-LU3YBh2N7RK2xj9V5FNEiB6CJhBfTSqbI0BA76XOd3I=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace gdb/darwin-nat.c \
      --replace '#include "bfd/mach-o.h"' '#include "mach-o.h"'
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace sim/erc32/erc32.c  --replace sys/fcntl.h fcntl.h
    substituteInPlace sim/erc32/interf.c  --replace sys/fcntl.h fcntl.h
    substituteInPlace sim/erc32/sis.c  --replace sys/fcntl.h fcntl.h
    substituteInPlace sim/ppc/emul_unix.c --replace sys/termios.h termios.h
  '';

  patches = [
    ./debug-info-from-env.patch
  ] ++ lib.optionals stdenv.isDarwin [
    ./darwin-target-match.patch
  ];

  nativeBuildInputs = [ pkg-config texinfo perl setupDebugInfoDirs ];

  buildInputs = [ ncurses readline gmp mpfr expat libipt zlib zstd xz guile sourceHighlight ]
    ++ lib.optional pythonSupport python3
    ++ lib.optional doCheck dejagnu
    ++ lib.optional enableDebuginfod (elfutils.override { enableDebuginfod = true; })
    ++ lib.optional stdenv.isDarwin libiconv;

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = lib.optionals stdenv.isDarwin [ "format" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  configurePlatforms = [ "build" "host" "target" ];

  preConfigure = ''
    # remove precompiled docs, required for man gdbinit to mention /etc/gdb/gdbinit
    rm gdb/doc/*.info*
    rm gdb/doc/*.5
    rm gdb/doc/*.1
    # fix doc build https://sourceware.org/bugzilla/show_bug.cgi?id=27808
    rm gdb/doc/GDBvn.texi

    # GDB have to be built out of tree.
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

    "--disable-werror"
  ] ++ lib.optional (!hostCpuOnly) "--enable-targets=all" ++ [
    "--enable-64-bit-bfd"
    "--disable-install-libbfd"
    "--disable-shared" "--enable-static"
    "--with-system-zlib"
    "--with-system-readline"

    "--with-system-gdbinit=/etc/gdb/gdbinit"
    "--with-system-gdbinit-dir=/etc/gdb/gdbinit.d"

    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-expat" "--with-libexpat-prefix=${expat.dev}"
    "--with-auto-load-safe-path=${builtins.concatStringsSep ":" safePaths}"
  ] ++ lib.optional (!pythonSupport) "--without-python"
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-nls"
    ++ lib.optional stdenv.hostPlatform.isStatic "--disable-inprocess-agent"
    ++ lib.optional enableDebuginfod "--with-debuginfod=yes"
    ++ lib.optional (!enableSim) "--disable-sim";

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/bfd.info
    '';

  # TODO: Investigate & fix the test failures.
  doCheck = false;

  passthru = {
    updateScript = writeScript "update-gdb" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '<h3>GDB version 12.1</h3>'
      new_version="$(curl -s https://www.sourceware.org/gdb/ |
          pcregrep -o1 '<h3>GDB version ([0-9.]+)</h3>')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    mainProgram = "gdb";

    description = "GNU Project debugger";

    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';

    homepage = "https://www.gnu.org/software/gdb/";

    license = lib.licenses.gpl3Plus;

    # GDB upstream does not support ARM darwin
    platforms = with platforms; linux ++ cygwin ++ ["x86_64-darwin"];
    maintainers = with maintainers; [ pierron globin lsix ];
  };
}
