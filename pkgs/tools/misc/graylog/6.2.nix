{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.2.8";
  hash = "";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
