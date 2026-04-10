{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "7.0.6";
  hash = "sha256-x4V5Bfw2QluWL0UrRa0nPZ2X0HbXsZ8AzbbRP5ZxV3o=";
  maintainers = with lib.maintainers; [
    bbenno
    etwas
    robertjakub
    f2k1de
  ];
  license = lib.licenses.sspl;
}
