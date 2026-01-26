{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.3.6";
  hash = "sha256-rOENQaxjD4OQK4yCdVEeaCwJBzRhdIJ5nKUjNcmhvq8=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
