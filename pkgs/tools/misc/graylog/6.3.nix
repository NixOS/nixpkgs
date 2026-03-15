{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.3.10";
  hash = "sha256-uHGlHOL8+6qFn2sSlzzp2Vl3lmCc7bpQD4eHDg6zmK0=";
  maintainers = with lib.maintainers; [
    bbenno
    robertjakub
  ];
  license = lib.licenses.sspl;
}
