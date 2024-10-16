{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "6.0.7";
  hash = "sha256-whLU1d0wmmdSiMESpzmCTHe5U7GXVHefsonTPO7d7rY=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
