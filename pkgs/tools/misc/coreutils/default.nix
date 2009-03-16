{stdenv, fetchurl, aclSupport ? false, acl}:

stdenv.mkDerivation {
  name = "coreutils-6.12";
  
  src = fetchurl {
    url = mirror://gnu/coreutils/coreutils-7.1.tar.gz;
    sha256 = "019a7kccrdnim2xigwsgc8dhiw0hb1y9q4344qs5z24sl6gv2g41";
  };

  meta = {
    homepage = http://www.gnu.org/software/coreutils/;
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";
  };

  buildInputs = stdenv.lib.optional aclSupport acl;
  # Older kernels: patches = ./setting-time-backward-compatibility.patch;
}
