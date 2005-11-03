{stdenv, fetchurl, aterm, getopt, pkgconfig}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.3.3";
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.3.3/sdf2-bundle-2.3.3.tar.gz;
    md5 = "62ecabe5fbb8bbe043ee18470107ef88";
  };

  buildInputs = [aterm pkgconfig];
  propagatedBuildInputs = [getopt];
}
