{stdenv, fetchurl, noSysDirs}:

derivation {
  name = "binutils-2.14";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/binutils/binutils-2.14.tar.bz2;
    md5 = "2da8def15d28af3ec6af0982709ae90a";
  };
  inherit stdenv noSysDirs;
}
