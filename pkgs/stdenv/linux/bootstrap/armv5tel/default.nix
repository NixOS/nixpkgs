{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = "http://nixos.org/tarballs/stdenv-linux/armv5tel/r17267/bootstrap-tools.cpio.bz2";
    sha256 = "0b7mrcl7naj1xpqx1qnlmd825dxzikzhxir3mw4pr3dy28n0b2ka";
  };
}
