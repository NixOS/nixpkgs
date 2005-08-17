{stdenv, fetchurl, aterm, getopt, pkgconfig}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.3.1";
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.3.1/sdf2-bundle-2.3.1.tar.gz;
    md5 = "4576b0b5315dccae8b038c53305c6979";
  };

  buildInputs = [aterm pkgconfig];
  propagatedBuildInputs = [getopt];
}
