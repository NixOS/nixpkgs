{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.14";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/tar-1.14.tar.bz2;
    md5 = "f1932e0fbd4641885bfdcc75495c91b7";
  };
}
