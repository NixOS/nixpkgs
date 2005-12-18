{
  # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false
  
, stdenv, fetchurl
}:

stdenv.mkDerivation {
  name = "gnupg-1.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.surfnet.nl/pub/security/gnupg/gnupg/gnupg-1.4.2.tar.bz2;
    md5 = "c7afd50c7d01fcfada229326b3958404";
  };
  idea = if ideaSupport then fetchurl {
    url = ftp://ftp.gnupg.dk/pub/contrib-dk/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  } else null;
}
