{ lib, stdenv, fetchurl, fetchpatch
, autoreconfHook, perl
, gdb, cctools, xnu, bootstrap_cmds
, writeScript
}:

stdenv.mkDerivation rec {
  pname = "valgrind";
  version = "3.19.0";

  src = fetchurl {
    url = "https://sourceware.org/pub/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-3V40SG8aSD/3vnMAzBa01rJGkJh4d8MnjXl1NNZzjwI=";
  };

  patches = [
    # Fix checks on Musl.
    # https://bugs.kde.org/show_bug.cgi?id=453929
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=148912";
      sha256 = "Za+7K93pgnuEUQ+jDItEzWlN0izhbynX2crSOXBBY/I=";
    })
    # Fix build on armv7l.
    # https://bugs.kde.org/show_bug.cgi?id=454346
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=149172";
      sha256 = "sha256-4MASLsEK8wcshboR4YOc6mIt7AvAgDPvqIZyHqlvTEs=";
    })
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=149173";
      sha256 = "sha256-jX9hD4utWRebbXMJYZ5mu9jecvdrNP05E5J+PnKRTyQ=";
    })
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=149174";
      sha256 = "sha256-f1YIFIhWhXYVw3/UNEWewDak2mvbAd3aGzK4B+wTlys=";
    })
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  hardeningDisable = [ "pie" "stackprotector" ];

  # GDB is needed to provide a sane default for `--db-command'.
  # Perl is needed for `callgrind_{annotate,control}'.
  buildInputs = [ gdb perl ]  ++ lib.optionals (stdenv.isDarwin) [ bootstrap_cmds xnu ];

  # Perl is also a native build input.
  nativeBuildInputs = [ autoreconfHook perl ];

  enableParallelBuilding = true;
  separateDebugInfo = stdenv.isLinux;

  preConfigure = lib.optionalString stdenv.isDarwin (
    let OSRELEASE = ''
      $(awk -F '"' '/#define OSRELEASE/{ print $2 }' \
      <${xnu}/Library/Frameworks/Kernel.framework/Headers/libkern/version.h)'';
    in ''
      echo "Don't derive our xnu version using uname -r."
      substituteInPlace configure --replace "uname -r" "echo ${OSRELEASE}"

      # Apple's GCC doesn't recognize `-arch' (as of version 4.2.1, build 5666).
      echo "getting rid of the \`-arch' GCC option..."
      find -name Makefile\* -exec \
        sed -i {} -e's/DARWIN\(.*\)-arch [^ ]\+/DARWIN\1/g' \;

      sed -i coregrind/link_tool_exe_darwin.in \
          -e 's/^my \$archstr = .*/my $archstr = "x86_64";/g'

      substituteInPlace coregrind/m_debuginfo/readmacho.c \
         --replace /usr/bin/dsymutil ${stdenv.cc.bintools.bintools}/bin/dsymutil

      echo "substitute hardcoded /usr/bin/ld with ${cctools}/bin/ld"
      substituteInPlace coregrind/link_tool_exe_darwin.in \
        --replace /usr/bin/ld ${cctools}/bin/ld
    '');

  configureFlags =
    lib.optional (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "x86_64-darwin") "--enable-only64bit"
    ++ lib.optional stdenv.hostPlatform.isDarwin "--with-xcodedir=${xnu}/include";

  doCheck = true;

  postInstall = ''
    for i in $out/libexec/valgrind/*.supp; do
      substituteInPlace $i \
        --replace 'obj:/lib' 'obj:*/lib' \
        --replace 'obj:/usr/X11R6/lib' 'obj:*/lib' \
        --replace 'obj:/usr/lib' 'obj:*/lib'
    done
  '';

  passthru = {
    updateScript = writeScript "update-valgrind" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of:
      #  'Current release: <a href="/downloads/current.html#current">valgrind-3.19.0</a>'
      new_version="$(curl -s https://valgrind.org/ |
          pcregrep -o1 'Current release: .*>valgrind-([0-9.]+)</a>')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = {
    homepage = "http://www.valgrind.org/";
    description = "Debugging and profiling tool suite";

    longDescription = ''
      Valgrind is an award-winning instrumentation framework for
      building dynamic analysis tools.  There are Valgrind tools that
      can automatically detect many memory management and threading
      bugs, and profile your programs in detail.  You can also use
      Valgrind to build new tools.
    '';

    license = lib.licenses.gpl2Plus;

    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.unix;
    badPlatforms = [
      "armv5tel-linux" "armv6l-linux" "armv6m-linux"
      "sparc-linux" "sparc64-linux"
      "riscv32-linux" "riscv64-linux"
      "alpha-linux"
    ];
    broken = stdenv.isDarwin || stdenv.hostPlatform.isStatic; # https://hydra.nixos.org/build/128521440/nixlog/2
  };
}
