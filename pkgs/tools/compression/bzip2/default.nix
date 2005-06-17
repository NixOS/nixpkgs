{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bzip2-1.0.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.bzip.org/1.0.3/bzip2-1.0.3.tar.gz;
    md5 = "8a716bebecb6e647d2e8a29ea5d8447f";
  };
}
