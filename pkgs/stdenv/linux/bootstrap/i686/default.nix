{
  bash = ./bash;
  bzip2 = ./bzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r9803/binutils.tar.bz2;
    sha1 = "73532561c2f98d0df641fbd778bc92cea298762a";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r9803/gcc.tar.bz2;
    sha1 = "522dc2e22dc42f640b0290638382d45bd43a7d55";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r9803/glibc.tar.bz2;
    sha1 = "b9ae1e43e9977476ef53f8c1c9cd1cff5526ff40";
  };

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r9803/static-tools.tar.bz2;
    sha1 = "ebe826e848736a82bcdd9a195dd510b533ecc997";
  };
}
