{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.1.13";
  sha256 = "sha256-qjNJ51EbPjtDR5h4DElpSblj/c8WarXxPfcLTuTx5AQ=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
