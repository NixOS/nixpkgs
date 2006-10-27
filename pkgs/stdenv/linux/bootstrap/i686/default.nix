{
  bash = ./bash;
  bunzip2 = ./bunzip2;
  cp = ./cp;
  curl = ./curl.bz2;
  tar = ./tar.bz2;

  staticToolsURL = {
    url = file:///tmp/tarballs/static-tools.tar.bz2;
    sha1 = "c366d9ee0d969e68311fdb37abc91b46fb13b585";
  };

  binutilsURL = {
    url = file:///tmp/tarballs/binutils.tar.bz2;
    sha1 = "fa77c29ef4f13ddf43bba3f4f020ceafa6604ccc";
  };

  gccURL = {
    url = file:///tmp/tarballs/gcc.tar.bz2;
    sha1 = "ea7171fc2f70880e8a6c2480b3d3fed7409b7a4e";
  };

  glibcURL = {
    url = file:///tmp/tarballs/glibc.tar.bz2;
    sha1 = "728e0a9e66e01cf2815eca8cc638e5ed140a36cd";
  };
}
