{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "gnupg-1.4.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gnupg_1.4.0.orig.tar.gz;
    md5 = "74e407a8dcb09866555f79ae797555da";
  };
}
