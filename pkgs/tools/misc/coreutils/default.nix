{stdenv, fetchurl, aclSupport ? false, acl, perl, gmp}:

stdenv.mkDerivation rec {
  name = "coreutils-8.3";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "0lghmjm6mmzxha7hdn2zz2dg6gsd4gqydp720p0gagr21q7lz9hh";
  };

  buildInputs = [ perl gmp ] ++ stdenv.lib.optional aclSupport acl;

  # The tests are known broken on Cygwin
  # (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19025).
  doCheck = (stdenv.system != "i686-cygwin");

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
