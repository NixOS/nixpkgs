{ libsForQt5 }:
let
  common = opts: libsForQt5.callPackage (import ./common.nix opts) {};
in rec {
  new-engine = common rec {
    version = "A59";
    sha256 = "0m6hkj33vr75mrpjpdc0l38xv64kq73ph2mr2v9bs3wx4qlvg606";
    installFiles = [ "UEFITool/UEFITool" "UEFIFind/UEFIFind" "UEFIExtract/UEFIExtract" ];
  };
  old-engine = common rec {
    version = "0.28.0";
    sha256 = "1n2hd2dysi5bv2iyq40phh1jxc48gdwzs414vfbxvcharcwapnja";
    installFiles = [ "UEFITool" "UEFIReplace/UEFIReplace" "UEFIPatch/UEFIPatch" ];
  };
}
