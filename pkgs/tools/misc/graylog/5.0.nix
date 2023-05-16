{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.0.7";
  sha256 = "sha256-wGw7j1vBa0xcoyfrK7xlLGKElF1SV2ijn+uQ8COj87Y=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
