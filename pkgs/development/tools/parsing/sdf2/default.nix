{stdenv, fetchurl, aterm, getopt}:

stdenv.mkDerivation {
  name = "sdf2-2.0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.0.1.tar.gz;
    md5 = "ceba34dc8e53fba04ad3be73627f0a20";
  };
  buildInputs = [aterm];
  propagatedBuildInputs = [getopt];
  inherit aterm;
}
