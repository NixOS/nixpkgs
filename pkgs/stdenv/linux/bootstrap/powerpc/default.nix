{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r6888/static-tools.tar.bz2;
    sha1 = "82acee6c1a895f3a45fdbf921d49be6c996abc5b";
  };

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r6888/binutils.tar.bz2;
    sha1 = "bc4f9fc931b0d139d0b16e548b1605d5181c74c0";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r6888/gcc.tar.bz2;
    sha1 = "ade3225a3135b0e3415cc8cb9e1bec61a742e200";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/powerpc/r6888/glibc.tar.bz2;
    sha1 = "e28476443e02b9c2e7881ced27c23cb039421cda";
  };
}
