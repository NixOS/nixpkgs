{stdenv, getopt, fetchurl, aterm, toolbuslib, ptsupport, sdfsupport, asfsupport, ascsupport, errorsupport, sglr}:

stdenv.mkDerivation {
  name = "pgen-2.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pgen-2.2.tar.gz;
    md5 = "e23323a96d7b1f72a0e10673fa93ef7c";
  };
  inherit        aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport errorsupport sglr;
  buildInputs = [aterm toolbuslib ptsupport sdfsupport asfsupport ascsupport errorsupport sglr];
  propagatedBuildInputs = [getopt];
}
