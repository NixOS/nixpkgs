{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "autoconf-2.58";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/autoconf-2.58.tar.bz2;
    md5 = "db3fa3069c6554b3505799c7e1022e2b";
  };
  buildInputs = [m4 perl];
}
