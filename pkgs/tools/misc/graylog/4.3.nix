{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "4.3.9";
  sha256 = "sha256-BMw6U47LQQFFVM34rgadMetpYTtj6R3E+uU0dtTcH64=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
