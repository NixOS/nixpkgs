{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-5.2.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/coreutils-5.2.1.tar.bz2;
    md5 = "172ee3c315af93d3385ddfbeb843c53f";
  };
}
