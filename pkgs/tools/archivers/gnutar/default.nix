{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.13.25";
  src = fetchurl {
    url = ftp://alpha.gnu.org/gnu/tar/tar-1.13.25.tar.gz;
    md5 = "6ef8c906e81eee441f8335652670ac4a";
  };
}
