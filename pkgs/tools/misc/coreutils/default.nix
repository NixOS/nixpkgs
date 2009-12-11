{stdenv, fetchurl, aclSupport ? false, acl, perl, gmp}:

stdenv.mkDerivation rec {
  name = "coreutils-8.2";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "0hagmpqm3wyx0hhw7i0mswary5w8flrk2vxhqfgfskam2rfhbhyk";
  };

  buildInputs = [ perl gmp ] ++ stdenv.lib.optional aclSupport acl;

  # The tests are known broken on Cygwin
  # (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19025).
  # For the rest, wait for upstream reply at:
  # http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19024 .
  doCheck = false;

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
