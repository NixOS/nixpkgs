{stdenv, fetchurl, aterm, getopt}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.3/sdf2-bundle-2.3.tar.gz;
    md5 = "523b9b9e4f73ef6abad65d61e9635389";
  };

  buildInputs = [aterm];
  propagatedBuildInputs = [getopt];
  inherit aterm;
}
