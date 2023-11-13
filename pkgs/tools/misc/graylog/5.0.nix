{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.0.8";
  sha256 = "sha256-TGJm2PGoXaLhlzyfSWKScEJxEGObTVttpEEaczsXHiA=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
