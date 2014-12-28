{ stdenv, fetchurl, perl, gmp ? null
, aclSupport ? false, acl ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> libselinux != null && libsepol != null;


with { inherit (stdenv.lib) optional optionals optionalString optionalAttrs; };

let
  self = stdenv.mkDerivation rec {
    name = "coreutils-8.23";

    src = fetchurl {
      url = "mirror://gnu/coreutils/${name}.tar.xz";
      sha256 = "0bdq6yggyl7nkc2pbl6pxhhyx15nyqhz3ds6rfn448n6rxdwlhzc";
    };

    nativeBuildInputs = [ perl ];
    buildInputs = [ gmp ]
      ++ optional aclSupport acl
      ++ optionals selinuxSupport [ libselinux libsepol ];

    crossAttrs = {
      buildInputs = [ gmp ]
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

      license = stdenv.lib.licenses.gpl3Plus;

      maintainers = [ stdenv.lib.maintainers.eelco ];
    };
  };
in
  self
  // stdenv.lib.optionalAttrs (stdenv.system == "armv7l-linux" || stdenv.isSunOS) {
    FORCE_UNSAFE_CONFIGURE = 1;
  }
