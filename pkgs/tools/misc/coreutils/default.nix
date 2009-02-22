{stdenv, fetchurl, aclSupport ? false, acl}:

stdenv.mkDerivation rec {
  name = "coreutils-7.1";
  
  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "019a7kccrdnim2xigwsgc8dhiw0hb1y9q4344qs5z24sl6gv2g41";
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
