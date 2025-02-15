{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.1.3";
  hash = "sha256-qH4NXhEx0GenqUCFVKq/eoxb6bJNbilE5k3+7rZ2x8s=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
