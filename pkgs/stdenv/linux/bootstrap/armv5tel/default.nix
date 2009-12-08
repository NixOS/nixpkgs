{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = "http://nixos.org/tarballs/stdenv-linux/armv5tel/r18744/bootstrap-tools.cpio.bz2";
    sha256 = "1rn4n5kilqmv62dfjfcscbsm0w329k3gyb2v9155fsi1sl2cfzcb";
  };
}
