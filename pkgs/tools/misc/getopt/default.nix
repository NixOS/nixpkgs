{stdenv, fetchurl}: derivation {
  name = "getopt-1.1.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://huizen.dds.nl/~frodol/getopt-1.1.3.tar.gz;
    md5 = "7b7637dcb0ac531f1af29f4d6b018e86";
  };
  stdenv = stdenv;
}
