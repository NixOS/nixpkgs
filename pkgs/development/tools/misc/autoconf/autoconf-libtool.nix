{stdenv, fetchurl, m4, perl}:
derivation {
  name = "autoconf-2.58-automake-1.7.9-libtool-1.5";
  system = stdenv.system;
  builder = ./libtoolbuilder.sh;
  autoconfsrc = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/autoconf/autoconf-2.58.tar.bz2;
    md5 = "db3fa3069c6554b3505799c7e1022e2b";
  };
  automakesrc = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/automake/automake-1.7.9.tar.bz2;
    md5 = "571fd0b0598eb2a27dcf68adcfddfacb";
  };
  libtoolsrc = fetchurl {
    url = http://ftp.gnu.org/gnu/libtool/libtool-1.5.tar.gz;
    md5 = "0e1844f25e2ad74c3715b5776d017545";
  };
  stdenv = stdenv;
  m4 = m4;
  perl = perl;
}

