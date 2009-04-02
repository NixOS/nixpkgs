{stdenv, fetchurl, aclSupport ? false, acl}:

stdenv.mkDerivation rec {
  name = "coreutils-7.2";
  
  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "1cpx66kwcg5w78by8i27wb24j0flz2ivv9fqmd4av8z5jbnbyxyx";
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
  };
}
