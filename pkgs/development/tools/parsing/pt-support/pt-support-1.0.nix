{stdenv, fetchurl, aterm, toolbuslib}: derivation {
  name = "pt-support-1.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/pt-support/pt-support-1.0.tar.gz;
    md5 = "cc96dc2bfbaf3f218dfe9a0b8bb4d801";
  };
  stdenv = stdenv;
  aterm = aterm;
  toolbuslib = toolbuslib;
}
