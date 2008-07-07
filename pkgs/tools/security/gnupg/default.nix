{
  # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false

, stdenv, fetchurl, readline
}:

stdenv.mkDerivation {
  name = "gnupg-1.4.9";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cert.dfn.de/pub/tools/crypt/gcrypt/gnupg/gnupg-1.4.9.tar.bz2;
    sha256 = "1p86mdgij3llnkx8dvvjl19abgq86gdn6m4r6bc4xvgfjg6sp99w";
  };
  buildInputs = [readline];
  idea = if ideaSupport then fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  } else null;

  meta = {
    description = "A free implementation of the OpenPGP standard for encrypting and signing data";
    homepage = http://www.gnupg.org/;
  };
}
