{stdenv, fetchurl, m4, perl}:
stdenv.mkDerivation {
  name = "libtool-1.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/libtool/libtool-1.5.tar.gz;
    md5 = "0e1844f25e2ad74c3715b5776d017545";
  };
  m4 = m4;
  perl = perl;
}
