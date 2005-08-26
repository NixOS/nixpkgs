{stdenv, fetchurl, aterm, getopt, pkgconfig}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.3.2";
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.3.2/sdf2-bundle-2.3.2.tar.gz;
    md5 = "f548251570a903a7d26de50533ff0c9c";
  };

  buildInputs = [aterm pkgconfig];
  propagatedBuildInputs = [getopt];
}
