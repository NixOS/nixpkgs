{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = http://nixos.org/tarballs/stdenv-linux/i686/r24519/bootstrap-tools.cpio.bz2;
    sha256 = "0imypaxy6piwbk8ff2y1nr7yk49pqmdgdbv6g8miq1zs5yfip6ij";
  };
}
