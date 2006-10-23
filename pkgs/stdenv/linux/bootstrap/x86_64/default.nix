{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = file:///tmp/tarballs/static-tools.tar.bz2;
    sha1 = "806f9644bf155069315bdd66138764b3d8619348";
  };

  binutilsURL = {
    url = file:///tmp/tarballs/binutils.tar.bz2;
    sha1 = "b55055c50cfcd2ab02e20f49ad8ca72315252a1c";
  };

  gccURL = {
    url = file:///tmp/tarballs/gcc.tar.bz2;
    sha1 = "a2ac17b6e7ce6d07c01e090b801c1622f56d8b39";
  };

  glibcURL = {
    url = file:///tmp/tarballs/glibc.tar.bz2;
    sha1 = "59d4d5a25ecd8b2f741d80e80d172bd6e7e06d89";
  };
}
