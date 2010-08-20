{ stdenv, fetchurl, aclSupport ? false, acl ? null, perl, gmp ? null}:

assert aclSupport -> acl != null;

stdenv.mkDerivation rec {
  name = "coreutils-8.5";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "184cz98a9a6fw5db9hpy05srwxs3jqlvikqf2wxj1vfhqwm3w96x";
  };

  buildNativeInputs = [ perl ];
  buildInputs = [ gmp ] ++ stdenv.lib.optional aclSupport acl;

  crossAttrs = {
    buildInputs = [ gmp ]
      ++ stdenv.lib.optional aclSupport acl.hostDrv
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
