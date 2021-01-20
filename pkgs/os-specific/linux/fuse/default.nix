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
    version = "3.10.1";
    sha256Hash = "0bb22mac8m0z6qp0s6g4r0x4aj6gc19pfyqr6sdy4hkpwxicgmaf";
  };
}
