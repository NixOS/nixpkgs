{ lib, stdenv, fetchurl, fetchpatch
, autoreconfHook, perl
, gdb, cctools, xnu, bootstrap_cmds
, writeScript
}:

stdenv.mkDerivation rec {
  pname = "valgrind";
  version = "3.23.0";

  src = fetchurl {
    url = "https://sourceware.org/pub/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-xcNKM4BFe5t1YG34kBAuffLHArlCDC6++VQPi11WJk0=";
  };

  patches = [
    # Fix build on ELFv2 powerpc64
    # https://bugs.kde.org/show_bug.cgi?id=398883
    (fetchurl {
      url = "https://github.com/void-linux/void-packages/raw/3e16b4606235885463fc9ab45b4c120f1a51aa28/srcpkgs/valgrind/patches/elfv2-ppc64-be.patch";
      sha256 = "NV/F+5aqFZz7+OF5oN5MUTpThv4H5PEY9sBgnnWohQY=";
    })
    # Fix checks on Musl.
    # https://bugs.kde.org/show_bug.cgi?id=453929
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=148912";
      sha256 = "Za+7K93pgnuEUQ+jDItEzWlN0izhbynX2crSOXBBY/I=";
    })
    # Fix build on armv7l.
    # https://bugs.kde.org/show_bug.cgi?id=454346
    #   Applied on 3.22.0. Does not apply on 3.23.0.
    #(fetchpatch {
    #  url = "https://bugsfiles.kde.org/attachment.cgi?id=149172";
    #  sha256 = "sha256-4MASLsEK8wcshboR4YOc6mIt7AvAgDPvqIZyHqlvTEs=";
    #})
    #(fetchpatch {
    #  url = "https://bugsfiles.kde.org/attachment.cgi?id=149173";
    #  sha256 = "sha256-jX9hD4utWRebbXMJYZ5mu9jecvdrNP05E5J+PnKRTyQ=";
    #})
    #(fetchpatch {
    #  url = "https://bugsfiles.kde.org/attachment.cgi?id=149174";
    #  sha256 = "sha256-f1YIFIhWhXYVw3/UNEWewDak2mvbAd3aGzK4B+wTlys=";
    #})
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  hardeningDisable = [ "pie" "stackprotector" ];

  # GDB is needed to provide a sane default for `--db-command'.
  # Perl is needed for `callgrind_{annotate,control}'.
  buildInputs = [ gdb perl ]  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ bootstrap_cmds xnu ];

  # Perl is also a native build input.
  nativeBuildInputs = [ autoreconfHook perl ];

  enableParallelBuilding = true;
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  preConfigure = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    substituteInPlace configure --replace '`uname -r`' \
        ${toString stdenv.hostPlatform.parsed.kernel.version}.0-
  '' + lib.optionalString stdenv.hostPlatform.isDarwin (
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
    lib.optional stdenv.hostPlatform.isx86_64 "--enable-only64bit"
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
    homepage = "https://valgrind.org/";
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
    platforms = with lib.platforms; lib.intersectLists
      (x86 ++ power ++ s390x ++ armv7 ++ aarch64 ++ mips)
      (darwin ++ freebsd ++ illumos ++ linux);
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
    broken = stdenv.hostPlatform.isDarwin; # https://hydra.nixos.org/build/128521440/nixlog/2
  };
}
