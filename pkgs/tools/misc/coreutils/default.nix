{ stdenv, fetchurl, perl, gmp ? null
, aclSupport ? false, acl ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> ( (libselinux != null) && (libsepol != null) );

stdenv.mkDerivation rec {
  name = "coreutils-8.15";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.xz";
    sha256 = "176lgw810xw84c6fz5xwhydxggkndmzggl0pxqzldbjf85vv6zl3";
  };

  buildNativeInputs = [ perl ];
  buildInputs = [ gmp ]
    ++ stdenv.lib.optional aclSupport acl
    ++ stdenv.lib.optional selinuxSupport libselinux
    ++ stdenv.lib.optional selinuxSupport libsepol;

  crossAttrs = {
    buildInputs = [ gmp ]
      ++ stdenv.lib.optional aclSupport acl.hostDrv
      ++ stdenv.lib.optional selinuxSupport libselinux.hostDrv
      ++ stdenv.lib.optional selinuxSupport libsepol.hostDrv
      ++ stdenv.lib.optional (stdenv.gccCross.libc ? libiconv)
        stdenv.gccCross.libc.libiconv.hostDrv;

    # Needed for fstatfs()
    # I don't know why it is not properly detected cross building with glibc.
    configureFlags = [ "fu_cv_sys_stat_statfs2_bsize=yes" ];
    doCheck = false;
  };

  # The tests are known broken on Cygwin
  # (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19025),
  # Darwin (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19351),
  # and {Open,Free}BSD.
  doCheck = (stdenv ? glibc);

  enableParallelBuilding = true;

  NIX_LDFLAGS = stdenv.lib.optionalString selinuxSupport "-lsepol";

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

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}

