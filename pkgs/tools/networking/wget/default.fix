{stdenv, fetchurl}: derivation {
  name = "wget-1.9";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/wget/wget-1.9.tar.gz;
    md5 = "18ac093db70801b210152dd69b4ef08a";
  };
  stdenv = stdenv;
}
