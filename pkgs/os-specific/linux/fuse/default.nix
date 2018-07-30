{ callPackage, utillinux }:

let
  mkFuse = args: callPackage (import ./common.nix args) {
    inherit utillinux;
  };
in {
  fuse_2 = mkFuse {
    version = "2.9.8";
    sha256Hash = "0s04ln4k9zvvbjih8ybaa19fxg8xv7dcsz2yrlbk35psnf3l67af";
  };

  fuse_3 = mkFuse {
    version = "3.2.5";
    sha256Hash = "0ibf2isbkm8p1gfaqpqblwsg0lm4s1rmcipv1qcg0wc4wwsbnqpx";
  };
}
