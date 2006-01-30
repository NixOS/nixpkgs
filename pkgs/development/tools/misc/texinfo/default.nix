{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "texinfo-4.8";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/texinfo-4.8.tar.bz2;
    md5 = "6ba369bbfe4afaa56122e65b3ee3a68c";
  };
  buildInputs = [ncurses];
}
