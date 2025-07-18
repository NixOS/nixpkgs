{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.3.1";
  hash = "sha256-wZD8SI2kAhLfz87RS0bKpI43KwSPHvstv/2zI/I4tVI=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
