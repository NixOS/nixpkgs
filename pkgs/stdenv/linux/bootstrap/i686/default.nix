{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = http://nixos.org/tarballs/stdenv-linux/i686/r13932/bootstrap-tools.cpio.bz2;
    sha256 = "12z35wnpcbjwczsr9fldp6bjpz7wh5qwylw6xfrr9l4s7gmk3m8a";
  };
}
