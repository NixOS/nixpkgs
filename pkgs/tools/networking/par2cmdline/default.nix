{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "par2cmdline-0.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/par2cmdline-0.3.tar.gz;
    md5 = "705c97bc41b862d281dd41c219a60849";
  };
}
