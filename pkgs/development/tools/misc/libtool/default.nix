{stdenv, fetchurl, m4, perl}:
derivation {
  name = "libtool-1.5";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/libtool/libtool-1.5.tar.gz;
    md5 = "0e1844f25e2ad74c3715b5776d017545";
  };
  stdenv = stdenv;
  m4 = m4;
  perl = perl;
}
