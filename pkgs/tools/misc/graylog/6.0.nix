{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "6.0.4";
  hash = "sha256-PU7AepIRwx7FibBkZaQUWUy3v2MeM7cS77FH28aj8I8=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
