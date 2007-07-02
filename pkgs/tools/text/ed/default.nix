{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "ed-0.6";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/ed/ed-0.6.tar.bz2;
    sha256 = "1fzp9nj8gm4z0d2v486zwqqy8nqx730ygad82zvj0akcnlq7csax";
  };
}
