{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.1.11";
  sha256 = "sha256-xvG9COKMNgHg5zzyCRfXsfrW3C2Gwbdxf8PMXQnJ2yg=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
