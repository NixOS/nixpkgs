{stdenv, fetchurl, m4}:
assert m4 != null;
stdenv.mkDerivation {
  name = "bison-1.875";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/bison/bison-1.875.tar.bz2;
    md5 = "b7f8027b249ebd4dd0cc948943a71af0";
  };
  m4 = m4;
}
