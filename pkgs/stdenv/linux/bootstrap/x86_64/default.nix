{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = file:///tmp/tarballs/static-tools.tar.bz2;
    sha1 = "4c72845335b373966341f1d4ca0b4b06904d1214";
  };

  binutilsURL = {
    url = file:///tmp/tarballs/binutils.tar.bz2;
    sha1 = "5ad0bdf99a427ebb8e08ca90db952c3eeb5119a4";
  };

  gccURL = {
    url = file:///tmp/tarballs/gcc.tar.bz2;
    sha1 = "7398e021fdd5d7c4b5a3bb158db6e7573fc1dc0f";
  };

  glibcURL = {
    url = file:///tmp/tarballs/glibc.tar.bz2;
    sha1 = "710b4a53425977858490f77188c7e2138b55a2dd";
  };
}
