{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.3.2";
  hash = "sha256-t0E8RriEgNk/LAlhbZYOJUDwrq22JEiyF5qi2pGmcbI=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
