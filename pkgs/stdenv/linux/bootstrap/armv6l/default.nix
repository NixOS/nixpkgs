{
  sh = ../armv5tel/sh;
  bzip2 = ../armv5tel/bzip2;
  mkdir = ../armv5tel/mkdir;
  cpio = ../armv5tel/cpio;
  ln = ../armv5tel/ln;
  curl = ../armv5tel/curl.bz2;

  bootstrapTools = {
    # Built from make-bootstrap-tools-crosspi.nix
    # nixpkgs rev eb0422e4c1263a65a9b2b954fe10a1e03d67db3e
    url = http://viric.name/tmp/nix/pi/bootstrap-tools.cpio.bz2;
    sha256 = "1zb27x5h54k51yrvn3sy4wb1qprx8iv2kfbgklxwc0mcxp9b7ccd";
  };
}
