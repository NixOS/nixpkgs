{ lib, stdenv, fetchurl, perl, xz, gmp ? null
, aclSupport ? false, acl ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
, autoconf, automake114x, texinfo
, withPrefix ? false
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> libselinux != null && libsepol != null;

with lib;

let
  self = stdenv.mkDerivation rec {
    name = "coreutils-8.25";

    src = fetchurl {
      url = "mirror://gnu/coreutils/${name}.tar.xz";
      sha256 = "11yfrnb94xzmvi4lhclkcmkqsbhww64wf234ya1aacjvg82prrii";
    };

    patches = optional stdenv.isCygwin ./coreutils-8.23-4.cygwin.patch;

    # The test tends to fail on btrfs and maybe other unusual filesystems.
    postPatch = optionalString (!stdenv.isDarwin) ''
      sed '2i echo Skipping dd sparse test && exit 0' -i ./tests/dd/sparse.sh
      sed '2i echo Skipping cp sparse test && exit 0' -i ./tests/cp/sparse.sh
    '';

    outputs = [ "out" "info" ];

    nativeBuildInputs = [ perl xz.bin ];
    configureFlags = optionalString stdenv.isSunOS "ac_cv_func_inotify_init=no";

    buildInputs = [ gmp ]
      ++ optional aclSupport acl
      ++ optionals stdenv.isCygwin [ autoconf automake114x texinfo ]   # due to patch
      ++ optionals selinuxSupport [ libselinux libsepol ];

    crossAttrs = {
      buildInputs = [ gmp.crossDrv ]
        ++ optional aclSupport acl.crossDrv
        ++ optionals selinuxSupport [ libselinux.crossDrv libsepol.crossDrv ]
        ++ optional (stdenv.ccCross.libc ? libiconv)
          stdenv.ccCross.libc.libiconv.crossDrv;

      buildPhase = ''
        make || (
          pushd man
          for a in *.x; do
            touch `basename $a .x`.1
          done
          popd; make )
      '';

      postInstall = ''
        rm $out/share/man/man1/*
        cp ${self}/share/man/man1/* $out/share/man/man1
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
    doCheck = stdenv ? glibc;

    # Saw random failures like ‘help2man: can't get '--help' info from
    # man/sha512sum.td/sha512sum’.
    enableParallelBuilding = false;

    NIX_LDFLAGS = optionalString selinuxSupport "-lsepol";
    FORCE_UNSAFE_CONFIGURE = optionalString stdenv.isSunOS "1";

    makeFlags = optionalString stdenv.isDarwin "CFLAGS=-D_FORTIFY_SOURCE=0";

    # e.g. ls -> gls; grep -> ggrep
    postFixup = optionalString withPrefix
      ''
        (
          cd "$out/bin"
          find * -type f -executable -exec mv {} g{} \;
        )
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

      platforms = platforms.all;

      maintainers = [ maintainers.eelco ];
    };
  };
in
  self
