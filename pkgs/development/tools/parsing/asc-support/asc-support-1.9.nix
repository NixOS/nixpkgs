{stdenv, fetchurl, aterm, toolbuslib, ptsupport, asfsupport, errorsupport, sglr}:

stdenv.mkDerivation {
  name = "asc-support-1.9";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/asc-support/asc-support-1.9.tar.gz;
    md5 = "0c395efec4d3b582af016ab03306ed0a";
  };
  inherit stdenv aterm ptsupport toolbuslib asfsupport errorsupport sglr;
  buildInputs = [stdenv aterm ptsupport toolbuslib asfsupport errorsupport sglr];
}
