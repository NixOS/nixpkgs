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
    version = "3.8.0";
    sha256Hash = "0zbj5l2pffs0q38lqfrnkafsgxf50mw5mqmh4m2jmqab1fxg5mip";
  };
}
