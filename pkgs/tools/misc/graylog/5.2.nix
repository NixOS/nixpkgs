{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.2.7";
  sha256 = "sha256-so9IHX0r3dmj5wLrLtQgrcXk+hu6E8/1d7wJu1XDcVA=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
