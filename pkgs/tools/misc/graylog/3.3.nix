{ callPackage, lib }:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "3.3.16";
  sha256 = "sha256-P/cnfYKnMSnDD4otEyirKlLaFduyfSO9sao4BY3c3Z4=";
  maintainers = [ lib.maintainers.fadenb ];
  license = lib.licenses.gpl3;
}
