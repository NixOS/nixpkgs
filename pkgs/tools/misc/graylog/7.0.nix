{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "7.0.0";
  hash = "sha256-M8FM3qErHhW7ydp62ncQQ8SpaPynpG24/k2auAWeS28=";
  maintainers = with lib.maintainers; [ etwas ];
  license = lib.licenses.sspl;
}
