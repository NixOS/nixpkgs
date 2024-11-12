{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.2.9";
  hash = "sha256-xvKFHAWUb1cqARWH57AOEdRzj5W7n0AgIUkEOBuRumo=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
