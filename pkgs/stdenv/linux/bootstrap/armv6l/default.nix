{
  sh = ../armv5tel/sh;
  bzip2 = ../armv5tel/bzip2;
  mkdir = ../armv5tel/mkdir;
  cpio = ../armv5tel/cpio;
  ln = ../armv5tel/ln;
  curl = ../armv5tel/curl.bz2;

  bootstrapTools = {
    url = http://viric.name/tmp/nix/pi/bootstrap-tools.cpio.bz2;
    sha256 = "01s4z461jv9plsxwkspjakdvjxzd5pd84i73nc2ynag5hmjyj63d";
  };
}
