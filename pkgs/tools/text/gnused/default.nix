{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnused-4.1.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/sed-4.1.2.tar.gz;
    md5 = "928f0e06422f414091917401f1a834d0";
  };
}
