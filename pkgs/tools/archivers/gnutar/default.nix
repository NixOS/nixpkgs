{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.19";
  
  src = fetchurl {
    url = mirror://gnu/tar/tar-1.19.tar.bz2;
    sha256 = "1d4wh27wlgryz3ld6gp6fn56knh7dmny93bmgixy07kvlxnx9466";
  };
  
  patches = [./implausible.patch];

  meta = {
    homepage = http://www.gnu.org/software/grep/;
    description = "GNU implementation of the tar archiver";
  };
}
