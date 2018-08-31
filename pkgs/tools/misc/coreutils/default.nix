{ stdenv, lib, buildPackages
, autoreconfHook, texinfo, fetchurl, perl, xz, libiconv, gmp ? null
, aclSupport ? false, acl ? null
, attrSupport ? false, attr ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
, withPrefix ? false
, singleBinary ? "symlinks" # you can also pass "shebangs" or false
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> libselinux != null && libsepol != null;

with lib;

stdenv.mkDerivation rec {
  name = "coreutils-8.29";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.xz";
    sha256 = "0plm1zs9il6bb5mk881qvbghq4glc8ybbgakk2lfzb0w64fgml4j";
  };

  patches = optional stdenv.hostPlatform.isCygwin ./coreutils-8.23-4.cygwin.patch;

  # The test tends to fail on btrfs and maybe other unusual filesystems.
  postPatch = optionalString (!stdenv.hostPlatform.isDarwin) ''
    sed '2i echo Skipping dd sparse test && exit 0' -i ./tests/dd/sparse.sh
    sed '2i echo Skipping cp sparse test && exit 0' -i ./tests/cp/sparse.sh
    sed '2i echo Skipping rm deep-2 test && exit 0' -i ./tests/rm/deep-2.sh
    sed '2i echo Skipping du long-from-unreadable test && exit 0' -i ./tests/du/long-from-unreadable.sh
    sed '2i echo Skipping chmod setgid test && exit 0' -i ./tests/chmod/setgid.sh
    substituteInPlace ./tests/install/install-C.sh \
      --replace 'mode3=2755' 'mode3=1755'
  '';

  outputs = [ "out" "info" ];

  nativeBuildInputs = [ perl xz.bin ];
  configureFlags =
    optional (singleBinary != false)
      ("--enable-single-binary" + optionalString (isString singleBinary) "=${singleBinary}")
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
    ++ optionals stdenv.hostPlatform.isCygwin [ autoreconfHook texinfo ]   # due to patch
    ++ optionals selinuxSupport [ libselinux libsepol ]
       # TODO(@Ericson2314): Investigate whether Darwin could benefit too
    ++ optional (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.libc != "glibc") libiconv;

  # The tests are known broken on Cygwin
  # (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19025),
  # Darwin (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19351),
  # and {Open,Free}BSD.
  # With non-standard storeDir: https://github.com/NixOS/nix/issues/512
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform
    && stdenv.hostPlatform.libc == "glibc"
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

  postInstall = optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    rm $out/share/man/man1/*
    cp ${buildPackages.coreutils}/share/man/man1/* $out/share/man/man1
  '';

  meta = {
    homepage = http://www.gnu.org/software/coreutils/;
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";

    longDescription = ''
      The GNU Core Utilities are the basic file, shell and text
      manipulation utilities of the GNU operating system.  These are
      the core utilities which are expected to exist on every
      operating system.
    '';

    license = licenses.gpl3Plus;

    platforms = platforms.unix;

    maintainers = [ maintainers.eelco ];
  };

}
