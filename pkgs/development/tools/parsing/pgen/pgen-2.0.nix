{stdenv, getopt, fetchurl, aterm, toolbuslib, ptsupport, sdfsupport, asfsupport, ascsupport, sglr}:

stdenv.mkDerivation {
  name = "pgen-2.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pgen-2.0.tar.gz;
    md5 = "368cd8abeed29591a35660d8cea79975";
  };
  inherit        aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport sglr;
  buildInputs = [aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport sglr];
  propagatedBuildInputs = [getopt];
}
