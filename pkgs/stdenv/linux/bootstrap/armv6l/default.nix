{
  sh = ../armv5tel/sh;
  bzip2 = ../armv5tel/bzip2;
  mkdir = ../armv5tel/mkdir;
  cpio = ../armv5tel/cpio;
  ln = ../armv5tel/ln;
  curl = ../armv5tel/curl.bz2;

  bootstrapTools = {
    # Built from make-bootstrap-tools-crosspi.nix
    # nixpkgs rev f2f50c42d2c705dc59465c070f5259a4ad00cf4c
    url = http://viric.name/tmp/nix/pi/bootstrap-tools.cpio.bz2;
    sha256 = "1mpl4qgij43xiqhn173glz3ysrf3l3bnwvz07fiqr7lfmd7g54p5";
  };
}
