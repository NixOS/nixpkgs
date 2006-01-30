{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "zip-2.31";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/zip231.tar.gz;
    md5 = "6bfc076664416251d7624ab3538d1cb9";
  };
}
