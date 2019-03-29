{ callPackage, utillinux }:

let
  mkFuse = args: callPackage (import ./common.nix args) {
    inherit utillinux;
  };
in {
  fuse_2 = mkFuse {
    version = "2.9.9";
    sha256Hash = "1yxxvm58c30pc022nl1wlg8fljqpmwnchkywic3r74zirvlcq23n";
  };

  fuse_3 = mkFuse {
    version = "3.4.2";
    sha256Hash = "1w39fkasq9314qx141xb8v5qqcfvqbpr3higc4vv8y4b4i58fapi";
  };
}
