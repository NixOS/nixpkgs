{stdenv, fetchurl}:

derivation {
  name = "cksfv-1.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.fodder.org/cksfv/cksfv-1.3.tar.gz;
    md5 = "e00cf6a80a566539eb6f3432f2282c38";
  };
  stdenv = stdenv;
}
