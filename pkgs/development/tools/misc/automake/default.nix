{stdenv, fetchurl, perl, autoconf}:
derivation {
  name = "automake-1.7.9";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/automake/automake-1.7.9.tar.bz2;
    md5 = "571fd0b0598eb2a27dcf68adcfddfacb";
  };
  stdenv = stdenv;
  perl = perl;
  autoconf = autoconf;
}
