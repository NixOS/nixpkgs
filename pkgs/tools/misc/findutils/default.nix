{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "findutils-4.1.20";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/findutils-4.1.20.tar.gz;
    md5 = "e90ce7222daadeb8616b8db461e17cbc";
  };
}
