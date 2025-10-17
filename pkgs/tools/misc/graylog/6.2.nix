{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.2.5";
  hash = "sha256-vlUqwiJMoMVODhjGs5s4J3de23NXdIFT8eRNZFanQpw=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
