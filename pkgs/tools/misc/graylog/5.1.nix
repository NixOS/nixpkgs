{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.1.10";
  sha256 = "sha256-KXhZrM13wBD9k0Pe0NqpnD/+RFHSWAkCdFcVIKjVxt4=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
