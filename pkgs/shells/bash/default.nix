{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bash-2.05b";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.net/pub/gnu/bash/bash-2.05b.tar.gz;
    md5 = "5238251b4926d778dfe162f6ce729733";
  };
}
