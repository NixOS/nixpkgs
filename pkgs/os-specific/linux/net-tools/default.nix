{stdenv, fetchurl}:

derivation {
  name = "net-tools-1.60";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.tazenda.demon.co.uk/phil/net-tools/net-tools-1.60.tar.bz2;
    md5 = "888774accab40217dde927e21979c165";
  };
  config = ./config.h;
  inherit stdenv;
}
