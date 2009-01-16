{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.21";
  
  src = fetchurl {
    url = mirror://gnu/tar/tar-1.21.tar.bz2;
    sha256 = "0l5kmq3s6rbps6h62li5a1yycchaa2mnhv8b8qlak90w0z970v6w";
  };
  
  patches = [./implausible.patch];

  meta = {
    homepage = http://www.gnu.org/software/grep/;
    description = "GNU implementation of the tar archiver";
  };
}
