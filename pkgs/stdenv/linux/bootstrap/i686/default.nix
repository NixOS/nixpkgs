{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6824/static-tools.tar.bz2;
    sha1 = "4cc936e5c5881eb1466dd8c2cb968e255fa446b7";
  };

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6824/binutils.tar.bz2;
    sha1 = "d7d85684fae7ec5b51d31e105f8fc041a3553c82";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6824/gcc.tar.bz2;
    sha1 = "c1a6f1a6de2cd3cc1b112614661c9f6adf8a6377";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6824/glibc.tar.bz2;
    sha1 = "666b5a6c179bd6aedeeb40d34336716eb0d659ce";
  };
}
