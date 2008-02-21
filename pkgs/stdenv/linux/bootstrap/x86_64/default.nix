{
  bash = ./bash;
  bzip2 = ./bzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r9803/binutils.tar.bz2;
    sha1 = "9ac95e34c96c19cd0b925af46c97c9979becaaca";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r9803/gcc.tar.bz2;
    sha1 = "e8cb32425c8f55833ca081bd74668a029bdf1755";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r9803/glibc.tar.bz2;
    sha1 = "74b1698a4595ce4b4f43a33b3ceca1e4459e494e";
  };

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r9803/static-tools.tar.bz2;
    sha1 = "4da3af92c9bcd8fc43b31934d8429412e209741b";
  };
}
