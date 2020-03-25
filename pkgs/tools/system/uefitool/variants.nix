{ libsForQt5 }:
let
  common = opts: libsForQt5.callPackage (import ./common.nix opts) {};
in rec {
  new-engine = common rec {
    version = "A57";
    sha256 = "0algfdlxfjs582hsqmagbcmw06p8qlh0k5xczfkscs3prdn2vm7n";
    installFiles = [ "UEFITool/UEFITool" "UEFIFind/UEFIFind" "UEFIExtract/UEFIExtract" ];
  };
  old-engine = common rec {
    version = "0.27.0";
    sha256 = "1i1p823qld927p4f1wcphqcnivb9mq7fi5xmzibxc3g9zzgnyc2h";
    installFiles = [ "UEFITool" "UEFIReplace/UEFIReplace" "UEFIPatch/UEFIPatch" ];
  };
}
