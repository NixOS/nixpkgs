{stdenv, fetchurl}: derivation {
  name = "par2cmdline-0.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/parchive/par2cmdline-0.3.tar.gz;
    md5 = "705c97bc41b862d281dd41c219a60849";
  };
  stdenv = stdenv;
}
