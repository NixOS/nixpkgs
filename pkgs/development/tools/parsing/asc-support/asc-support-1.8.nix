{stdenv, fetchurl, aterm, toolbuslib, ptsupport, asfsupport}:

stdenv.mkDerivation {
  name = "asc-support-1.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/asc-support/asc-support-1.8.tar.gz;
    md5 = "e85a790c6004dfb974d79fc9699f69f4";
  };
  inherit stdenv aterm ptsupport toolbuslib asfsupport;
  buildInputs = [stdenv aterm ptsupport toolbuslib asfsupport];
}
