{ libsForQt5 }:
let
  common = opts: libsForQt5.callPackage (import ./common.nix opts) {};
in rec {
  new-engine = common rec {
    version = "A60";
    sha256 = "sha256-E99Mf2T6Bg4NsFXzFn4kNf602DmtiyBk6Vcj6JfOPR0=";
    installFiles = [ "UEFITool/UEFITool" "UEFIFind/UEFIFind" "UEFIExtract/UEFIExtract" ];
  };
  old-engine = common rec {
    version = "0.28.0";
    sha256 = "1n2hd2dysi5bv2iyq40phh1jxc48gdwzs414vfbxvcharcwapnja";
    installFiles = [ "UEFITool" "UEFIReplace/UEFIReplace" "UEFIPatch/UEFIPatch" ];
  };
}
