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
    version = "3.7.0";
    sha256Hash = "0l22gv5h84j5m7khs7l82jw834i8wf7hcgagpsn9y02x7ymmiha2";
  };
}
