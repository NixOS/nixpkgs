{stdenv, fetchurl, aterm, toolbuslib, ptsupport, asfsupport, errorsupport, sglr}:

stdenv.mkDerivation {
  name = "asc-support-2.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/asc-support-2.0.tar.gz;
    md5 = "34368ca79e524157bf6e89281371cb5a";
  };
  inherit stdenv aterm ptsupport toolbuslib asfsupport errorsupport sglr;
  buildInputs = [stdenv aterm ptsupport toolbuslib asfsupport errorsupport sglr];
}
