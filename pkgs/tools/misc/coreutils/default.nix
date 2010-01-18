{stdenv, fetchurl, aclSupport ? false, acl, perl, gmp}:

stdenv.mkDerivation rec {
  name = "coreutils-8.4";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "0zq11lykc7hfs9nsdnb8gqk354l82hswqj38607mvwj3b0zqvc4b";
  };

  buildInputs = [ perl gmp ] ++ stdenv.lib.optional aclSupport acl;

  # The tests are known broken on Cygwin
  # (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19025),
  # Darwin (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19351),
  # and {Open,Free}BSD.
  doCheck = (stdenv ? glibc);

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
