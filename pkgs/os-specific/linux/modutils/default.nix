{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation {
  name = "modutils-2.4.25";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/modutils-2.4.25.tar.bz2;
    md5 = "2c0cca3ef6330a187c6ef4fe41ecaa4d";
  };
  buildInputs = [bison flex];
}
