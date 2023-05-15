{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.0.6";
  sha256 = "sha256-GOxiGx2BU4x4A9W0k94gqXlhRwoixm0WK0UZN+LXkyQ=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
