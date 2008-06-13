{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.20";
  
  src = fetchurl {
    url = mirror://gnu/tar/tar-1.20.tar.bz2;
    sha256 = "1swx3whm2vh0qzq8v04vgwk5zds6zlznk52xwivj7p2szcxg72xy";
  };
  
  patches = [./implausible.patch];

  meta = {
    homepage = http://www.gnu.org/software/grep/;
    description = "GNU implementation of the tar archiver";
  };
}
