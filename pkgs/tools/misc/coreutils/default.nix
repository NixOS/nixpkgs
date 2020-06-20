{ stdenv, lib, buildPackages
, autoreconfHook, bison, texinfo, fetchurl, perl, xz, libiconv, gmp ? null
, aclSupport ? stdenv.isLinux, acl ? null
, attrSupport ? stdenv.isLinux, attr ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
# No openssl in default version, so openssl-induced rebuilds aren't too big.
# It makes *sum functions significantly faster.
, minimal ? true, withOpenssl ? !minimal, openssl ? null
, withPrefix ? false
, singleBinary ? "symlinks" # you can also pass "shebangs" or false
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> libselinux != null && libsepol != null;

with lib;

stdenv.mkDerivation (rec {
  pname = "coreutils";
  version = "8.31";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1zg9m79x1i2nifj4kb0waf9x3i5h6ydkypkjnbsb9rnwis8rqypz";
  };

  patches = optional stdenv.hostPlatform.isCygwin ./coreutils-8.23-4.cygwin.patch
         # Fix failing test with musl. See https://lists.gnu.org/r/coreutils/2019-05/msg00031.html
         # To be removed in coreutils-8.32.
         ++ optional stdenv.hostPlatform.isMusl ./avoid-false-positive-in-date-debug-test.patch
         # Fix compilation in musl-cross environments. To be removed in coreutils-8.32.
         ++ optional stdenv.hostPlatform.isMusl ./coreutils-8.31-musl-cross.patch
         # Fix compilation in android-cross environments. To be removed in coreutils-8.32.
         ++ [ ./coreutils-8.31-android-cross.patch ];

  postPatch = ''
    # The test tends to fail on btrfs,f2fs and maybe other unusual filesystems.
    sed '2i echo Skipping dd sparse test && exit 77' -i ./tests/dd/sparse.sh
    sed '2i echo Skipping du threshold test && exit 77' -i ./tests/du/threshold.sh
    sed '2i echo Skipping cp sparse test && exit 77' -i ./tests/cp/sparse.sh
    sed '2i echo Skipping rm deep-2 test && exit 77' -i ./tests/rm/deep-2.sh
    sed '2i echo Skipping du long-from-unreadable test && exit 77' -i ./tests/du/long-from-unreadable.sh

    # Some target platforms, especially when building inside a container have
    # issues with the inotify test.
    sed '2i echo Skipping tail inotify dir recreate test && exit 77' -i ./tests/tail-2/inotify-dir-recreate.sh

    # sandbox does not allow setgid
    sed '2i echo Skipping chmod setgid test && exit 77' -i ./tests/chmod/setgid.sh
    substituteInPlace ./tests/install/install-C.sh \
      --replace 'mode3=2755' 'mode3=1755'

    sed '2i print "Skipping env -S test";  exit 77;' -i ./tests/misc/env-S.pl

    # Fails on systems with a rootfs. Looks like a bug in the test, see
    # https://lists.gnu.org/archive/html/bug-coreutils/2019-12/msg00000.html
    sed '2i print "Skipping df skip-rootfs test"; exit 77' -i ./tests/df/skip-rootfs.sh

    # these tests fail in the unprivileged nix sandbox (without nix-daemon) as we break posix assumptions
    for f in ./tests/chgrp/{basic.sh,recurse.sh,default-no-deref.sh,no-x.sh,posix-H.sh}; do
      sed '2i echo Skipping chgrp && exit 77' -i "$f"
    done
    for f in gnulib-tests/{test-chown.c,test-fchownat.c,test-lchown.c}; do
      echo "int main() { return 77; }" > "$f"
    done
  '' + optionalString (stdenv.hostPlatform.libc == "musl") (lib.concatStringsSep "\n" [
    ''
      echo "int main() { return 77; }" > gnulib-tests/test-parse-datetime.c
      echo "int main() { return 77; }" > gnulib-tests/test-getlogin.c
    ''
  ]);

  outputs = [ "out" "info" ];

  nativeBuildInputs = [ perl xz.bin ]
    ++ optionals stdenv.hostPlatform.isCygwin [ autoreconfHook texinfo ]   # due to patch
    ++ optionals stdenv.hostPlatform.isMusl [ autoreconfHook bison ];   # due to patch
  configureFlags = [ "--with-packager=https://NixOS.org" ]
    ++ optional (singleBinary != false)
      ("--enable-single-binary" + optionalString (isString singleBinary) "=${singleBinary}")
    ++ optional withOpenssl "--with-openssl"
    ++ optional stdenv.hostPlatform.isSunOS "ac_cv_func_inotify_init=no"
    ++ optional withPrefix "--program-prefix=g"
    ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.libc == "glibc") [
      # TODO(19b98110126fde7cbb1127af7e3fe1568eacad3d): Needed for fstatfs() I
      # don't know why it is not properly detected cross building with glibc.
      "fu_cv_sys_stat_statfs2_bsize=yes"
    ];


  buildInputs = [ gmp ]
    ++ optional aclSupport acl
    ++ optional attrSupport attr
    ++ optional withOpenssl openssl
    ++ optionals selinuxSupport [ libselinux libsepol ]
       # TODO(@Ericson2314): Investigate whether Darwin could benefit too
    ++ optional (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.libc != "glibc") libiconv;

  # The tests are known broken on Cygwin
  # (http://article.gmane.org/gmane.comp.gnu.core-utils.bugs/19025),
  # Darwin (http://article.gmane.org/gmane.comp.gnu.core-utils.bugs/19351),
  # and {Open,Free}BSD.
  # With non-standard storeDir: https://github.com/NixOS/nix/issues/512
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform
    && (stdenv.hostPlatform.libc == "glibc" || stdenv.hostPlatform.isMusl)
    && builtins.storeDir == "/nix/store";

  # Prevents attempts of running 'help2man' on cross-built binaries.
  PERL = if stdenv.hostPlatform == stdenv.buildPlatform then null else "missing";

  # Saw random failures like ‘help2man: can't get '--help' info from
  # man/sha512sum.td/sha512sum’.
  enableParallelBuilding = false;

  NIX_LDFLAGS = optionalString selinuxSupport "-lsepol";
  FORCE_UNSAFE_CONFIGURE = optionalString stdenv.hostPlatform.isSunOS "1";

  # Works around a bug with 8.26:
  # Makefile:3440: *** Recursive variable 'INSTALL' references itself (eventually).  Stop.
  preInstall = optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i Makefile -e 's|^INSTALL =.*|INSTALL = ${buildPackages.coreutils}/bin/install -c|'
  '';

  postInstall = optionalString (stdenv.hostPlatform != stdenv.buildPlatform && !minimal) ''
    rm $out/share/man/man1/*
    cp ${buildPackages.coreutils-full}/share/man/man1/* $out/share/man/man1
  ''
  # du: 8.7 M locale + 0.4 M man pages
  + optionalString minimal ''
    rm -r "$out/share"
  '';

  meta = {
    homepage = "https://www.gnu.org/software/coreutils/";
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";

    longDescription = ''
      The GNU Core Utilities are the basic file, shell and text
      manipulation utilities of the GNU operating system.  These are
      the core utilities which are expected to exist on every
      operating system.
    '';

    license = licenses.gpl3Plus;

    platforms = platforms.unix ++ platforms.windows;

    priority = 10;

    maintainers = [ maintainers.eelco ];
  };
} // optionalAttrs stdenv.hostPlatform.isMusl {
  # Work around a bogus warning in conjunction with musl.
  NIX_CFLAGS_COMPILE = "-Wno-error";
} // stdenv.lib.optionalAttrs stdenv.hostPlatform.isAndroid {
  NIX_CFLAGS_COMPILE = "-D__USE_FORTIFY_LEVEL=0";
})
