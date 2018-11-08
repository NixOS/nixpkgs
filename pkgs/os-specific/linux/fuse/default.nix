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
    version = "3.3.0";
    sha256Hash = "1pwrnfm8jkxxqhrjz0v1gaw36hshgznchyj961qdk2y697y4zp19";
  };
}
