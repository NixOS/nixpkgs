{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = file:///tmp/tarballs/static-tools.tar.bz2;
    sha1 = "90ec30bbdac515e03c90b0909ee09a4cdcfe5214";
  };

  binutilsURL = {
    url = file:///tmp/tarballs/binutils.tar.bz2;
    sha1 = "577b256dcb5297a001acb8b49ce36e9c78ff8fc8";
  };

  gccURL = {
    url = file:///tmp/tarballs/gcc.tar.bz2;
    sha1 = "853d570c3419bddcf18d4340722880d2a80e2a3f";
  };

  glibcURL = {
    url = file:///tmp/tarballs/glibc.tar.bz2;
    sha1 = "d34e78fb4a0aa282318b1465e195bc2d4e6e7315";
  };
}
