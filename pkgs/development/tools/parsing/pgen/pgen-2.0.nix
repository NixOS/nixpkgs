{stdenv, getopt, fetchurl, aterm, toolbuslib, ptsupport, sdfsupport, asfsupport, ascsupport, sglr}: derivation {
  name = "pgen-2.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/pgen/pgen-2.0.tar.gz;
    md5 = "368cd8abeed29591a35660d8cea79975";
  };
  stdenv = stdenv;
  aterm = aterm;
  getopt = getopt;
  toolbuslib = toolbuslib;
  ptsupport = ptsupport;
  sdfsupport = sdfsupport;
  asfsupport = asfsupport;
  ascsupport = ascsupport;
  sglr = sglr;
}