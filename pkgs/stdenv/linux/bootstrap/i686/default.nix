{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = http://nixos.org/tarballs/stdenv-linux/i686/r16022/bootstrap-tools.cpio.bz2;
    sha256 = "1x014icv3dxfs55qzshxjs9gaczmhwlrn144p4314zvl4xz6wq3f";
  };
}
