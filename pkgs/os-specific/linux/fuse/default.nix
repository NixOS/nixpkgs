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
    version = "3.11.0";
    sha256Hash = "1wx80xxlvjn0wxhmkr1g91vwrgxssyzds1hizzxc2xrd4kjh9dfb";
  };
}
