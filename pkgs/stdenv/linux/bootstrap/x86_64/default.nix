{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = file:///tmp/tarballs/static-tools.tar.bz2;
    sha1 = "312eab4537f0d3831089917d7d1e1bc44ecef41a";
  };

  binutilsURL = {
    url = file:///tmp/tarballs/binutils.tar.bz2;
    sha1 = "6e0e3cfb6a16cc2eb273e8feeacf64cf5570351c";
  };

  gccURL = {
    url = file:///tmp/tarballs/gcc.tar.bz2;
    sha1 = "babaec0a04c55f7cfe8938438ca8f078eabdebe1";
  };

  glibcURL = {
    url = file:///tmp/tarballs/glibc.tar.bz2;
    sha1 = "c68839c95bf2af3275aa37369afdf01c3dbfd416";
  };
}
