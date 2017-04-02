{ lib, stdenv, buildPackages, fetchurl, perl, xz, gmp ? null
, aclSupport ? false, acl ? null
, attrSupport ? false, attr ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
, autoconf, automake114x, texinfo
, withPrefix ? false
, singleBinary ? "symlinks" # you can also pass "shebangs" or false
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> libselinux != null && libsepol != null;

with lib;

stdenv.mkDerivation rec {
  name = "coreutils-8.27";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.xz";
    sha256 = "0sv547572iq8ayy8klir4hnngnx92a9nsazmf1wgzfc7xr4x74c8";
  };

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  patches = optional stdenv.isCygwin ./coreutils-8.23-4.cygwin.patch;

  # The test tends to fail on btrfs and maybe other unusual filesystems.
  postPatch = optionalString (!stdenv.isDarwin) ''
    sed '2i echo Skipping dd sparse test && exit 0' -i ./tests/dd/sparse.sh
    sed '2i echo Skipping cp sparse test && exit 0' -i ./tests/cp/sparse.sh
    sed '2i echo Skipping rm deep-2 test && exit 0' -i ./tests/rm/deep-2.sh
    sed '2i echo Skipping du long-from-unreadable test && exit 0' -i ./tests/du/long-from-unreadable.sh
  '';

  outputs = [ "out" "info" ];

  nativeBuildInputs = [ perl xz.bin ];
  configureFlags =
    optional (singleBinary != false)
      ("--enable-single-binary" + optionalString (isString singleBinary) "=${singleBinary}")
    ++ optional stdenv.isSunOS "ac_cv_func_inotify_init=no"
    ++ optional withPrefix "--program-prefix=g";

  buildInputs = [ gmp ]
    ++ optional aclSupport acl
    ++ optional attrSupport attr
    ++ optionals stdenv.isCygwin [ autoconf automake114x texinfo ]   # due to patch
    ++ optionals selinuxSupport [ libselinux libsepol ];

  crossAttrs = {
    buildInputs = [ gmp.crossDrv ]
      ++ optional aclSupport acl.crossDrv
      ++ optional attrSupport attr.crossDrv
      ++ optionals selinuxSupport [ libselinux.crossDrv libsepol.crossDrv ]
      ++ optional (stdenv.ccCross.libc ? libiconv)
        stdenv.ccCross.libc.libiconv.crossDrv;

    # Prevents attempts of running 'help2man' on cross-built binaries.
    PERL = "missing";

    # Works around a bug with 8.26:
    # Makefile:3440: *** Recursive variable 'INSTALL' references itself (eventually).  Stop.
    preInstall = ''
      sed -i Makefile -e 's|^INSTALL =.*|INSTALL = ${buildPackages.coreutils}/bin/install -c|'
    '';

    postInstall = ''
      rm $out/share/man/man1/*
      cp ${buildPackages.coreutils}/share/man/man1/* $out/share/man/man1
    '';

    # Needed for fstatfs()
    # I don't know why it is not properly detected cross building with glibc.
    configureFlags = [ "fu_cv_sys_stat_statfs2_bsize=yes" ];
    doCheck = false;
  };

  # The tests are known broken on Cygwin
  # (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19025),
  # Darwin (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19351),
  # and {Open,Free}BSD.
  # With non-standard storeDir: https://github.com/NixOS/nix/issues/512
  doCheck = stdenv ? glibc && builtins.storeDir == "/nix/store";

  # Saw random failures like ‘help2man: can't get '--help' info from
  # man/sha512sum.td/sha512sum’.
  enableParallelBuilding = false;

  NIX_LDFLAGS = optionalString selinuxSupport "-lsepol";
  FORCE_UNSAFE_CONFIGURE = optionalString stdenv.isSunOS "1";

  makeFlags = optionalString stdenv.isDarwin "CFLAGS=-D_FORTIFY_SOURCE=0";

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

    platforms = platforms.all;

    maintainers = [ maintainers.eelco ];
  };
}
