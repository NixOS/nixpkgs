{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "libtool-1.5.14";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libtool-1.5.14.tar.gz;
    md5 = "049bf67de9b0eb75cd943dafe3d749ec";
  };
  buildInputs = [m4 perl];
}
