{stdenv, fetchurl, perl, autoconf}:
stdenv.mkDerivation {
  name = "automake-1.7.9";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/automake/automake-1.7.9.tar.bz2;
    md5 = "571fd0b0598eb2a27dcf68adcfddfacb";
  };
  perl = perl;
  autoconf = autoconf;
}
