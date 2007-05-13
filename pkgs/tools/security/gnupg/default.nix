{
  # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false
  
, stdenv, fetchurl, readline
}:

stdenv.mkDerivation {
  name = "gnupg-1.4.7";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.surfnet.nl/pub/security/gnupg/gnupg/gnupg-1.4.7.tar.bz2;
    sha256 = "13a6qrgswbrfj3z5hcjx62ahraj4j16cpssgxlkwlqiz35yqplb9";
  };
  buildInputs = [readline];
  idea = if ideaSupport then fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  } else null;
}
