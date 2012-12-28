{
  sh = ../armv5tel/sh;
  bzip2 = ../armv5tel/bzip2;
  mkdir = ../armv5tel/mkdir;
  cpio = ../armv5tel/cpio;
  ln = ../armv5tel/ln;
  curl = ../armv5tel/curl.bz2;

  bootstrapTools = {
    # Built from make-bootstrap-tools-crosspi.nix
    # nixpkgs rev 87ec7b49b120950a260d9733de7f34d7c2bffb98
    url = http://viric.name/tmp/nix/pi/bootstrap-tools.cpio.bz2;
    sha256 = "04qy8cqd30pqhil62b9sx67ijdspf9npx2snwwrcwvk3zbyhcll3";
  };
}
