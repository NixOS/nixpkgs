{
  # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false
  
, stdenv, fetchurl
}:

stdenv.mkDerivation {
  name = "gnupg-1.4.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.4.tar.bz2;
    sha1 = "3414d67f22973576f31e354f44859bafbccb7eee";
  };
  idea = if ideaSupport then fetchurl {
    url = ftp://ftp.gnupg.dk/pub/contrib-dk/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  } else null;
}
