{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6905/static-tools.tar.bz2;
    sha1 = "5467de09c91f0a9bf511a9d476547e10b9f067fb";
  };

  binutilsURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6905/binutils.tar.bz2;
    sha1 = "739623c8be225224ed57a76c5f483d5e373fdae8";
  };

  gccURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6905/gcc.tar.bz2;
    sha1 = "b4bb2b2863d7b368c7c32e789d6877e5b5a97637";
  };

  glibcURL = {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/x86_64/r6905/glibc.tar.bz2;
    sha1 = "f0a5e1a224931f59267975a51d4e9c20e6cb3ae8";
  };
}
