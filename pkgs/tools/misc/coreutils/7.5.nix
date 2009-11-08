{stdenv, fetchurl, aclSupport ? false, acl}:

stdenv.mkDerivation rec {
  name = "coreutils-7.5";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "1hf333y85fm0q7f1apx2zjjhivwj620nc8kcifdcm0sg8fwlj7rl";
  };

  buildInputs = stdenv.lib.optional aclSupport acl;

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
