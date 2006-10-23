{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6800/static-tools.tar.bz2;
    sha1 = "18c5e93a23a16282a12e9af05f4dc28254dc9013";
  };

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6800/binutils.tar.bz2;
    sha1 = "4bf2859aa705acdcc08d333200f0e55754fab4a9";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6800/gcc.tar.bz2;
    sha1 = "bd69a67b779014a683fa93706497eef0afede2b2";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/i686/r6800/glibc.tar.bz2;
    sha1 = "9f3f3f1248d672d5a845326ed36d8ca470de0094";
  };
}
