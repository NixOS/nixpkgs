{stdenv, fetchurl, aclSupport ? false, acl}:

stdenv.mkDerivation rec {
  name = "coreutils-7.0";
  
  src = fetchurl {
    # Version 7.0 is marked as "beta", which is why it's on `alpha.gnu.org'.
    # See http://lists.gnu.org/archive/html/bug-coreutils/2008-10/msg00064.html .
    url = "ftp://alpha.gnu.org/gnu/coreutils/${name}.tar.gz";
    sha256 = "00cwf8rqbj89ikv8fhdhv26dpc2ghzw1hn48pk1vg3nnmxj55nr7";
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
