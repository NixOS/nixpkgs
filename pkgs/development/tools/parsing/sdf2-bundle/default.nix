{stdenv, fetchurl, aterm, getopt}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.2.tar.gz;
    md5 = "995a1739134615b60b1fe796d6c9d0e6";
  };
  buildInputs = [aterm];
  propagatedBuildInputs = [getopt];
  inherit aterm;
}
