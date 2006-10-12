{
  # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false
  
, stdenv, fetchurl, readline
}:

stdenv.mkDerivation {
  name = "gnupg-1.4.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gnupg-1.4.5.tar.bz2;
    sha1 = "553fefe0da5a91108dd9468e381faf9487754f9a";
  };
  buildInputs = [readline];
  idea = if ideaSupport then fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  } else null;
}
