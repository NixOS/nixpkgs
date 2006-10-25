{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6842/static-tools.tar.bz2;
    sha1 = "46899b48cba2f7a53d6c283f4a3706c046900924";
  };

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6842/binutils.tar.bz2;
    sha1 = "b76ff6427f6930059a548c507fda9860ab31affb";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6842/gcc.tar.bz2;
    sha1 = "ba8e05b80f0fd779c96d597135961f028b4fabcf";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6842/glibc.tar.bz2;
    sha1 = "76774fdc2d73e78d6b63f53507feb01070628dbe";
  };
}
