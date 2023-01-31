{ libsForQt5 }:
let
  common = opts: libsForQt5.callPackage (import ./common.nix opts) {};
in rec {
  new-engine = common rec {
    version = "A63";
    sha256 = "sha256-QdAU/rO9DzZK9FClokvirWUIvMCOsoFRJ7uLnFvp5Og=";
    installFiles = [ "build/UEFITool/UEFITool" "build/UEFIFind/UEFIFind" "build/UEFIExtract/UEFIExtract" ];
  };
  old-engine = common rec {
    version = "0.28.0";
    sha256 = "1n2hd2dysi5bv2iyq40phh1jxc48gdwzs414vfbxvcharcwapnja";
    installFiles = [ "UEFITool" "UEFIReplace/UEFIReplace" "UEFIPatch/UEFIPatch" ];
  };
}
