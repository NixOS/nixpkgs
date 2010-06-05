{stdenv, fetchurl, bzip2}:

stdenv.mkDerivation {
  name = "bsdiff-4.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.daemonology.net/bsdiff/bsdiff-4.3.tar.gz;
    sha256 = "0j2zm3z271x5aw63mwhr3vymzn45p2vvrlrpm9cz2nywna41b0hq";
  };
  buildInputs = [ bzip2 ];
  patchPhase = ''
    sed 's/^\.//g' -i Makefile
  '';
}
