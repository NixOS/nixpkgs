{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.0.14";
  hash = "sha256-PH3xAO4bb5SvcqZoRoQeRaIBZdGfoRd3Kcnr603hYaI=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
