{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "diffutils-2.8.1";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/diffutils/diffutils-2.8.1.tar.gz;
    md5 = "71f9c5ae19b60608f6c7f162da86a428";
  };
}
