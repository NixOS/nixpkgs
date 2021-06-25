{ callPackage, util-linux }:

let
  mkFuse = args: callPackage (import ./common.nix args) {
    inherit util-linux;
  };
in {
  fuse_2 = mkFuse {
    version = "2.9.9";
    sha256Hash = "1yxxvm58c30pc022nl1wlg8fljqpmwnchkywic3r74zirvlcq23n";
  };

  fuse_3 = mkFuse {
    version = "3.10.4";
    sha256Hash = "1ml4bs4wx5dbz5xpnd5g8b9avmn7g7jvf16fbdlk0da8il0qd2rx";
  };
}
