{stdenv, fetchurl, aterm, toolbuslib, ptsupport, asfsupport}: derivation {
  name = "asc-support-1.8";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/asc-support/asc-support-1.8.tar.gz;
    md5 = "e85a790c6004dfb974d79fc9699f69f4";
  };
  stdenv = stdenv;
  aterm = aterm;
  ptsupport = ptsupport;
  toolbuslib = toolbuslib;
  asfsupport = asfsupport;
}
