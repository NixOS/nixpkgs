{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "7.0.5";
  hash = "sha256-ipw8+zQThIiU6KX7ticQJqHFy7bK769DTNa2FIE/kUg=";
  maintainers = with lib.maintainers; [
    bbenno
    etwas
    robertjakub
  ];
  license = lib.licenses.sspl;
}
