{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gzip-1.3.3";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gzip-1.3.3.tar.gz;
    md5 = "52eaf713673507d21f7abefee98ba662";
  };
}
