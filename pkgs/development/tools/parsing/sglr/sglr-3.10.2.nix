{stdenv, fetchurl, aterm, toolbuslib, ptsupport}: derivation {
  name = "sglr-3.10.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/sglr/sglr-3.10.2.tar.gz;
    md5 = "39aa609be84115d7ddc56a6c74b792b7";
  };
  stdenv = stdenv;
  aterm = aterm;
  ptsupport = ptsupport;
  toolbuslib = toolbuslib;
}
