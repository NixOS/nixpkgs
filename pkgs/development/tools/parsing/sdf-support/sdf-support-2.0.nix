{stdenv, fetchurl, aterm, toolbuslib, ptsupport}: derivation {
  name = "sdf-support-2.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/sdf-support/sdf-support-2.0.tar.gz;
    md5 = "2987b89ed1d73e34e128b895ff44264c";
  };
  stdenv = stdenv;
  aterm = aterm;
  ptsupport = ptsupport;
  toolbuslib = toolbuslib;
}
