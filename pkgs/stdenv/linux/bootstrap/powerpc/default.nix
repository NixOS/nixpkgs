{
  bash = ./bash;
  bzip2 = ./bzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r9828/static-tools.tar.bz2;
    sha1 = "e4d1680e3dfa752e49a996a31140db53b10061cb";
  };

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r9828/binutils.tar.bz2;
    sha1 = "2609f4d9277a60fcd178395d3d49911190e08f36";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r9828/gcc.tar.bz2;
    sha1 = "71d79d736bfef6252208fe6239e528a591becbed";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r9828/glibc.tar.bz2;
    sha1 = "bf0245e16235800c8aa9c6a5de6565583a66e46d";
  };
}
