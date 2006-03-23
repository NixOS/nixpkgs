{
  # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false
  
, stdenv, fetchurl
}:

stdenv.mkDerivation {
  name = "gnupg-1.4.2.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.2.2.tar.bz2;
    sha1 = "f5559ddb004e0638f6bd9efe2bac00134c5065ba";
  };
  idea = if ideaSupport then fetchurl {
    url = ftp://ftp.gnupg.dk/pub/contrib-dk/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  } else null;
}
