{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.1.4";
  sha256 = "sha256-ZuzmNbc+qB6oYCnR5iAsSEQGTB+pk+ghF0/+O3BTLkA=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
