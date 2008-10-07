{stdenv, fetchurl, aclSupport ? false, acl}:

stdenv.mkDerivation {
  name = "coreutils-6.12";
  
  src = fetchurl {
    url = mirror://gnu/coreutils/coreutils-6.12.tar.gz;
    sha256 = "12pi7i2mxff5jab48pqpwlz2pi0j6sp9p7bgrcl663iiw81zglj9";
  };

  buildInputs = stdenv.lib.optional aclSupport acl;
  
  # Support older Linux kernels.
  patches = [ ./setting-time-backward-compatibility.patch ];
  
  meta = {
    homepage = http://www.gnu.org/software/coreutils/;
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";
  };
}
