{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.2.9";
  hash = "sha256-udq/LDIgxoesKPkFp/U68Fc6OBQdyFTG3RfSsAINp8I=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
