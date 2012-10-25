{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = "http://nixos.org/tarballs/stdenv-linux/loongson2f/r22849/cross-bootstrap-tools.cpio.bz2";
    sha256 = "00aavbk76qjj2gdlmpaaj66r8nzl4d7pyl8cv1gigyzgpbr5vv3j";
  };
}
