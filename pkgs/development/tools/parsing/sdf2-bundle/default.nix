{stdenv, fetchurl, aterm, getopt}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.3/sdf2-bundle-2.3.tar.gz;
    md5 = "79e305c2bdb2a5627719c890fb050bfa";
  };

  buildInputs = [aterm];
  propagatedBuildInputs = [getopt];
  inherit aterm;
}
