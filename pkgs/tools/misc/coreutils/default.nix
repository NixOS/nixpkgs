{ stdenv, fetchurl, perl, gmp ? null
, aclSupport ? false, acl ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> libselinux != null && libsepol != null;


with { inherit (stdenv.lib) optional optionals optionalString optionalAttrs; };

let
  self = stdenv.mkDerivation (rec {
    name = "coreutils-8.21";

    src = fetchurl {
      url = "mirror://gnu/coreutils/${name}.tar.xz";
      sha256 = "064f512185iysqqcvhnhaf3bfmzrvcgs7n405qsyp99zmfyl9amd";
    };

    nativeBuildInputs = [ perl ];
    buildInputs = [ gmp ]
      ++ optional aclSupport acl
      ++ optionals selinuxSupport [ libselinux libsepol ];

    crossAttrs = {
      buildInputs = [ gmp ]
        ++ optional aclSupport acl.crossDrv
        ++ optionals selinuxSupport [ libselinux.crossDrv libsepol.crossDrv ]
        ++ optional (stdenv.gccCross.libc ? libiconv)
          stdenv.gccCross.libc.libiconv.crossDrv;

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

    enableParallelBuilding = true;

    NIX_LDFLAGS = optionalString selinuxSupport "-lsepol";

    meta = {
      homepage = http://www.gnu.org/software/coreutils/;
      description = "The basic file, shell and text manipulation utilities of the GNU operating system";

      longDescription = ''
        The GNU Core Utilities are the basic file, shell and text
        manipulation utilities of the GNU operating system.  These are
        the core utilities which are expected to exist on every
        operating system.
      '';

      license = "GPLv3+";

      maintainers = [ ];
    };
  } // optionalAttrs stdenv.isDarwin {
    makeFlags = "CFLAGS=-D_FORTIFY_SOURCE=0";
  });
in
  self
