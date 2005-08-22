{stdenv, getopt, fetchurl, aterm, toolbuslib, ptsupport, sdfsupport, asfsupport, ascsupport, errorsupport, sglr}:

stdenv.mkDerivation {
  name = "pgen-2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pgen-2.1.tar.gz;
    md5 = "3fd46ae1ddc891a488f74350d7b477f9";
  };
  inherit        aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport errorsupport sglr;
  buildInputs = [aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport errorsupport sglr];
  propagatedBuildInputs = [getopt];
}
